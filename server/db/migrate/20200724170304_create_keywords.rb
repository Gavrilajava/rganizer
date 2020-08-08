class CreateKeywords < ActiveRecord::Migration[6.0]
  def change
    create_table :keywords do |t|
      t.string :title
      t.boolean :isActive
      t.boolean :isEntryLevel
      t.timestamps
    end
  end
end
