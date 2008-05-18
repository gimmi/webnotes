class Attachment
  PUBLIC_PATH = '/files'
  BASE_PATH = "#{RAILS_ROOT}/public#{PUBLIC_PATH}"

  def self.find(name)
    found = []
    Dir.foreach(BASE_PATH) do |file_name|
      file_path = File.join(BASE_PATH, file_name)
      if File.file?(file_path) && file_name !~ /\A\./
        attachment = Attachment.new(file_name)
        return attachment if attachment.name == name
        found << attachment
      end
    end
    name == :all ? found.sort : nil
  end
  
  def self.create(name, content)
    full_name = File.join(BASE_PATH, name)
    raise "Attachment #{name} already exists" if File.exists?(full_name)
    
    File.open(full_name, 'wb') do |file|
      file.write content
    end
  end
  
  def self.delete(name)
    if name == :all
      Dir.foreach(BASE_PATH) do |file_name|
        File.delete(File.join(BASE_PATH, file_name)) unless file_name =~ /\A\./
      end
    else
      full_name = File.join(BASE_PATH, name)
      raise "Attachment #{name} doesn't exists" unless File.exists?(full_name)
      File.delete(full_name)
    end
  end
  
  def initialize(name)
    @name = name
  end

  attr_reader :name
  
  def path
    File.join(PUBLIC_PATH, @name)
  end
  
  def <=>(other)
    self.name <=> other.name
  end
  
end
