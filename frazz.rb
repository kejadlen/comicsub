#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), "lib", "comics")

puts Comics.feed(:full_name => "Frazz")
