#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), "lib", "gocomics")

puts GoComics.new(:full_name => "Ink Pen",
                  :short_name => "inkpen",
                  :abbrev_name => "ink").feed
