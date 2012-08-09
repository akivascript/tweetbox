#!/bin/bash
PARAMS=$(/usr/bin/ruby /usr/local/bin/preptweet.rb $2)
/usr/bin/ruby -X /Users/akiva/.rvm/gems/ruby-1.9.3-p194@rails3tutorial/gems/twurl-0.7.0/bin twurl $1 "$PARAMS" $3 
