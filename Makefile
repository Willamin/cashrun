build:
	shards build --release --no-debug

install:
	ln -s $(shell pwd)/bin/cashrun ~/bin/cashrun
