class CreateScheduledPostings < ActiveRecord::Migration[6.0]
  def change
    create_table :scheduled_postings do |t|
      t.string :url
      t.string :keywords
      t.string :posting_id
      t.string :status, default: 'new'
      t.timestamps
    end
  end
end
