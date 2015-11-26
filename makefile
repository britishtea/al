.PHONY: test

test:
	RUBYLIB=lib cutest test/*_test.rb
