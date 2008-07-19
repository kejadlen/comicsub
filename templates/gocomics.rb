#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), "lib", "gocomics")

if __FILE__ == $0
  puts GoComics.new(:full_name => "full name",
                    :short_name => "short name",
                    :abbrev_name => "abbreviated name").feed
end
