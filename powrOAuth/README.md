# README


* Set environment variables for Client ID and Client Secret with the following values:
	GH_BASIC_CLIENT_ID=6347dce44e924089dbc4
	GH_BASIC_SECRET_ID=ce3ece7856eb5d4df7007e96f6746bd24ecf2d78
	GH_BASIC_APP_NAME=powrOAuth
How to set env variables depends on your OS (Win,MacOS, etc)

Then run terminal, go to project folder and run below commands consequently

* bundle install
* rails db:migrate RAILS_ENV=development
* rails server

If everything finished successfully, go to rails start page http://localhost:3000 in your browser
You will see the start page of OAuth application there
