class Posting < ApplicationRecord

  validates :title, uniqueness: { scope: :company, message: "this posting already exist" }

  scope :unprocessed, -> {where(category: "new")}

  scope :applied, -> {where(category: "applied").order(:updated_at)}

  def self.latest_twenty
    last(20)
  end

  def self.get_all_glassdoor
    locations = [1347, 1282, 2792, 847, 3107, 105, 1968, 3426, 1553, 386, 39, 3318, 323, 3411, 428, 3020, 527, 302, 3523, 3201, 3185, 3399, 2697]
    keywords = ["Entry Level Developer"]
    locations.each{ |location|
      
      keywords.each { |keyword|
        sleep(3)
        Posting.get_glassdoor(keyword, location)
      }
      
    }
  end


  def self.get_glassdoor(keywords, location)
    #  Texas is 1347, houston = 1140171, 
    # North Carolina = 1282, 
    # Louisiana = 2792, 
    # Oklahoma 847, 
    # Kansas 3107, 
    # Alabama 105, 
    # Tenneesee 1968
    # Georgia 3426
    # Missisipi 1553
    # Missoury 386
    # New Jersey 39
    # Florida 3318
    # Virginia 323
    # South Carolina 3411
    # New York 428
    # Washington 3020
    # Michigan 527
    # Illinois 302
    # Maryland 3201
    # Delaware 3523
    # Pennsilvania 3185
    # Connecticut 2697
    # MAssachusets 3399
      # keywords = "Ruby on Rails"
      
      keywords = keywords.split(" ").join("+")
      
      # url = "https://www.glassdoor.com/Job/houston-javascript-react-jobs-SRCH_IL.0,7_IC1140171_KO8,18_KE19,24.htm?radius=100"
      # url = "https://www.glassdoor.com/Job/houston-ruby-on-rails-jobs-SRCH_IL.0,7_IC1140171_KE8,21.htm?radius=100"
      # url = "https://www.glassdoor.com/Job/houston-developer-junior-jobs-SRCH_IL.0,7_IC1140171_KO8,17_KE18,24.htm?radius=100"
      # url = "https://www.glassdoor.com/Job/houston-javascript-developer-jobs-SRCH_IL.0,7_IC1140171_KO8,28.htm?radius=100" Хреновая
      url = "https://www.glassdoor.com/Job/jobs.htm?suggestCount=0&suggestChosen=false&clickSource=searchBtn&typedKeyword=#{keywords}&locT=S&locId=#{location}&jobType=&context=Jobs&sc.keyword=#{keywords}&dropdown=0&radius=100&seniorityType=entrylevel"
      ParseGlassdoorJob.perform_later(url)
  end

end

