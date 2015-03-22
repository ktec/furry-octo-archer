require 'anemone'
require 'byebug'
# require 'mongo'
require 'fileutils'
require './database'

INVALID_URLS = /login|search|blog|features|trending|showcases|site|about|security|plans|pricing|integrations|contact|join|explore/

def filter(links=[])
  links.select { |link|
    link.request_uri !~ INVALID_URLS
  }
end

class Profile
  def initialize(doc)
    @doc = doc
  end

  def valid?
    unless fullname.empty? &&
           username.empty? &&
           homelocation.empty?
      true
    end
  end

  def attributes
    {
      fullname: fullname,
      username: username,
      location: homelocation
    }
  end

  def details
    "fullname:#{fullname}\t" \
    "username:#{username}\t" \
    "location:#{homelocation}\n"
  end

  def fullname
    begin
      @doc.css("[class='vcard-fullname']").text
    rescue
      ""
    end
  end

  def username
    begin
      @doc.css("[class='vcard-username']").text
    rescue
      ""
    end
  end

  def homelocation
    begin
      @doc.css("[class='vcard-detail'][itemprop='homeLocation']").text
    rescue
      ""
    end
  end
end

def process_page(page)
  profile = Profile.new(page.doc)
  if profile.valid?

    dir = './cache' + page.url.path
    FileUtils::mkdir_p dir
    File.open(dir + '/page.html', 'a') {|f| f.write(page.body) }

    File.open('./people.txt', 'a') {|f| f.write(profile.details) }
    user = User.find_or_create_by(profile.attributes)

  end  
end

Anemone.crawl("https://github.com/search?o=desc&q=ruby&s=repositories&type=Users&utf8=%E2%9C%93", :depth_limit => 3) do |anemone|
  anemone.focus_crawl { |page|
    filter(page.links)
  }
  #test_file = 'test.db'
  #anemone.storage = Anemone::Storage.SQLite3(test_file)
  #anemone.storage = Anemone::Storage.MongoDB
  #anemone.storage = Anemone::Storage.Redis
  anemone.on_every_page do |page|
    process_page(page) if page.code == 200 &&
      page.url.to_s !~ INVALID_URLS
  end
end

# We can then search stackoverflow for the username, if we find it
# we can compare some stats and potentially build up another aspect
# of the user. http://stackoverflow.com/users?tab=Reputation&filter=all&search=rubysolo

# Then we've got google plus..
# https://plus.google.com/s/rubysolo

# Reddit
# http://www.reddit.com/search?q=author%3Arubysolo&

# Twitter...of course!
# https://twitter.com/rubysolo

# Instagram...
# https://instagram.com/rubysolo/

# Oh my, this is turning into a serious stalker database...haha!
