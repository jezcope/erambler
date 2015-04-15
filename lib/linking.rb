require 'uri'

def link_wikipedia(topic)
  link_to topic,
          "http://en.wikipedia.org/w/index.php?title=Special:Search&search=#{URI.escape(topic)}"
end
