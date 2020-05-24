class ParseGlassdoorPostingJob < ApplicationJob
  queue_as :default

  def perform(posting)
    page = RestClient::Request.execute(
      method: :get, 
      url: posting.link,
      timeout: 50, 
      headers: {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"})
    doc = Nokogiri::HTML.parse(page)
    desc = doc.css("div.desc")[0].text
    posting.update(description: desc)
  end
end
 