require 'sequel'
require 'active_support/inflector'
require 'active_support/core_ext'
require 'kramdown'
require 'nokogiri'
require 'pp'

class Wordpress < Thor

  desc 'import DB_URL', <<-DESC
    Import WordPress data from the given connection URL.
  DESC
  method_option :prefix,  :default => 'wp', :aliases => '-p'
  method_option :dir,     :default => 'import', :aliases => '-d'
  def import(db_url)
    say "Importing WordPress content from ", :blue
    say db_url, :yellow

    prefix = options[:prefix]
    db = Sequel.connect(db_url, :encoding => 'utf8')
    posts = db[:"#{prefix}_posts"]
    postmeta = db[:"#{prefix}_postmeta"]

    posts_query = posts.select(:post_title, :post_name, :post_date,
                               :post_content, :post_excerpt, :ID, :guid,
                               :post_status, :post_type, :post_status)
      .filter(:post_type => 'post', :post_status => 'publish')
    term_relationships = db[:"#{prefix}_term_relationships___tr"]
      .select(:t__taxonomy, :term__name, :term__slug)
      .join(:"#{prefix}_term_taxonomy___t", :term_taxonomy_id => :tr__term_taxonomy_id)
      .join(:"#{prefix}_terms___term", :term_id => :t__term_id)
      .filter(:t__taxonomy => %w(category post_tag))
      .order(:tr__term_order)

    posts_query.each do |post|
      title   = post[:post_title].to_s
      slug    = post[:post_name]
      date    = post[:post_date]
      excerpt = post[:post_excerpt].to_s
      content = post[:post_content].force_encoding('UTF-8')
      id      = post[:ID].to_i

      categories = []
      post_tags = []
      term_relationships.filter(:tr__object_id => post[:ID]).each do |term|
        eval(term[:taxonomy].pluralize) << term[:name]
      end

      metadata = {
        'title' => title,
        'kind' => 'article',
        'excerpt' => excerpt,
        'created_at' => date,
        'categories' => categories,
        'tags' => post_tags,
        'wpid' => id
      }.delete_if{|k,v| v.blank?}

      create_item slug, metadata, content, options
    end
  end

  desc 'wordtwit_to_nginx DB_URL', <<-DESC
    convert tweet_urls table to an nginx rewrite configuration.
  DESC
  method_option :prefix,  :default => 'wp', :aliases => '-p'
  method_option :outfile, :default => 'nginx.wordtwit.conf', :aliases => '-o'
  def wordtwit_to_nginx(db_url)
    prefix = options[:prefix]
    db = Sequel.connect(db_url, :encoding => 'utf8')
    posts = db[:"#{prefix}_posts"]
    tweet_urls = db[:"#{prefix}_tweet_urls"]

    posts_query = posts.select(:post_title, :post_name, :post_date,
                               :post_content, :post_excerpt, :ID, :guid,
                               :post_status, :post_type, :post_status)
      .filter(:post_type => 'post', :post_status => 'publish')
    tweet_urls_query = tweet_urls.select(:url, :post_id).filter('post_id > 0')

    open(options.outfile, 'w') do |out|
      tweet_urls_query.each do |row|
        url = row[:url]
        slug = posts_query.filter(:ID => row[:post_id]).get(:post_name)
        out.puts %Q(rewrite "^/#{url}/?$" /#{slug}/ redirect;) unless slug.nil?
      end
    end
  end


  # Helpers #################################################################
  no_tasks do

    def create_item(slug, metadata, content, options = {})
      d = metadata['created_at']
      dir = '%s/%d/%02d' % [options[:dir], d.year, d.month]
      FileUtils.mkpath dir
      open("#{dir}/#{slug}.md", 'w:UTF-8') do |f|
        f.puts YAML::dump(metadata)
        f.puts '---'  
        f.puts content
      end
    end

    def images_for_post(content)
      html = Kramdown::Document.new(content).to_html
      doc = Nokogiri::HTML(html)
      
      doc.xpath('//img[contains(@src, "erambler.co.uk") or contains(@src, "allacademic.files.wordpress.com")]')
    end

  end

end
