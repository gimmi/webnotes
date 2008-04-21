class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :url_title, :null => false
      t.text :text_body, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
