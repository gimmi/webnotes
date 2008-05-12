class FileResource
  PUBLIC_PATH = 'files'
  BASE_PATH = "#{RAILS_ROOT}/public/#{PUBLIC_PATH}"

  def self.find(name)
    found = []
    Dir.foreach(BASE_PATH) do |file_name|
      file_path = File.join(BASE_PATH, file_name)
      if File.file?(file_path) && file_name !~ /\A\./
        file_resource = FileResource.new(file_name)
        return file_resource if file_resource.name == name
        found << file_resource
      end
    end
    name == :all ? found.sort : nil
  end
  
  def initialize(name)
    @name = name
  end

  attr_reader :name
  
  def write(content)
    full_name = File.join(BASE_PATH, @name)
    raise "FileResource #{@name} already exists" if File.exists?(full_name)
    File.open(full_name, 'wb') do |file|
      file.write content
    end
  end
  
  def path
    PUBLIC_PATH + @name
  end
  
  def <=>(other)
    self.name <=> other.name
  end
  
end
