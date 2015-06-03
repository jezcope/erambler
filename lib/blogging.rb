include Nanoc::Helpers::Blogging

def date_for(article)
  attribute_to_time article[:created_at]
end

def paginate_articles
	1.upto(articles.count/@config[:page_size]) do |page|
		@items.create(
			"= render 'partials/article_index', :page => #{page}",
			{
        title: "Archive page #{page}",
        page_type: 'index'
      },
			"/archives/#{page}")
	end
end

def archive_page_url(i)
	if i == 0
		'/'
	else
		"/archives/#{i}/"
	end
end

def fix_atom_link_type(text)
  feed = Nokogiri::XML(text)
  links = feed.css('feed entry link')
  links.attr('type', 'text/html')
  feed.to_xml
end
