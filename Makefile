.PHONY: init dev test

init:
	bundle install
	bin/rails db:prepare

dev:
	rails server

test:
	bundle exec rspec