class AddIndexOnDocText < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE INDEX doc_text_idx
      ON pages
      USING gin(doc_text_vector);
    SQL

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON pages FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(doc_text_vector, 'pg_catalog.english', doc_text);
    SQL
  end

  def down
    remove_index :pages, :doc_text_vector
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON pages
    SQL
  end
end
