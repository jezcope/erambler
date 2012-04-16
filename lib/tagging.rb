def tag_index
  TagIndex.tag_index
end

class TagIndex

  def TagIndex.tag_index
    @@instance ||= TagIndex.new
  end

  def slug_for(tag)
    tag.downcase.gsub(/[^a-z0-9]/, '-')
  end

  def add_articles(items)
    @tags = Hash.new{|hash, key| hash[key] = []}

    items.each do |i|
      i[:tags].andand.each do |tag|
        @tags[tag] << i
      end
    end
  end

  def items_for_tag(tag)
    @tags[tag]
  end

  def tag_feeds
    @tags.keys.map {|t| tag_feed_for t}
  end

  def tag_feed_for(tag)
    Nanoc3::Item.new(
      "= render 'partials/feed', :articles => tag_index.items_for_tag(#{tag.inspect})",
      {
        mtime: items_for_tag(tag).collect {|i| i[:mtime]}.max
      },
      "/feeds/tag/#{slug_for tag}")
  end

  def tag_pages
    @tags.keys.map {|t| tag_page_for t}
  end

  def tag_page_for(tag)
    Nanoc3::Item.new(
      "= render 'partials/brief_index', :articles => tag_index.items_for_tag(#{tag.inspect})",
      {
        mtime: items_for_tag(tag).collect {|i| i[:mtime]}.max,
        title: %(Articles tagged "#{tag}")
      },
      "/tag/#{slug_for tag}")
  end

end
