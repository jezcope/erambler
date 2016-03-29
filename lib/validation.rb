def validate_items
  validate_teasers
end

def validate_teasers
  @config[:validation] ||= {}
  @config[:validation][:teaser_length] ||= 120
  
  @items.each do |i|
    if i.key? :teaser and i[:teaser].length > @config[:validation][:teaser_length]
      raise "Teaser too long for #{i.identifier}: #{i[:teaser].length} (should be #{@config[:validation][:teaser_length]})"
    end
  end
end
