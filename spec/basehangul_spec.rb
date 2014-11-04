# encoding: utf-8

RSpec.describe BaseHangul do
  subject(:basehangul) { described_class }
  let(:padding) { basehangul.const_get(:PADDING) }

  describe '#to_index' do
    it 'converts hangul to index' do
      range = ('가'.encode(Encoding::EUC_KR)..'빗'.encode(Encoding::EUC_KR))
              .map { |v| v.encode(Encoding::UTF_8) }
      range.each_with_index do |hangul, expected|
        index = basehangul.send(:to_index, hangul)
        expect(index).to eq(expected)
      end
    end

    it 'converts padding hangul to -1' do
      index = basehangul.send(:to_index, padding)
      expect(index).to eq(-1)
    end

    it 'raises ArgumentError for invalid hangul' do
      range = ('빙'.encode(Encoding::EUC_KR)..'힝'.encode(Encoding::EUC_KR))
              .map { |v| v.encode(Encoding::UTF_8) }
      range.reject { |v| v == padding }.each do |hangul|
        expect { basehangul.send(:to_index, hangul) }
          .to raise_error(ArgumentError, 'Not a valid BaseHangul string')
      end
    end
  end

  describe '#to_hangul' do
    it 'converts index to hangul' do
      range = ('가'.encode(Encoding::EUC_KR)..'빗'.encode(Encoding::EUC_KR))
              .map { |v| v.encode(Encoding::UTF_8) }
      (0..1027).each do |index|
        hangul = basehangul.send(:to_hangul, index)
        expect(range.index(hangul)).to eq(index)
      end
    end

    it 'raises IndexError for index out of range' do
      [-100, -1, 1028, 2000].each do |index|
        expect { basehangul.send(:to_hangul, index) }
          .to raise_error(IndexError, "Index #{index} outside of valid " \
                                      'range: 0..1027')
      end
    end
  end
end
