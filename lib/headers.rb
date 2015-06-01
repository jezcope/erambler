require 'nokogiri'
require 'pp'

def clamp(n, lo, hi)
  if n < lo
    lo
  elsif n > hi
    hi
  end
  n
end

module ERambler
  
  class ReduceHeaderLevel < Nanoc::Filter
    identifier :reduce_header_level

    def run(content, params = {})
      by = params[:by] || -1
      doc = Nokogiri::HTML::DocumentFragment.parse(content)

      doc.css('h1, h2, h3, h4, h5, h6').each do |heading|
        /h(\d)/.match(heading.node_name) do |m|
          heading.node_name = "h#{clamp(m[1].to_i + by,1,6)}"
        end
      end

      doc.to_html
    end

  end

end
