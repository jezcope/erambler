require 'haml'
require 'pandoc-ruby'

module Haml::Filters::Pandoc
  include Haml::Filters::Base

  def render(text)
    ::PandocRuby.markdown(text).to_html
  end
end
