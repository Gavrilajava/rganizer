class AddUsedKeywordsToPostings < ActiveRecord::Migration[6.0]
  def change
    add_column :postings, :used_keywords, :string
  end
end
