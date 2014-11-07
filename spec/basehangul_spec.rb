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
    it 'returns empty binary with empty string' do
      decoded = basehangul.decode('')
      expect(decoded).to eq('')
    end

    context 'when there is no padding characters' do
      it 'decodes hangul to binary' do
        decoded = basehangul.decode('넥라똔먈늴멥갯놓궂뗐밸뮤뉴뗐뀄굡덜멂똑뚤')
        expect(decoded).to eq('This is an encoded string')
        decoded = basehangul.decode('꺽먹꼍녜')
        expect(decoded).to eq('123ab')
        decoded = basehangul.decode('꺽먹꼐가')
        expect(decoded).to eq("123d\x00")
        decoded = basehangul.decode('꺽먹께겔꼍뮷뒝낮')
        expect(decoded).to eq('1234567890')
        decoded = basehangul.decode('꺽먹께겔꼍뮷듕가')
        expect(decoded).to eq("12345678d\x00")
      end
    end

    context 'when there are padding characters' do
      it 'decodes hangul to binary' do
        decoded = basehangul.decode('꺽흐흐흐')
        expect(decoded).to eq('1')
        decoded = basehangul.decode('꺽먈흐흐')
        expect(decoded).to eq('12')
        decoded = basehangul.decode('꺽먹꺄흐')
        expect(decoded).to eq('123')
        decoded = basehangul.decode('꺽먹께겔꼍흐흐흐')
        expect(decoded).to eq('123456')
        decoded = basehangul.decode('꺽먹께겔꼍뮨흐흐')
        expect(decoded).to eq('1234567')
        decoded = basehangul.decode('꺽먹께겔꼍뮷됩흐')
        expect(decoded).to eq('12345678')
      end
    end

    context 'when there are special characters' do
      it 'decodes hangul to binary 'do
        decoded = basehangul.decode('꺽먹꼐빎')
        expect(decoded).to eq('123d')
        decoded = basehangul.decode('꺽먹꼐빔')
        expect(decoded).to eq('123e')
        decoded = basehangul.decode('꺽먹꼐빕')
        expect(decoded).to eq('123f')
        decoded = basehangul.decode('꺽먹꼐빗')
        expect(decoded).to eq('123g')
        decoded = basehangul.decode('꺽먹께겔꼍뮷듕빎')
        expect(decoded).to eq('12345678d')
        decoded = basehangul.decode('꺽먹께겔꼍뮷듕빔')
        expect(decoded).to eq('12345678e')
        decoded = basehangul.decode('꺽먹께겔꼍뮷듕빕')
        expect(decoded).to eq('12345678f')
        decoded = basehangul.decode('꺽먹께겔꼍뮷듕빗')
        expect(decoded).to eq('12345678g')
      end
    end

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
  end
end
