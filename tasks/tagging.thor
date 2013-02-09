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
        YAML.load(pieces[2])
      end
    end

    def print_alphabetically(hash)
      hash.keys.sort{|a,b| a.downcase <=> b.downcase}.each do |key|
        puts "#{key}: #{hash[key]}"
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

    desc "list", "list all used categories"
    def list
      categories = Hash.new(0)

      article_metadata.each do |info|
        info["categories"].each do |cat|
          categories[cat] += 1
        end
      end

      print_alphabetically categories
    end

  end

  class Tags < Thor

    include Helpers

    desc "list", "list all used tags"
    def list
      tags = Hash.new(0)

      article_metadata.each do |info|
        info["tags"].andand.each do |tag|
          tags[tag] += 1
        end
      end

      print_alphabetically tags
    end

  end

end
