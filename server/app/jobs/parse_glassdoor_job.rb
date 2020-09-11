class ParseGlassdoorJob < ApplicationJob
  queue_as :default

  @@all = 0

  def perform(url, keywords, pause)
    sleep(pause)
    # puts "parsing " + url
    page = RestClient::Request.execute(
      method: :get, 
      url: url,
      timeout: 50, 
      headers: {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"})
    doc = JSON.parse(page)
    if doc["success"]
      doc["response"]["jobListings"].each{|listing|
        params = {}
        params[:title] = listing["jobTitle"]

        link = listing["jobViewUrl"]
        # dom  = "https://www.glassdoor.com/partner/jobListing.htm?" #ao=465888&jobListingId=3651420494"
        # rawurl = link.split("&")
        # ao = rawurl.find{|part| part.include?("ao=")}
        # jobListingId = rawurl.find{|part| part.include?("jobListingId=")}
        # url = dom + ao + '&' + jobListingId
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
          ParseGlassdoorPostingJob.perform_later(posting)
        end

      }

      if doc["response"]["currentPageNumber"] < doc["response"]["totalNumberOfPages"]
        if url.include?("&p=")
          nextPage = url.sub!("&p=#{doc["response"]["currentPageNumber"]}","&p=#{doc["response"]["currentPageNumber"]+1}")
        else
          nextPage = url + "&p=2"
        end
        ParseGlassdoorJob.perform_later(nextPage, keywords)
      end
    else
      puts "Request denied by glassdoor"
    end
  end

  # t.string :company 


  # t.text :description

  # t.string :salary
  def self.all
    @@all
  end

  private
  def around_parse
    # Do something before perform
    @@all += 1
    yield
    # Do something after perform
    @@all -= 1
  end
end
