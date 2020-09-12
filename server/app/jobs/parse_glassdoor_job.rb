class ParseGlassdoorJob < ApplicationJob
  queue_as :default


  def perform(url, keywords, scheduled)

    page = RestClient::Request.execute(
      method: :get, 
      url: url,
      timeout: 50, 
      headers: {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"})
    doc = JSON.parse(page)
    begin
      if doc["success"]
        doc["response"]["jobListings"].each{|listing|
          params = {}
          params[:title] = listing["jobTitle"]
          link = listing["jobViewUrl"]
          params[:link] = "https://www.glassdoor.com" + link
          loc = listing["location"]
          loc = loc.split(", ")
          if loc[1]
            params[:city] = (loc[0]).strip
            params[:state] = loc[1]
          else
          end
          params[:used_keywords] = keywords
          params[:company] = listing["employer"]["name"]
          if listing["salaryEstimate"]
            params[:salary] = listing["salaryEstimate"]["salary_percentile_50"]
          end
          posting = Posting.create(params)
          if posting.valid?
            ScheduledPosting.create(posting_id: posting.id)
          end
        }
        if doc["response"]["currentPageNumber"] < doc["response"]["totalNumberOfPages"]
          if url.include?("&p=")
            nextPage = url.sub!("&p=#{doc["response"]["currentPageNumber"]}","&p=#{doc["response"]["currentPageNumber"]+1}")
          else
            nextPage = url + "&p=2"
          end
          ScheduledPosting.create(url: nextPage, keywords: keywords)
        end
        scheduled.update(status: "done")
      else
        puts "Request denied by glassdoor"
        scheduled.update(status: "error")
      end
    rescue
      scheduled.update(status: "error")
    end
  end


end
