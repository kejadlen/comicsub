#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), "lib", "gocomics")

class FoxTrot < GoComics
  def initialize
    super(:full_name => "FoxTrot", :abbrev_name => "ft", :marshal => false)
  end

  def comic_strips
    # Get Sundays from the previous month
    today = Date.today
    today -=1 unless Time.now.hour >= 6
    month = (Date.today<<1..today)
    sundays = month.to_a.select {|d| d.wday == 0 }

    super(sundays)
  end
end

puts FoxTrot.new.feed
