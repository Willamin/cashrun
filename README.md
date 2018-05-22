# cashrun

Designed to facilitate using Crystal for short shell scripts, Cashrun allows
you to more simply run scripts written in Crystal. The first time you run a Crystal
script, it will be compiled and cached. As long as the script didn't change,
the compiled binary will be used in the future.

## Usage

Cashrun should be specified in your script's shebang. For example:
```crystal
#!/usr/bin/env cashrun

puts "hello from crystal!"
```

## Caveats

This tool does not automatically remove old compiled binaries. That may be a
future feature, but for the time being, you'll need to clean up after yourself.


## Contributing

1. Fork it ( https://github.com/willamin/cashrun/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [willamin](https://github.com/willamin) Will Lewis - creator, maintainer
