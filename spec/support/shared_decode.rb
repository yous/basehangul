# encoding: utf-8

RSpec.shared_examples 'a decoder' do |method|
  subject(:decode) { described_class.method(method) }

  describe ".#{method}" do
    it 'returns empty binary with empty string' do
      decoded = decode.call('')
      expect(decoded).to eq('')
    end

    context 'when there is no padding characters' do
      it 'decodes hangul to binary' do
        decoded = decode.call('넥라똔먈늴멥갯놓궂뗐밸뮤뉴뗐뀄굡덜멂똑뚤')
        expect(decoded).to eq('This is an encoded string')
        decoded = decode.call('꺽먹꼍녜')
        expect(decoded).to eq('123ab')
        decoded = decode.call('꺽먹꼐가')
        expect(decoded).to eq("123d\x00")
        decoded = decode.call('꺽먹께겔꼍뮷뒝낮')
        expect(decoded).to eq('1234567890')
        decoded = decode.call('꺽먹께겔꼍뮷듕가')
        expect(decoded).to eq("12345678d\x00")
      end
    end

    context 'when there are padding characters' do
      it 'decodes hangul to binary' do
        decoded = decode.call('꺽흐흐흐')
        expect(decoded).to eq('1')
        decoded = decode.call('꺽먈흐흐')
        expect(decoded).to eq('12')
        decoded = decode.call('꺽먹꺄흐')
        expect(decoded).to eq('123')
        decoded = decode.call('꺽먹께겔꼍흐흐흐')
        expect(decoded).to eq('123456')
        decoded = decode.call('꺽먹께겔꼍뮨흐흐')
        expect(decoded).to eq('1234567')
        decoded = decode.call('꺽먹께겔꼍뮷됩흐')
        expect(decoded).to eq('12345678')
      end
    end

    context 'when there are special characters' do
      it 'decodes hangul to binary 'do
        decoded = decode.call('꺽먹꼐빎')
        expect(decoded).to eq('123d')
        decoded = decode.call('꺽먹꼐빔')
        expect(decoded).to eq('123e')
        decoded = decode.call('꺽먹꼐빕')
        expect(decoded).to eq('123f')
        decoded = decode.call('꺽먹꼐빗')
        expect(decoded).to eq('123g')
        decoded = decode.call('꺽먹께겔꼍뮷듕빎')
        expect(decoded).to eq('12345678d')
        decoded = decode.call('꺽먹께겔꼍뮷듕빔')
        expect(decoded).to eq('12345678e')
        decoded = decode.call('꺽먹께겔꼍뮷듕빕')
        expect(decoded).to eq('12345678f')
        decoded = decode.call('꺽먹께겔꼍뮷듕빗')
        expect(decoded).to eq('12345678g')
      end
    end
  end
end
