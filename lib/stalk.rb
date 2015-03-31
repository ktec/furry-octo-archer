require 'byebug'
$:.unshift File.join(File.dirname(__FILE__), ".") # current directory
require 'domain/github'
require 'db/active_record'

start_url = "https://github.com/search?o=desc&q=ruby&s=repositories&type=Users&utf8=%E2%9C%93"

Domain::Github::Processor.new(start_url: start_url, db_adapter:  Db).run
