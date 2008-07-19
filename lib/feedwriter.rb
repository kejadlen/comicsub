require "rubygems" # Since I"m too lazy to set the RUBYOPTS
                   # environment variable for NetNewsWire

require "builder"
require "date"
require "open-uri"
require "ostruct"

module FeedWriter
  def feed
    strips = comic_strips   # HACK: so that we can access these methods/variables
    full_name = @full_name  # inside of instance_eval
    comic_url = @comic_url
    guid = @guid

    Builder::XmlMarkup.new(:indent => 2).instance_eval do
      instruct! :xml, :version => "1.0", :encoding => "utf-8"

      feed :xmlns => "http://www.w3.org/2005/Atom" do
        title full_name
        subtitle full_name
        link :rel => "self", :href => comic_url
        updated Date.today.strftime("%FT%TZ")
        author do
          name "Alpha Chen"
          email "alpha.chen@gmail.com"
        end
        id guid

        strips.each do |(date,url,guid,image)|
          entry do
            title date
            link :rel => "self", :href => url
            id guid
            updated (date+1).strftime("%FT%TZ") # date+1 since NetNewsWire interprets midnight as the previous day
            summary date
            content :type => "xhtml" do
              div :xmlns => "http://www.w3.org/1999/xhtml" do
                img :src => image
              end
            end
          end
        end
      end
    end
  end
end
