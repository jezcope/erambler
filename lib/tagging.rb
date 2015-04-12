def tag_index
  TagIndex.tag_index
end

def slug_for(tag)
  tag.downcase.gsub(/[^a-z0-9]/, '-')
end

def url_for_tag(tag)
  "/tag/#{slug_for tag}/"
end

def feed_url_for_tag(tag)
  url_for_tag(tag) + "feed/"
end

def link_for_tag(tag)
  link_to tag, url_for_tag(tag), class: 'tag'
end

def url_for_category(cat)
  "/category/#{slug_for cat}/"
end

def feed_url_for_category(cat)
  url_for_category(cat) + "feed/"
end

def link_for_category(cat)
  link_to cat, url_for_category(cat), class: 'tag'
end

class TagIndex

  def TagIndex.tag_index
    @@instance ||= TagIndex.new
  end

  def add_articles(items)
    @tags = Hash.new{|hash, key| hash[key] = []}
    @cats = Hash.new{|hash, key| hash[key] = []}

    items.each do |i|
      i[:tags].andand.each {|tag| @tags[tag] << i}
      i[:categories].andand.each {|cat| @cats[cat] << i}
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
        mtime: items_for_tag(tag).collect {|i| i[:mtime]}.max,
        type:  :feed
      },
      feed_url_for_tag(tag))
  end

  def tag_pages
    @tags.keys.map {|t| tag_page_for t}
  end

  def tag_page_for(tag)
    Nanoc3::Item.new(
      "= render 'partials/brief_index', :articles => tag_index.items_for_tag(#{tag.inspect})",
      {
        mtime: items_for_tag(tag).collect {|i| i[:mtime]}.max,
        title: %(Articles tagged "#{tag}"),
        page_type: %w{index tag-page}
      },
      url_for_tag(tag))
  end

  def items_for_category(cat)
    @cats[cat]
  end

  def category_feeds
    @cats.keys.map {|t| category_feed_for t}
  end

  def category_feed_for(cat)
    Nanoc3::Item.new(
      "= render 'partials/feed', :articles => tag_index.items_for_category(#{cat.inspect})",
      {
        mtime: items_for_category(cat).collect {|i| i[:mtime]}.max,
        type:  :feed
      },
      feed_url_for_category(cat))
  end

  def category_pages
    @cats.keys.map {|t| category_page_for t}
  end

  def category_page_for(cat)
    Nanoc3::Item.new(
      "= render 'partials/brief_index', :articles => tag_index.items_for_category(#{cat.inspect})",
      {
        mtime: items_for_category(cat).collect {|i| i[:mtime]}.max,
        title: %(Articles filed under "#{cat}"),
        page_type: %w{index tag-page}
      },
      url_for_category(cat))
  end

end
