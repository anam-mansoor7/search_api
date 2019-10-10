class CreateTerms < ActiveRecord::Migration[6.0]
  def change
    create_table :terms do |t|
      t.string :name, index: true
      t.integer :count
      t.references :page
    end
  end
end
