Rightly or wrongly, this application scrapes the public internet and joins
the dots. All information used is already in the public domain, but disjointed.
We just bring it all together to provide some illumination. We did it because
it was fun, not because we're in the business of spying on people. There's
already enough people doing that without us joining in. The truth is though,
this data, in its illuminated state is actually quite valuable to some people
and providing those people have reasonably* good intentions we're willing to
exchange our time for money, like the rest of the world. That means, the data
here is for sale. If you have an interest in the contents, get in touch, we'd
like to talk to you.





Application Code Architecture Re-think...

# We can then search stackoverflow for the username, if we find it
# we can compare some stats and potentially build up another aspect
# of the user.

# Oh my, this is turning into a serious stalker database...haha!
# https://github.com/search?o=desc&q=ruby&s=repositories&type=Users&utf8=%E2%9C%93
# http://stackoverflow.com/users?tab=Reputation&filter=all&search=#{:username}
# https://plus.google.com/s/#{:username}
# http://www.reddit.com/search?q=author%3A#{:username}&
# https://twitter.com/#{:username}
# https://instagram.com/#{:username}/
# https://disqus.com/by/#{:username}/
# http://codepen.io/#{:username}/
# https://keybase.io/#{:username}
# https://www.linkedin.com/in/#{:username} <--- lots of "skills" here

class Domain
  module_function
  def crawl(level: 1)
    Anemone.crawl...
    anemone.on_every_page do |page|
      process_page(page)...
    end
  end
  def page_types
    PageTypes::constants.to_enum
  end
  def process_page(page)
    klazz = page_types.next
    begin
      doc = klazz.new(page)
      if doc.valid?
        # save somewhere...
        raise StopIteration
      end
    rescue WrongTemplateError

      write_page
      process_page(page)
    end
  rescue StopIteration
    puts "finished processing page..."
  end
end

class Github < Domain
  INVALID_PATHS=/login|etc|.../
  URL="https://github.com/search?o=desc&q=ruby&s=repositories&type=Users&utf8=%E2%9C%93"
  module PageTypes
    class UserPage # responsiblity?
      def initialize(doc)
        # extract data to instance methods...
      end
    end
    class OrganizationPage
      ...
    end
    class ProjectPage
      ...
    end
  end
end

class StackOverflow < Domain
  URL="http://stackoverflow.com/users?tab=Reputation&filter=all&search=#{:username}"
end

= Business Objects
User
Skill
Project
Organization


Github.new().crawl(level: 3)

#Process.new(domain: Github).crawl(:level)
