build:
	shards build --release --no-debug

link:
	ln -s $(shell pwd)/bin/cashrun ~/bin/cashrun

install:
	cp $(shell pwd)/bin/cashrun ~/bin/cashrun