def tag_feed_for(tag)
  slug = tag.downcase.gsub(/[^a-z0-9]/, '-')
  Nanoc3::Item.new(
    "= render 'partials/tag_feed', :tag => '#{tag}'",
    {},
    "/feeds/tag/#{slug}")
end
