require 'bluecloth'

class Page < ActiveRecord::Base
  URL_TITLE_REGEXP_STRING = '[a-z0-9-]+'
  
  validates_presence_of :url_title, :text_body
  validates_uniqueness_of :url_title
  validates_format_of :url_title, :with => /\A#{URL_TITLE_REGEXP_STRING}\Z/, :message => 'must use only lower case letters, numbers, and "-"'
  
  def html_body(&block)
    BlueCloth.new(text_body_with_page_links(&block)).to_html
  end
  
  def title
    Page.titleize_url_title(read_attribute(:url_title))
  end
  
  def text_body_with_page_links
    read_attribute(:text_body).gsub(/\[\[(#{URL_TITLE_REGEXP_STRING})\]\]/) do
      "<a href=\"#{yield($1)}\">#{Page.titleize_url_title($1)}</a>"
    end
  end
  
  def private?
    !read_attribute(:public)
  end

  def self.titleize_url_title(url_title)
    url_title.titleize
  end
end
