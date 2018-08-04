build:
	shards build --release --no-debug

install:
	ln -s $(pwd)/bin/cashrun ~/bin/cashrun
