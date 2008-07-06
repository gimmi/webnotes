class CreatePageVersions < ActiveRecord::Migration
  def self.up
    create_table :page_versions do |t|
      t.integer :page_id, :null => false
      t.text :text_body, :null => false
      t.datetime :version_at
    end
  end

  def self.down
    drop_table :page_versions
  end
end
