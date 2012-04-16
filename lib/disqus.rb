def disqus_comments_link(item)
  link_to 'Comments', url_for(item) + '#disqus_thread',
          :'data-disqus-identifier' => atom_tag_for(item)
end
