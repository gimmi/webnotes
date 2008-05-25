class Attachment
  PUBLIC_PATH = '/attachments'
  BASE_PATH = "#{RAILS_ROOT}/public#{PUBLIC_PATH}"

  def self.each
    Dir.foreach(BASE_PATH) do |file_name|
      file_path = File.join(BASE_PATH, file_name)
      if File.file?(file_path) && file_name !~ /\A\./
        yield Attachment.new(file_name)
      end
    end
  end
  
  def self.find(name)
    found = []
    Attachment.each do |attachment|
      return attachment if attachment.name == name
      found << attachment
    end
    name == :all ? found.sort : nil
  end
  
  def self.split_and_normalize_file_name(file_name)
    lowercased_file_name = file_name.downcase
    type_index = lowercased_file_name.index(/\.[a-z0-9]+\z/)
    if type_index
      name = lowercased_file_name[0, type_index]
      type = lowercased_file_name[type_index, lowercased_file_name.length]
    else
      name = lowercased_file_name
      type = ''
    end
    [name.gsub(/[^a-z0-9]/, '-'), type]
  end
  
  def self.delete_all
    Attachment.each do |attachment|
      attachment.delete
    end
  end
  
  include Comparable
  
  def initialize(file_name)
    @file_name = file_name
  end
  
  def name
    Attachment.split_and_normalize_file_name(@file_name)[0]
  end
  
  def path
    File.join(PUBLIC_PATH, @file_name)
  end
  
  def write(content)
    Attachment.each do |attachment|
      raise "Attachment #{name} already exists" if self == attachment
    end
    File.open(File.join(BASE_PATH, Attachment.split_and_normalize_file_name(@file_name).join), 'wb') do |file|
      file.write content
    end
  end
  
  def delete
    full_name = File.join(BASE_PATH, @file_name)
    File.delete(full_name) if File.exist?(full_name)
  end
  
  def <=>(other)
    self.name <=> other.name
  end
  
end
