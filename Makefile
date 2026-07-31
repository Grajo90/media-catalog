.PHONY: init dev test db

init:
	bundle install
	bin/rails db:prepare
	bin/rails db:seed

dev:
	rails server

test:
	bundle exec rspec

db:
	sqlite3 storage/development.sqlite3