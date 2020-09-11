class Posting < ApplicationRecord

  validates :title, uniqueness: { scope: :company, message: "this posting already exist" }

  scope :unprocessed, -> {where(category: "new").order(id: :asc)}

  scope :applied, -> {where(category: "applied").order(updated_at: :desc)}

  def self.stats
    Posting.all.group(:category).count.merge({companies: Posting.where(category: "applied").group(:company).count.length})
  end

  def self.next_unprocessed
    postings = Posting.unprocessed.first(20)
    companies = postings.pluck(:company)
    appl = Posting.applied.where('company IN (?)' , companies).pluck(:company).uniq
    postings.map{ |posting|
      {
        id: posting.id,
        company: posting.company,
        applied: appl.include?(posting.company) ? true : false,
        title: posting.title,
        link: posting.link,
        description: posting.description,
        city: posting.city,
        keywords: posting.used_keywords,
        state: posting.state,
        salary: posting.salary,
        created_at: posting.created_at
      }
    }
  end

  def self.get_all_glassdoor
    locations = Location.active.pluck(:locId)
    keywords = Keyword.active
    locations.each_with_index { |location, loc_index |
      keywords.each_with_index { |keyword, key_index|
        pause = rand(3.0..5.0)
        pause *= ((loc_index+1)+(key_index+1)*2)
        # sleep(pause)
        Posting.get_glassdoor(keyword.title, location, keyword.isEntryLevel, pause)
      }
    }
  end


  def self.get_glassdoor(keywords, location, entryLevel = false, pause)
      keywords = keywords.split(" ").join("+")
      if entryLevel
        entryLevel = '&seniorityType=entrylevel'
      else
        entryLevel = ""
      end
      url = "https://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=120&t.k=fz6JLNDfgVs&action=jobs&q=#{keywords}&locT=S&locId=#{location}#{entryLevel}"
      # url = "https://www.glassdoor.com/Job/jobs.htm?suggestCount=0&suggestChosen=false&clickSource=searchBtn&typedKeyword=#{keywords}&locT=S&locId=#{location}&jobType=&context=Jobs&sc.keyword=#{keywords}&dropdown=0&radius=100#{entryLevel}"
      ParseGlassdoorJob.perform_later(url, keywords, pause)
      # Posting.perform(url)
  end

 
  def self.perform(posting)
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

  def self.perform_all
    Posting.unprocessed.each{|posting|
      if !posting.description
        ParseGlassdoorPostingJob.perform_later(posting)
      end
    }
  end




end





# https://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=120&t.k=fz6JLNDfgVs&action=jobs&q=Entry+Level+React&locId=1347&userip=192.168.43.42&useragent=Mozilla/%2F4.0