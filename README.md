# Rdown

[![](https://github.com/r7kamura/rdown/workflows/test/badge.svg)](https://github.com/r7kamura/rdown/actions?query=workflow%3Atest)

Parser for [Ruby Reference Manual](https://github.com/rurema/doctree).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rdown'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rdown

## Usage

```ruby
require 'rdown'

source = <<~RD
= class Array < Object

== Instance Methods

--- [](nth)    -> object | nil
--- at(nth)    -> object | nil

nth 番目の要素を返します。nth 番目の要素が存在しない時には nil を返します。
RD

pre_processed_source = Rdown::PreProcessor.call(source)
tokens = Rdown::Tokenizer.call(**pre_processed_source)
node = Rdown::Parser.call(tokens)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/r7kamura/rdown.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
