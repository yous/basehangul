# encoding: utf-8

require 'basehangul/version'
require 'basehangul/utils'
require 'basehangul/option'
require 'basehangul/cli'

# Human-readable binary encoding.
module BaseHangul
  # Character for padding on encoding.
  PADDING = '흐'.freeze

  # Error message for invalid character.
  MSG_INVALID_CHAR = 'Invalid character found'.freeze

  # Error message for incorrect padding.
  MSG_INVALID_PADDING = 'Invalid padding'.freeze

  # Regular expression for BaseHangul.
  REGEX_BASEHANGUL = Regexp.new('^(?:[^빎빔빕빗흐]{4})*' \
    '(?:[^빎빔빕빗흐]흐{3}|[^빎빔빕빗흐]{2}흐{2}|' \
    '[^빎빔빕빗흐]{3}[빎빔빕빗흐])?$').freeze

  private_constant :PADDING, :MSG_INVALID_CHAR, :MSG_INVALID_PADDING

  # Public: Encode binary with BaseHangul.
  #
  # bin - A String binary to encode.
  #
  # Returns the String encoded hangul.
  def self.encode(bin)
    chunks = Utils.chunks(bin.unpack('B*').first, 10)
    padding = ''
    last = chunks.last
    if last
      case last.size
      when 2       then chunks[-1] = '1' + last.rjust(10, '0')
      when 4, 6, 8 then padding = PADDING * (last.size / 2 - 1)
      end
    end
    chunks.map { |b| Utils.to_hangul(b.ljust(10, '0').to_i(2)) }.join + padding
  end

  # Public: Decode BaseHangul string. Characters outside the BaseHangul are
  # ignored.
  #
  # str - A String encoded with BaseHangul.
  #
  # Returns the String decoded binary.
  def self.decode(str)
    Utils.decode_indices(str.each_char.map { |ch| Utils.to_index(ch) })
  end

  # Public: Decode BaseHangul string.
  #
  # str - A String encoded with BaseHangul.
  #
  # Returns the String decoded binary.
  # Raises ArgumentError if str is invalid BaseHangul.
  def self.strict_decode(str)
    indices = []
    str.each_char do |ch|
      index = Utils.to_index(ch)
      raise ArgumentError, MSG_INVALID_CHAR if index.nil?
      indices << index
    end
    raise ArgumentError, MSG_INVALID_PADDING unless str =~ REGEX_BASEHANGUL
    Utils.decode_indices(indices)
  end
end
