def tag_index
  TagIndex.tag_index
end

class TagIndex

  def TagIndex.tag_index
    @@instance ||= TagIndex.new
  end

  def add_articles(items)
    @tags = Hash.new()
    puts 'TagIndex.initialize'

    items.each do |i|
      i[:tags].andand.each do |tag|
        @tags[tag] ||= []
        @tags[tag] << i
      end
    end
  end

  def items_for_tag(tag)
    @tags[tag]
  end

  def tag_feed_for(tag)
    slug = tag.downcase.gsub(/[^a-z0-9]/, '-')
    Nanoc3::Item.new(
      "= render 'partials/tag_feed', :tag => '#{tag}'",
      {},
      "/feeds/tag/#{slug}")
  end

end
