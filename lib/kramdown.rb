require 'haml'
require 'kramdown'

module Haml::Filters::Kramdown
  include Haml::Filters::Base

  def render(text)
    ::Kramdown::Document.new(text).to_html
  end
end
