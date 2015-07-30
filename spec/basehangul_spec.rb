# encoding: utf-8

RSpec.describe BaseHangul do
  subject(:basehangul) { described_class }

  describe '.encode' do
    it 'returns empty string with empty binary' do
      encoded = basehangul.encode('')
      expect(encoded).to eq('')
    end

    context 'when the length is multiple of 5' do
      it 'encodes binary to hangul' do
        encoded = basehangul.encode('This is an encoded string')
        expect(encoded).to eq('넥라똔먈늴멥갯놓궂뗐밸뮤뉴뗐뀄굡덜멂똑뚤')
        encoded = basehangul.encode('123ab')
        expect(encoded).to eq('꺽먹꼍녜')
        encoded = basehangul.encode("123d\x00")
        expect(encoded).to eq('꺽먹꼐가')
        encoded = basehangul.encode('1234567890')
        expect(encoded).to eq('꺽먹께겔꼍뮷뒝낮')
        encoded = basehangul.encode("12345678d\x00")
        expect(encoded).to eq('꺽먹께겔꼍뮷듕가')
      end
    end

    context 'when the remainder is 1, 2, 3 when the length is divided by 5' do
      it 'encodes binary to hangul with padding' do
        encoded = basehangul.encode('1')
        expect(encoded).to eq('꺽흐흐흐')
        encoded = basehangul.encode('12')
        expect(encoded).to eq('꺽먈흐흐')
        encoded = basehangul.encode('123')
        expect(encoded).to eq('꺽먹꺄흐')
        encoded = basehangul.encode('123456')
        expect(encoded).to eq('꺽먹께겔꼍흐흐흐')
        encoded = basehangul.encode('1234567')
        expect(encoded).to eq('꺽먹께겔꼍뮨흐흐')
        encoded = basehangul.encode('12345678')
        expect(encoded).to eq('꺽먹께겔꼍뮷됩흐')
      end
    end

    context 'when the remainder is 4 when the length is divided by 5' do
      it 'encodes binary to hangul' do
        encoded = basehangul.encode('123d')
        expect(encoded).to eq('꺽먹꼐빎')
        encoded = basehangul.encode('123e')
        expect(encoded).to eq('꺽먹꼐빔')
        encoded = basehangul.encode('123f')
        expect(encoded).to eq('꺽먹꼐빕')
        encoded = basehangul.encode('123g')
        expect(encoded).to eq('꺽먹꼐빗')
        encoded = basehangul.encode('12345678d')
        expect(encoded).to eq('꺽먹께겔꼍뮷듕빎')
        encoded = basehangul.encode('12345678e')
        expect(encoded).to eq('꺽먹께겔꼍뮷듕빔')
        encoded = basehangul.encode('12345678f')
        expect(encoded).to eq('꺽먹께겔꼍뮷듕빕')
        encoded = basehangul.encode('12345678g')
        expect(encoded).to eq('꺽먹께겔꼍뮷듕빗')
      end
    end
  end

  describe '.decode' do
    it_behaves_like 'a decoder', :decode

    context 'when string has wrong number of padding characters' do
      it 'decodes hangul to binary' do
        decoded = basehangul.decode('꺽')
        expect(decoded).to eq('1')
        decoded = basehangul.decode('꺽흐')
        expect(decoded).to eq('1')
        decoded = basehangul.decode('꺽흐흐')
        expect(decoded).to eq('1')
        decoded = basehangul.decode('꺽흐흐흐흐')
        expect(decoded).to eq('1')
        decoded = basehangul.decode('꺽먈')
        expect(decoded).to eq('12')
        decoded = basehangul.decode('꺽먹꺄')
        expect(decoded).to eq('123')
        decoded = basehangul.decode('꺽먹께겔꼍')
        expect(decoded).to eq('123456')
        decoded = basehangul.decode('꺽먹께겔꼍뮨')
        expect(decoded).to eq('1234567')
        decoded = basehangul.decode('꺽먹께겔꼍뮷됩')
        expect(decoded).to eq('12345678')
        decoded = basehangul.decode('꺽먹꼍녜흐')
        expect(decoded).to eq('123ab')
        decoded = basehangul.decode('꺽먹께겔꼍뮷뒝낮흐흐')
        expect(decoded).to eq('1234567890')
      end
    end

    context 'when there are invalid characters' do
      it 'ignores invalid characters' do
        strings = [' 꺽먹꼍녜',
                   '꺽먹꼍녜 ',
                   "\n꺽\t먹\u3000꼍abc녜"]
        strings.each do |encoded|
          decoded = basehangul.decode(encoded)
          expect(decoded).to eq('123ab')
        end
      end
    end
  end

  describe '.strict_decode' do
    let(:msg_invalid_char) { basehangul.const_get(:MSG_INVALID_CHAR) }
    let(:msg_invalid_padding) { basehangul.const_get(:MSG_INVALID_PADDING) }

    it_behaves_like 'a decoder', :strict_decode

    context 'when string has wrong number of padding characters' do
      it 'raises ArgumentError' do
        strings = %w(꺽
                     꺽흐
                     꺽흐흐
                     꺽흐흐흐흐
                     꺽먈
                     꺽먹꺄
                     꺽먹께겔꼍
                     꺽먹께겔꼍뮨
                     꺽먹께겔껼뮷됩
                     꺽먹꼍녜흐
                     꺽먹께겔꼍뮷뒝낮흐흐)
        strings.each do |encoded|
          expect { basehangul.strict_decode(encoded) }
            .to raise_error(ArgumentError, msg_invalid_padding)
        end
      end
    end

    context 'when string has characters after padding characters' do
      it 'raises ArgumentError' do
        strings = %w(꺽흐꺽흐흐흐
                     꺽흐흐흐꺽흐흐흐
                     꺽먹꺄흐꺽
                     꺽먹께흐겔꼍흐흐흐
                     꺽먹꼐흐꺽먹꼐빎)
        strings.each do |encoded|
          expect { basehangul.strict_decode(encoded) }
            .to raise_error(ArgumentError, msg_invalid_padding)
        end
      end
    end

    context 'when string has special characters with wrong position' do
      it 'raises ArgumentError' do
        strings = %w(꺽먹꼐빎꺽흐흐흐
                     꺽먹빎
                     꺽먹빎흐)
        strings.each do |encoded|
          expect { basehangul.strict_decode(encoded) }
            .to raise_error(ArgumentError, msg_invalid_padding)
        end
      end
    end

    context 'when there are invalid characters' do
      it 'raises ArgumentError' do
        strings = [' 꺽먹꼍녜',
                   '꺽먹꼍녜 ',
                   "\n꺽\t먹\u3000꼍abc녜"]
        strings.each do |encoded|
          expect { basehangul.strict_decode(encoded) }
            .to raise_error(ArgumentError, msg_invalid_char)
        end
      end
    end
  end
end
