require 'haml'
require 'coffee-script'

class CoffeeFilter < Nanoc3::Filter
  identifier :coffee

  def run(content, options = [])
    CoffeeScript.compile(content, options)
  end
end

module Haml::Filters::Coffee
  include Haml::Filters::Base

  def render_with_options(text, options)
    <<END
<script type=#{options[:attr_wrapper]}text/javascript#{options[:attr_wrapper]}>
  //<![CDATA[
    #{CoffeeScript.compile(text)}
  //]]>
</script>
END
  end
end
