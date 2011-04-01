[Wefootball](http://www.wefootball.org) - Football SNS
===============================================

Installation
------------
1. `gem install rails -v 2.2.2` or `rake rails:freeze:edge TAG=rel_2_2_2`
2. install databse adapter if necessary (`gem install sqlite3-ruby` or `gem install mysql`)
3. install ImageMagick
4. `git clone wefootball.git`
5. create and edit `config/database.yml` (a template in `config/database.yml.template`)
6. create and edit `config/ganalytics.yml` (a template in `config/ganalytics.yml.template`)
7. `rake gems:build` 
8. `rake gems:install` (install local OS specific nokogiri)
9. `rake secret` and replace session secret in `config/environment.rb`

Run Tests
---------
1. `rake db:migrate RAILS_ENV=test`
2. `rake test RAILS_ENV=test`

Screen Casts
------------
* pics in `./public/screencasts/`
