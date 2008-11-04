class PageVersion < ActiveRecord::Base
  
  belongs_to :page
  
  def to_s
    read_attribute('version_at').to_s
  end
  
end
