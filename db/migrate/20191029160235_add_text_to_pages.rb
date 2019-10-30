class AddTextToPages < ActiveRecord::Migration[6.0]
  def change
    add_column :pages, :doc_text, :text
    add_column :pages, :doc_text_vector, :tsvector
  end
end