# BaseHangul

[![Gem Version](https://badge.fury.io/rb/basehangul.svg)](http://badge.fury.io/rb/basehangul)
[![Build Status](https://travis-ci.org/yous/basehangul.svg?branch=master)](https://travis-ci.org/yous/basehangul)
[![Dependency Status](https://gemnasium.com/yous/basehangul.svg)](https://gemnasium.com/yous/basehangul)
[![Code Climate](https://codeclimate.com/github/yous/basehangul/badges/gpa.svg)](https://codeclimate.com/github/yous/basehangul)
[![Coverage Status](https://img.shields.io/coveralls/yous/basehangul.svg)](https://coveralls.io/r/yous/basehangul)
[![Inline docs](http://inch-ci.org/github/yous/basehangul.svg?branch=master)](http://inch-ci.org/github/yous/basehangul)

Human-readable binary encoding, [BaseHangul](https://basehangul.github.io) for Ruby.

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'basehangul'
```

And then execute:

``` sh
bundle
```

Or install it yourself as:

``` sh
gem install basehangul
```

## Usage

``` ruby
BaseHangul.encode('This is an encoded string')
# => '넥라똔먈늴멥갯놓궂뗐밸뮤뉴뗐뀄굡덜멂똑뚤'

BaseHangul.decode('넥라똔먈늴멥갯놓궂뗐밸뮤뉴뗐뀄굡덜멂똑뚤')
# => 'This is an encoded string'
```

Run `basehangul` with no arguments to encode binary through terminal input.

``` sh
basehangul
```

Or pass `basehangul` a file to encode.

``` sh
basehangul binary.txt
```

Run `basehangul` with no arguments to decode BaseHangul string through terminal input.

``` sh
basehangul -D
```

Or pass `basehangul` a file to decode.

``` sh
basehangul -D basehangul.txt
```

For additional command-line options:

``` sh
basehangul -h
```

Command flag    | Description
----------------|--------------------
`-D, --decode`  | Decode the input.
`-h, --help`    | Print this message.
`-v, --version` | Print version.

## Contributing

1. Fork it (https://github.com/yous/basehangul/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## License

Copyright (c) Chayoung You. See [LICENSE.txt](LICENSE.txt) for further details.
