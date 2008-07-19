require File.join(File.dirname(__FILE__), "feedwriter")

class Comics
  include FeedWriter

  DOMAIN = "http://www.comics.com"
  MARSHAL_DIR = "/Users/alpha"

  def initialize(hsh)
    @full_name    = hsh[:full_name]
    @short_name   = hsh[:short_name] || @full_name.delete(' ').downcase
    @use_marshal  = (hsh[:marshal].nil?) ? true : hsh[:marshal]
    
    @base_url = DOMAIN + "/comics/#{@short_name}"
    @comic_url = @base_url + "/index.html"
    @archive_url = @base_url + "/archive"
    @guid = "tag:comics.com,2007-05-06:#{@base_url.sub(DOMAIN, '')}"
    
    @marshal_file = File.join(MARSHAL_DIR, ".comics.com", @short_name)

    scrape_images
  end

  def scrape_images
    @images = {}
    File.open(@marshal_file) {|file| @images = Marshal.load(file) } if @use_marshal and File.exists?(@marshal_file)

    # Only "update" to the current day after 5 AM
    week = (Time.now.hour >= 5) ? (Date.today-7..Date.today) : (Date.today-8..Date.today-1)
      
    week.each do |date|
      unless @images.include?(date)
        url = "%s/%s-%s.html" % [ @archive_url, @short_name, date.strftime("%Y%m%d") ]
        @images[date] = open(url).read.scan(/#{@short_name}\d+\.(?:gif|jpg)/).uniq[0]
      end
    end

    # Remove entries that are more than a week old
    @images.delete_if {|date, v| date < Date.today - 7 }

    File.open(@marshal_file, "w") {|file| Marshal.dump(@images, file) } if @use_marshal
  end

  def comic_strips
    @images.sort.reverse.to_a.map do |date,image|
      url = "%s/%s-%s.html" % [ @archive_url, @short_name, date.strftime("%Y%m%d") ]
      guid = "tag:comics.com,#{date}:#{url.sub(DOMAIN, '')}"
      image = "#{@archive_url}/images/#{image}"
      [ date, url, guid, image ]
    end
  end

  class << self
    def feed(hsh)
      new(hsh).feed
    end
  end
end
