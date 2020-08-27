class Posting < ApplicationRecord

  validates :title, uniqueness: { scope: :company, message: "this posting already exist" }

  scope :unprocessed, -> {where(category: "new").order(id: :asc)}

  scope :applied, -> {where(category: "applied").order(updated_at: :desc)}

  def self.stats
    Posting.all.group(:category).count.merge({companies: Posting.where(category: "applied").group(:company).count.length})
  end

  def self.latest_twenty
    last(20)
  end

  def self.get_all_glassdoor
    locations = Location.active.pluck(:locId)
    keywords = Keyword.active
    locations.each{ |location|
      keywords.each { |keyword|
        sleep(rand(3.0..5.0))
        Posting.get_glassdoor(keyword.title, location, keyword.isEntryLevel)
      }
    }
  end


  def self.get_glassdoor(keywords, location, entryLevel = false)
      keywords = keywords.split(" ").join("+")
      if entryLevel
        entryLevel = '&seniorityType=entrylevel'
      else
        entryLevel = ""
      end
      url = "https://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=120&t.k=fz6JLNDfgVs&action=jobs&q=#{keywords}&locT=S&locId=#{location}#{entryLevel}"
      # url = "https://www.glassdoor.com/Job/jobs.htm?suggestCount=0&suggestChosen=false&clickSource=searchBtn&typedKeyword=#{keywords}&locT=S&locId=#{location}&jobType=&context=Jobs&sc.keyword=#{keywords}&dropdown=0&radius=100#{entryLevel}"
      ParseGlassdoorJob.perform_later(url)
      # Posting.perform(url)
  end

 
  def self.perform(posting)
    dom  = "https://www.glassdoor.com/partner/jobListing.htm?" #ao=465888&jobListingId=3651420494"
    rawurl = posting.link.split("&")
    ao = rawurl.find{|part| part.include?("ao=")}
    jobListingId = rawurl.find{|part| part.include?("jobListingId=")}
    url = dom + ao + '&' + jobListingId
    page = RestClient::Request.execute(
      method: :get, 
      url: posting.link,
      max_redirects: 10,
      timeout: 50, 
      headers: {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"})
    doc = Nokogiri::HTML.parse(page)
    byebug
    desc = doc.css("div.jobDesc")[0].text
    posting.update(description: desc)
  end


end





# https://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=120&t.k=fz6JLNDfgVs&action=jobs&q=Entry+Level+React&locId=1347&userip=192.168.43.42&useragent=Mozilla/%2F4.0