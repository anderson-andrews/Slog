class Slog
  require 'erb'
  require 'ostruct'
  require 'date'

  attr_accessor :dir, :markdown_obj,
                :blog_name
  attr_reader :processed_data, :files,
              :limit

  def initialize(data)
    markdown = data[:markdown]
    require markdown.downcase
    @markdown_obj = to_constant(markdown)
    @blog_name = data[:name] || "default"
    @dir = "#{data[:blog_dir]}/#{@blog_name}"
    @files = []
    @processed_data = []
  end

  def get(start, limit=1)
    glob = Dir.glob("#{@dir}/*")
    @limit = limit
    if(start == :first)
      @files = glob.first(limit).sort
    elsif(start == :last)
      @files = glob.last(limit).sort
      @files.reverse! if posts.length > 1
    else
      raise "Please enter pass :first or :last with the number of posts."
    end
  end

  def process(markup=@markdown_obj, data=nil, &block)
    if limit > 1
      @files.each do |file|
        process_file(file)
      end
    else
      process_file(@files[0])
      @processed_data = @processed_data[0]
    end
  end

  private

  def process_markup(source)
    data = {:title => "", :tags => ""}
    processed_text = ERB.new(source).result(OpenStruct.new(data).instance_eval { binding })
    data[:html] = @markdown_obj.new(processed_text).to_html
    data
  end

  def process_file(file)
    file_data = IO.read(file)
    name_data = process_filename(file)
    markup_data = process_markup(file_data)
    @processed_data << markup_data.merge(name_data)
  end

  def process_filename(file)
    split_name = File.basename(file, "txt").split("__")
    split_date = split_name[0].split("-")
    date = Date.strptime("{ #{split_date.join(',')} }", "{ %Y, %m, %d }")
    {:date => date, :name => split_name[1]}
  end

  def to_constant(str)
    Object.const_get(str)
  end
end
