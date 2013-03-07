require 'pp'
require 'yaml'
require 'andand'

module Blogging

  BLOG_ROOT = File.absolute_path(File.join(__FILE__, '../..'))
  ARTICLES_ROOT = File.join(BLOG_ROOT, 'content', 'articles')

  module Helpers
    
    def article_files
      Dir.glob(File.join(ARTICLES_ROOT, '**/**/*.md'))
    end

    def article_metadata
      article_files.map do |filename|
        data = File.read(filename)
        pieces =  data.split(/^(-{5}|-{3})\s*$/)
        YAML.load(pieces[2]).merge('filename' => filename)
      end
    end

    def process_alphabetically(hash)
      hash.keys.sort{|a,b| a.casecmp(b)}.each do |key|
        yield key, hash[key]
      end
    end

  end

  class Articles < Thor

    include Helpers

    desc "list", "list all articles"
    def list
      article_metadata.each do |info|
        puts info["title"]
      end
    end

  end

  class Categories < Thor

    include Helpers

    desc "count_articles", "list all used categories"
    def count_articles
      categories = {}

      article_metadata.each do |info|
        info["categories"].andand.each do |cat|
          (categories[cat] ||= []) << info
        end
      end

      process_alphabetically(categories) {|k,v| puts "#{k}: #{v.count}"}
    end

    desc "list_articles", "list all used categories"
    def list_articles
      categories = {}

      article_metadata.each do |info|
        info["categories"].andand.each do |cat|
          (categories[cat] ||= []) << info
        end
      end

      process_alphabetically(categories) do |k,v|
        puts "#{k}:"
        v.each do |a|
          puts "  #{a['filename']}"
        end
      end
    end

  end

  class Tags < Thor

    include Helpers

    desc "count_articles", "list all used tags"
    def count_articles
      tags = {}

      article_metadata.each do |info|
        info["tags"].andand.each do |tag|
          (tags[tag] ||= []) << info
        end
      end

      process_alphabetically(tags) {|k,v| puts "#{k}: #{v.count}"}
    end
    
    desc "list_articles", "list all used categories"
    def list_articles
      tags = {}

      article_metadata.each do |info|
        info["tags"].andand.each do |tag|
          (tags[tag] ||= []) << info
        end
      end

      process_alphabetically(tags) do |k,v|
        puts "#{k}:"
        v.each do |a|
          puts "  #{a['filename']}"
        end
      end
    end

  end

end
