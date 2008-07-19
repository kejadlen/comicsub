#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), "lib", "comics")

if __FILE__ == $0
  puts Comics.new(:full_name => "F Minus",
                  :short_name => "fminus").feed
end
