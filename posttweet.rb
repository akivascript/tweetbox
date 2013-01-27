require 'cgi'
require '/Users/akiva/.rvm/gems/ruby-1.9.3-p194@rails3tutorial/gems/twurl-0.8.0/lib/twurl'

punct_class = '[!"#\$\%\'()*+,\-.\/:;<=>?\@\[\\\\\]\^_`{|}~]'

tweet = ARGV[0].dup

tweet = CGI.unescape(tweet)

# Special case if the very first character is a quote followed by
# punctuation at a non-word-break. Close the quotes by brute
# force:
tweet.gsub!(/^'(?=#{punct_class}\B)/, '’')
tweet.gsub!(/^"(?=#{punct_class}\B)/, '”')

# Special case for double sets of quotes, e.g.:
#   <p>He said, "'Quoted' words in a larger quote."</p>
tweet.gsub!(/"'(?=\w)/, '“‘')
tweet.gsub!(/'"(?=\w)/, '‘“')

# Special case for decade abbreviations (the '80s):
tweet.gsub!(/'(?=\d\ds)/, '’')

close_class = %![^\ \t\r\n\\[\{\(\-]!
dec_dashes = '–|—'
     
# Get most opening single quotes:
tweet.gsub!(/(\s|&nbsp;|--|&[mn]dash;|#{dec_dashes}|&#x201[34];)'(?=\w)/, '\1‘')
# Single closing quotes:
tweet.gsub!(/(#{close_class})'/, '\1’')
tweet.gsub!(/'(\s|s\b|$)/, '’\1')
# Any remaining single quotes should be opening ones:
tweet.gsub!(/'/, '‘')

# Get most opening double quotes:
tweet.gsub!(/(\s|&nbsp;|--|&[mn]dash;|#{dec_dashes}|&#x201[34];)"(?=\w)/, '\1“')
# Double closing quotes:
tweet.gsub!(/(#{close_class})"/, '\1”')
tweet.gsub!(/"(\s|s\b|$)/, '”\1')
# Any remaining quotes should be opening ones:
tweet.gsub!(/"/, '“')
#
# need to use str.gsub: replacement is > replaced characters
tweet.gsub!("...","…")

args = [ "-d",
				 tweet,
				 "/1.1/statuses/update.json" ]

Twurl::CLI.run(args)
