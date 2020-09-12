class ParseFactoryJob < ApplicationJob
  queue_as :low_priority

  def perform
    pool = ScheduledPosting.stats["parsing"]
    pool ? pool : pool = 0
    if pool < 5
      jobs = ScheduledPosting.next(5 - pool)
      jobs.each{ |job|
        job.update(status: "parsing")
        if job.url
          ParseGlassdoorJob.perform_later(job.url, job.url, job)
        else
          ParseGlassdoorPostingJob.perform_later(Posting.find(job.posting_id), job)
        end
      }
    end
  end

  after_perform do |job|
    if ScheduledPosting.not_done > 0
      self.class.set(:wait => 5.seconds).perform_later
    else
      puts
      puts
      puts "PARSING COMPLETED"
      puts
      puts
    end
    
  end

end
