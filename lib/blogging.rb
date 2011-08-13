require 'nokogiri'

include Nanoc3::Helpers::Blogging

def date_for(article)
  attribute_to_time article[:created_at]
end

def excerpt_for(article, pars = 1)
	article[:excerpt] || generate_excerpt(article, pars)
end

def generate_excerpt(article, pars = 1)
	doc = Nokogiri::HTML::DocumentFragment.parse(article.compiled_content)
	doc.css('p')[0,pars].to_html
end

def paginate_articles
	1.upto(articles.count/@config[:page_size]) do |page|
		@items << Nanoc3::Item.new(
			"= render 'partials/article_index', :page => #{page}",
			{ :title => "Archive page #{page}" },
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
