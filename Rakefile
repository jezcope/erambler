require 'nanoc3/tasks'
require 'yaml'
require 'set'
require 'andand'
require 'pp'

namespace "tags" do

  task :list do
    articles = FileList['content/articles/*/*/*']
    tags = Hash.new(0)
    articles.each do |x|
      info = YAML::load(open(x))
      info['tags'].andand.each do |t|
        tags[t] += 1
      end
    end
    pp tags
  end

end

namespace "categories" do

  task :list do
    articles = FileList['content/articles/*/*/*']
    cats = Hash.new(0)
    articles.each do |x|
      info = YAML::load(open(x))
      info['categories'].andand.each do |t|
        cats[t] += 1
      end
    end
    pp cats
  end

end
