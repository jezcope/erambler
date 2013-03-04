require 'andand'
require 'faker'

include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::XMLSitemap

def render_cached(partial, *args)
  $cache ||= {}

  $cache[partial] ||= render(partial, *args)
end
