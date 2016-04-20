# encoding: utf-8

RSpec.describe BaseHangul::Utils do
  subject(:utils) { described_class }
  let(:padding) { BaseHangul.const_get(:PADDING) }

  describe '.to_index' do
    it 'converts hangul to index' do
      range = ('가'.encode(Encoding::EUC_KR)..'빗'.encode(Encoding::EUC_KR))
              .map { |v| v.encode(Encoding::UTF_8) }
      range.each_with_index do |hangul, expected|
        index = utils.to_index(hangul)
        expect(index).to eq(expected)
      end
    end

    it 'converts padding hangul to -1' do
      index = utils.to_index(padding)
      expect(index).to eq(-1)
    end

    it 'returns nil for invalid character' do
      range = ["\x00", "\uFFFF",
               'A', 'b', '1',
               '갂', '갃', '뷁',
               *('빙'.encode(Encoding::EUC_KR)..'힝'.encode(Encoding::EUC_KR))
                 .map { |v| v.encode(Encoding::UTF_8) }]
      range.reject { |v| v == padding }.each do |hangul|
        index = utils.to_index(hangul)
        expect(index).to eq(nil)
      end
    end
  end

  describe '.to_hangul' do
    it 'converts index to hangul' do
      range = ('가'.encode(Encoding::EUC_KR)..'빗'.encode(Encoding::EUC_KR))
              .map { |v| v.encode(Encoding::UTF_8) }
      (0..1027).each do |index|
        hangul = utils.to_hangul(index)
        expect(range.index(hangul)).to eq(index)
      end
    end

    it 'raises IndexError for index out of range' do
      [-100, -1, 1028, 2000].each do |index|
        expect { utils.to_hangul(index) }
          .to raise_error(IndexError, "Index #{index} outside of valid " \
                                      'range: 0..1027')
      end
    end
  end

  describe '.decode_indices' do
    it 'returns empty string for empty array' do
      decoded = utils.decode_indices([])
      expect(decoded).to eq('')
    end

    context 'when there is no padding indices' do
      it 'decodes indices to binary' do
        decoded = utils.decode_indices([196, 803, 216, 354])
        expect(decoded).to eq('123ab')
        decoded = utils.decode_indices([196, 803, 217, 0])
        expect(decoded).to eq("123d\x00")
        decoded = utils.decode_indices([196, 803, 205, 53, 216, 883, 526, 304])
        expect(decoded).to eq('1234567890')
        decoded = utils.decode_indices([196, 803, 205, 53, 216, 883, 537, 0])
        expect(decoded).to eq("12345678d\x00")
      end
    end

    context 'when there are padding characters' do
      it 'decodes indices to binary' do
        decoded = utils.decode_indices([196, -1, -1, -1])
        expect(decoded).to eq('1')
        decoded = utils.decode_indices([196, 800, -1, -1])
        expect(decoded).to eq('12')
        decoded = utils.decode_indices([196, 803, 192, -1])
        expect(decoded).to eq('123')
        decoded = utils.decode_indices([196, 803, 205, 53, 216, 880, -1, -1])
        expect(decoded).to eq('1234567')
        decoded = utils.decode_indices([196, 803, 205, 53, 216, 883, 512, -1])
        expect(decoded).to eq('12345678')
      end
    end

    context 'when there are special characters' do
      it 'decodes indices to binary' do
        decoded = utils.decode_indices([196, 803, 217, 1024])
        expect(decoded).to eq('123d')
        decoded = utils.decode_indices([196, 803, 217, 1025])
        expect(decoded).to eq('123e')
        decoded = utils.decode_indices([196, 803, 217, 1026])
        expect(decoded).to eq('123f')
        decoded = utils.decode_indices([196, 803, 217, 1027])
        expect(decoded).to eq('123g')
        decoded = utils.decode_indices([196, 803, 205, 53, 216, 883, 537, 1024])
        expect(decoded).to eq('12345678d')
        decoded = utils.decode_indices([196, 803, 205, 53, 216, 883, 537, 1025])
        expect(decoded).to eq('12345678e')
        decoded = utils.decode_indices([196, 803, 205, 53, 216, 883, 537, 1026])
        expect(decoded).to eq('12345678f')
        decoded = utils.decode_indices([196, 803, 205, 53, 216, 883, 537, 1027])
        expect(decoded).to eq('12345678g')
      end
    end
  end

  describe '.chunks' do
    context 'with empty string' do
      it 'returns an empty array' do
        [1, 5, 100].each do |size|
          chunks = utils.chunks('', size)
          expect(chunks).to match_array([])
        end
      end
    end

    context 'with string of which length is multiple of size' do
      it 'returns an array of chunks' do
        # rubocop:disable Style/WordArray
        chunks = utils.chunks('foo', 1)
        expect(chunks).to match_array(['f', 'o', 'o'])
        chunks = utils.chunks('foobarbaz', 3)
        expect(chunks).to match_array(['foo', 'bar', 'baz'])
        # rubocop:enable Style/WordArray
      end
    end

    context 'with string of which length is not multiple of size' do
      it 'returns an array of chunks' do
        # rubocop:disable Style/WordArray
        chunks = utils.chunks('abcd1234A', 4)
        expect(chunks).to match_array(['abcd', '1234', 'A'])
        chunks = utils.chunks('abcd1234AB', 4)
        expect(chunks).to match_array(['abcd', '1234', 'AB'])
        chunks = utils.chunks('abcd1234ABC', 4)
        expect(chunks).to match_array(['abcd', '1234', 'ABC'])
        # rubocop:enable Style/WordArray
      end
    end

    context 'with invalid size' do
      it 'raises ArgumentError' do
        [0, -1, -5].each do |size|
          expect { utils.chunks('foo', size) }
            .to raise_error(ArgumentError, 'Invalid slice size')
        end
      end
    end
  end
end
