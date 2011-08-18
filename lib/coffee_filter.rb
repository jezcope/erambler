require 'coffee-script'

class CoffeeFilter < Nanoc3::Filter
  identifier :coffee

  def run(content, options = [])
    CoffeeScript.compile(content, options)
  end
end
