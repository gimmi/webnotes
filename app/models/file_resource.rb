class FileResource
  BASE_PATH = 'public/files'

  def self.find
    file_list = []
    Dir.foreach(BASE_PATH) do |file_name|
      if File.file?(File.join(BASE_PATH, file_name))
        file_list << FileResource.new(file_name)
      end
    end
    file_list.sort
  end
  
  def initialize(name)
    @name = name
  end

  attr_reader :name
  
  def write(content)
    full_name = File.join(BASE_PATH, @name)
    File.open(full_name, 'wb') do |file|
      file.write content
    end
  end
  
end
