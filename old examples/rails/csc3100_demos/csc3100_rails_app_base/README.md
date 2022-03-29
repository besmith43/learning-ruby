# README
To start the application:
* Start the database: `sudo service postgresql start`
* Create a postgres user: psql -c "CREATE USER rails_app WITH PASSWORD 'rails_app';"
* Create a postgres database: psql -c "CREATE DATABASE 'rails_app'"
* Start the application: `rails s -b $IP -p $PORT`
