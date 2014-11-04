# BaseHangul

[![Build Status](https://travis-ci.org/yous/basehangul.svg?branch=master)](https://travis-ci.org/yous/basehangul)
[![Dependency Status](https://gemnasium.com/yous/basehangul.svg)](https://gemnasium.com/yous/basehangul)
[![Code Climate](https://codeclimate.com/github/yous/basehangul/badges/gpa.svg)](https://codeclimate.com/github/yous/basehangul)
[![Coverage Status](https://img.shields.io/coveralls/yous/basehangul.svg)](https://coveralls.io/r/yous/basehangul)
[![Inline docs](http://inch-ci.org/github/yous/basehangul.svg?branch=master)](http://inch-ci.org/github/yous/basehangul)

[BaseHangul](https://github.com/koreapyj/basehangul) for Ruby. BaseHangul is an binary encoder using hangul. You can see [the specification](http://api.dcmys.jp/basehangul/) of it.

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
# => "넥라똔먈늴멥갯놓궂뗐밸뮤뉴뗐뀄굡덜멂똑뚤"

BaseHangul.decode('넥라똔먈늴멥갯놓궂뗐밸뮤뉴뗐뀄굡덜멂똑뚤')
# => "This is an encoded string"
```

## Contributing

1. Fork it (https://github.com/yous/basehangul/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## License

Copyright (c) ChaYoung You. See [LICENSE.txt](LICENSE.txt) for further details.
