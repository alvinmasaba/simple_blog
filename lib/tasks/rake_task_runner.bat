@echo off
cd C:\Users\owner\Documents\projects\simple_blog
call bundle exec rails update:spreadsheet && bundle exec rails update:ratings
