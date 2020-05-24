class Posting < ApplicationRecord

  validates :title, uniqueness: { scope: :company, message: "this posting already exist" }


  def self.get_glassdoor
      keywords = "Javascript React"
      location = "1347"
      keywords = keywords.split(" ").join("+")
      url = "https://www.glassdoor.com/Job/jobs.htm?suggestCount=0&suggestChosen=false&clickSource=searchBtn&typedKeyword=#{keywords}&locT=S&locId=#{location}&jobType=&context=Jobs&sc.keyword=#{keywords}&dropdown=0"
      ParseGlassdoorJob.perform_later(url)
  end

end
