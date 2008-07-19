#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), "lib", "comics")

puts Comics.new(:full_name => "Diesel Sweeties",
                :short_name => "diesel").feed
