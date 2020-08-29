class ParseGlassdoorPostingJob < ApplicationJob
  queue_as :default

  def perform(posting)
    begin
      dom  = "https://www.glassdoor.com/partner/jobListing.htm?" #ao=465888&jobListingId=3651420494"
      rawurl = posting.link.split("&")
      ao = rawurl.find{|part| part.include?("ao=")}
      jobListingId = rawurl.find{|part| part.include?("jobListingId=")}
      url = dom + ao + '&' + jobListingId
      page = RestClient::Request.execute(
        method: :get, 
        url: url,
        timeout: 2000, 
        headers: {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"})
      doc = Nokogiri::HTML.parse(page)
      
      if doc.css("div.desc")[0]
        desc = doc.css("div.desc")[0].inner_html
        posting.update(description: desc, link: url)
      else
        desc = doc.css("body")[0].inner_html
      end
    rescue
      nil
    end
  end
end
 