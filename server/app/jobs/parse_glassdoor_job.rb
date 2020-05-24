class ParseGlassdoorJob < ApplicationJob
  queue_as :default

  def perform(url)
    page = RestClient::Request.execute(
      method: :get, 
      url: url,
      timeout: 50, 
      headers: {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"})
    doc = Nokogiri::HTML.parse(page)
    doc.css("div.jobContainer").each{|jobContainer|
      params = {}
      params[:title] = (jobContainer.children.css("a").text).strip
      params[:link] = "https://www.glassdoor.com#{jobContainer.children.css("a")[0]['href']}"
      loc = jobContainer.children.css("span.subtle")[0].text
      loc = loc.split(", ")
      params[:city] = (loc[0]).strip
      params[:state] = loc[1]
      params[:company] = (jobContainer.children.css("div.jobHeader").children.css("a").text).strip
      if jobContainer.children.css("span.gray")[0]
        params[:salary] = jobContainer.children.css("span.gray")
      end
      posting = Posting.create(params)
      if posting.valid?
        ParseGlassdoorPostingJob.perform_later(posting)
      end

    }
    if doc.css("li.next")[0]
      nextPage = "https://www.glassdoor.com#{doc.css("li.next").children.css("a")[0]['href']}"
      ParseGlassdoorJob.perform_later(nextPage)
    end

  end

  # t.string :company 


  # t.text :description

  # t.string :salary

  private
  def around_parse
    # Do something before perform
    yield
    # Do something after perform
  end
end
