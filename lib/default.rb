require 'andand'
require 'faker'

include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::Rendering
include Nanoc::Helpers::XMLSitemap

def render_cached(partial, *args)
  $cache ||= {}

  $cache[partial] ||= render(partial, *args)
end

def reset_cache
  $cache = {}
end
