# encoding: utf-8

require 'basehangul/version'

# Binary encoder using hangul.
module BaseHangul
  # Character for padding on encoding.
  PADDING = '흐'.encode(Encoding::EUC_KR).freeze
  private_constant :PADDING

  private

  # Convert a hangul character to index.
  #
  # hangul - A hangul character encoded with BaseHangul.
  #
  # Returns the Integer index of the hangul between 0 to 1023.
  # Raises ArgumentError if the character is not valid for BaseHangul.
  def self.to_index(hangul)
    return -1 if hangul == PADDING
    offset = hangul.ord - 0xB0A1
    index = offset / 0x100 * 0x5E + offset % 0x100
    if index < 0 || index > 1023
      fail ArgumentError, 'Not a valid BaseHangul string'
    end
    index
  end

  # Convert a index to hangul character.
  #
  # index - An Integer to convert.
  #
  # Returns the String hangul for given index.
  # Raises IndexError if the index is out of range 0..1023.
  def self.to_hangul(index)
    if index < 0 || index > 1023
      fail IndexError, "Index #{index} outside of valid range: 0..1023"
    end
    (index / 0x5E * 0x100 + index % 0x5E + 0xB0A1).chr(Encoding::EUC_KR)
  end
end
