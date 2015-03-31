require 'byebug'
$:.unshift File.join(File.dirname(__FILE__), ".") # current directory
require 'github'
require 'db/active_record'


url = "https://github.com/search?q=ruby&s=repositories&type=Users"
Github.new(start_url: url, db_adapter: Db).crawl(level:1)
