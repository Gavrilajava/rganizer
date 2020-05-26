class Posting < ApplicationRecord

  validates :title, uniqueness: { scope: :company, message: "this posting already exist" }

  scope :unprocessed, -> {where(category: "new")}

  scope :applied, -> {where(category: "applied")}

  def self.latest_twenty
    last(20)
  end


  def self.get_glassdoor(keywords, location)
    #  1347
      keywords = keywords.split(" ").join("+")
      url = "https://www.glassdoor.com/Job/jobs.htm?suggestCount=0&suggestChosen=false&clickSource=searchBtn&typedKeyword=#{keywords}&locT=S&locId=#{location}&jobType=&context=Jobs&sc.keyword=#{keywords}&dropdown=0"
      ParseGlassdoorJob.perform_later(url)
  end

end
