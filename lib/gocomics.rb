require File.join(File.dirname(__FILE__), "feedwriter")

class GoComics
  include FeedWriter

  COMIC_DOMAIN = "http://www.gocomics.com/" 
  IMAGE_DOMAIN = "http://images.ucomics.com/"

  def initialize(hsh)
    @full_name    = hsh[:full_name]
    @short_name   = hsh[:short_name] || @full_name.split.first.downcase
    @abbrev_name  = hsh[:abbrev_name] || @short_name

    @comic_url = COMIC_DOMAIN + "/#{@short_name}/"
    @guid = "tag:gocomics.com,2006-05-06:#{@comic_url.sub(COMIC_DOMAIN, '')}"
  end

  def comic_strips(week=nil)
    # Only "update" to the current day after 6 AM
    week ||= (Time.now.hour >= 6) ? (Date.today-7..Date.today) : (Date.today-8..Date.today-1)
    
    week.to_a.reverse.map do |date|
      url = "%s%s/%s" % [ COMIC_DOMAIN, @short_name, date.strftime("%Y/%m/%d") ]
      image = "%scomics/%s/%s/%s%s.gif" % [ IMAGE_DOMAIN, @abbrev_name, date.year, @abbrev_name, date.strftime("%y%m%d") ]
      guid = "tag:ucomics.com,#{date}:#{image.sub(IMAGE_DOMAIN, '')}"
      [ date, url, guid, image ]
    end
  end

  class << self
    def feed(hsh)
      new(hsh).feed
    end
  end
end
