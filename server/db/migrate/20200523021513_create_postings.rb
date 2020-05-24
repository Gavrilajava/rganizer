class CreatePostings < ActiveRecord::Migration[6.0]
  def change
    create_table :postings do |t|
      t.string :company
      t.string :title
      t.string :link
      t.text :description
      t.string :city
      t.string :state
      t.string :salary
      t.string :category, default: "new"
      t.timestamps
    end
  end
end
