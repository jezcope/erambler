def tag_index
  @config[:tag_index] ||= TagIndex.new
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

class TagIndex

  def add_articles(items)
    @tags = Hash.new{|hash, key| hash[key] = []}

    items.each do |i|
      tags_for(i).each {|tag| @tags[tag] << i.identifier}
    end
  end

  def items_for_tag(tag, items)
    @tags[tag].map {|i| items[i]}
  end

  def create_tag_feeds(items)
    @tags.keys.each {|t| create_tag_feed_for(t, items)}
  end

  def create_tag_feed_for(tag, items)
    items.create(
      "= render 'partials/feed', :articles => tag_index.items_for_tag(#{tag.inspect}, @items)",
      {
        mtime: items_for_tag(tag, items).collect {|i| i[:mtime]}.max,
        type:  :feed
      },
      feed_url_for_tag(tag))
  end

  def create_tag_pages(items)
    @tags.keys.each {|t| create_tag_page_for(t, items)}
  end

  def create_tag_page_for(tag, items)
    items.create(
      "= render 'partials/brief_index', :articles => tag_index.items_for_tag(#{tag.inspect}, @items)",
      {
        mtime: items_for_tag(tag, items).collect {|i| i[:mtime]}.max,
        title: %(Articles tagged "#{tag}"),
        page_type: %w{index tag-page}
      },
      url_for_tag(tag))
  end

end

def tags_for(item)
  ((item[:tags] || []) + (item[:categories] || [])).compact.uniq
end
