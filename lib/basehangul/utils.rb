# encoding: utf-8

module BaseHangul
  # Helper methods for BaseHangul.
  module Utils
    # Convert a hangul character to index.
    #
    # hangul - A hangul character encoded with BaseHangul.
    #
    # Examples
    #
    #   to_index('가')
    #   # => 0
    #
    #   to_index('빌')
    #   # => 1023
    #
    #   to_index('빗')
    #   # => 1027
    #
    #   to_index('흐')
    #   # => -1
    #
    # Returns the Integer index of the hangul between 0 to 1027 or nil if the
    #   character is invalid for BaseHangul.
    def self.to_index(hangul)
      return -1 if hangul == PADDING
      offset = hangul.encode(Encoding::EUC_KR).ord - 0xB0A1
      index = offset / 0x100 * 0x5E + offset % 0x100
      return nil if index < 0 || index > 1027
      index
    rescue Encoding::UndefinedConversionError
      nil
    end

    # Convert a index to hangul character.
    #
    # index - An Integer to convert.
    #
    # Examples
    #
    #   to_hangul(0)
    #   # => '가'
    #
    #   to_hangul(1023)
    #   # => '빌'
    #
    #   to_hangul(1027)
    #   # => '빗'
    #
    # Returns the String hangul for given index.
    # Raises IndexError if the index is out of range 0..1027.
    def self.to_hangul(index)
      if index < 0 || index > 1027
        raise IndexError, "Index #{index} outside of valid range: 0..1027"
      end
      (index / 0x5E * 0x100 + index % 0x5E + 0xB0A1)
        .chr(Encoding::EUC_KR)
        .encode(Encoding::UTF_8)
    end

    # Convert BaseHangul indices to hangul string.
    #
    # Examples
    #
    #   decode_indices([196, -1, -1, -1])
    #   # => '꺽흐흐흐'
    #
    # Returns the String decoded binary.
    def self.decode_indices(indices)
      binary = indices.map do |index|
        case index
        when 0..1023    then index.to_s(2).rjust(10, '0')
        when 1024..1027 then (index - 1024).to_s(2).rjust(2, '0')
        end
      end.join
      binary = binary[0..-(binary.size % 8 + 1)]
      [binary].pack('B*')
    end

    # Slice a string into chunks of a given size.
    #
    # str  - The String to slice.
    # size - The Integer max size of each chunk.
    #
    # Examples
    #
    #   chunks('foo', 1)
    #   # => ['f', 'o', 'o']
    #
    #   chunks('foobarbaz', 3)
    #   # => ['foo', 'bar', 'baz']
    #
    #   chunks('abcd1234AB', 4)
    #   # => ['abcd', '1234', 'AB']
    #
    #   chunks('', 1)
    #   # => []
    #
    # Returns an Array of chunked Strings.
    # Raises ArgumentError if the size is smaller than or equal to 0.
    def self.chunks(str, size)
      raise ArgumentError, 'Invalid slice size' if size <= 0
      new_str = str.dup
      array = []
      array << new_str.slice!(0...size) until new_str.empty?
      array
    end
  end
end
