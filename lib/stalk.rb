require 'byebug'
# require 'mongo'
require './db/database'
require './lib/domain/github'

Domain::Github::Processor.new.run

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

# Why not, what about disqus
# https://disqus.com/by/Zepalesque/
