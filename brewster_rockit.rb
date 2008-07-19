#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), "lib", "feedwriter")

class BrewsterRockit
  include FeedWriter

  COMIC_DOMAIN = "http://www.comicspage.com/"
  IMAGE_DOMAIN = "http://www.tmsfeatures.com/"

  def initialize
    @full_name = "Brewster Rockit"
    @comic_url = COMIC_DOMAIN + "brewster/brewster.html"
    @guid = "tag:comicspage.com,2007-05-12:/brewster"
  end

  def comic_strips
    week = (Time.now.hour >= 6) ? (Date.today-7..Date.today) : (Date.today-8..Date.today-1)
    week.to_a.reverse.map do |date|
      date_str = date.strftime("%Y%m%d")
      embed_str = date_str + "csbre-" + ((date.wday != 0) ? 'a' : 's') + "-p.jpg"
      url = "#{COMIC_DOMAIN}comicspage/main.jsp?catid=1876&custid=69&file=#{embed_str}&code=csbre&dir=/brewster" 
      image = "#{IMAGE_DOMAIN}tmsfeatures/servlet/com.featureserv.util.Download?file=#{embed_str}&code=csbre"
      guid = "tag:tmsfeatures.com,#{date}:#{image.sub(IMAGE_DOMAIN, '')}"
      [ date, url, guid, image ]
    end
  end
end

puts BrewsterRockit.new.feed
