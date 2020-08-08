class Posting < ApplicationRecord

  validates :title, uniqueness: { scope: :company, message: "this posting already exist" }

  scope :unprocessed, -> {where(category: "new")}

  scope :applied, -> {where(category: "applied").order(:updated_at)}

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
      url = "https://www.glassdoor.com/Job/jobs.htm?suggestCount=0&suggestChosen=false&clickSource=searchBtn&typedKeyword=#{keywords}&locT=S&locId=#{location}&jobType=&context=Jobs&sc.keyword=#{keywords}&dropdown=0&radius=100#{entryLevel}"
      ParseGlassdoorJob.perform_later(url)
  end

end

