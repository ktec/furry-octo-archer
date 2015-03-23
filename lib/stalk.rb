require 'byebug'
require './lib/domain/github'

Domain::Github::Processor.new("https://github.com/search?o=desc&q=ruby&s=repositories&type=Users&utf8=%E2%9C%93").run

# We can then search stackoverflow for the username, if we find it
# we can compare some stats and potentially build up another aspect
# of the user.

# Oh my, this is turning into a serious stalker database...haha!
# http://stackoverflow.com/users?tab=Reputation&filter=all&search=#{:username}
# https://plus.google.com/s/#{:username}
# http://www.reddit.com/search?q=author%3A#{:username}&
# https://twitter.com/#{:username}
# https://instagram.com/#{:username}/
# https://disqus.com/by/#{:username}/
# http://codepen.io/#{:username}/
# https://keybase.io/#{:username}
# https://www.linkedin.com/in/#{:username} <--- lots of "skills" here
