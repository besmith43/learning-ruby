Sinatra Adserver app
====================

The Adserver app here includes several updates to work better with
current versions of the various software libraries.

To use:

* gem install rack
* rackup config.ru

To deploy to Heroku:

* gem install heroku
* git init
* git add .
* git commit
* heroku create my-app-name
* git push heroku master
* heroku open

Notable Changes
===============

* Uses the Isolate library for bundling dependencies.
* Includes libraries that were extracted out of DataMapper, such as dm-migrations.
* Includes a "rake deploy" task for Heroku deployment.
* Looks for Heroku database environment variable. Uses local Sqlite database otherwise.



