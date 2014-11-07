# encoding: utf-8

require 'basehangul/version'
require 'basehangul/utils'

# Human-readable binary encoding.
module BaseHangul
  # Character for padding on encoding.
  PADDING = '흐'.freeze
  private_constant :PADDING

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
    indices = str.each_char.map { |ch| Utils.to_index(ch) }
    binary = indices.map do |index|
      case index
      when nil, -1    then ''
      when 0..1023    then index.to_s(2).rjust(10, '0')
      when 1024..1027 then (index - 1024).to_s(2).rjust(2, '0')
      end
    end.join
    binary = binary[0..-(binary.size % 8 + 1)]
    [binary].pack('B*')
  end
end
