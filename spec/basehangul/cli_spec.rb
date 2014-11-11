# encoding: utf-8

RSpec.describe BaseHangul::CLI do
  include FileHelper
  include_context 'isolated environment'

  subject(:cli) { described_class.new }

  before(:example) { $stdout = StringIO.new }
  after(:example) { $stdout = STDOUT }

  it 'encodes text file passed as an argument' do
    create_file('binary.txt',
                'ABCDE' \
                '12345' \
                '가나다라마' \
                "\u3000")
    expect(cli.run(['binary.txt'])).to be(0)
    expect($stdout.string)
      .to eq("꿸거껫경꺽먹께겔법많겡밌뙨렷륑꽥뜰봤륑밖밞갑가흐\n")
  end

  it 'encodes string passed as an stdin argument' do
    allow($stdin).to receive(:read).once
      .and_return('ABCDE' \
                  '12345' \
                  '가나다라마' \
                  "\u3000")
    expect(cli.run([])).to be(0)
    expect($stdout.string)
      .to eq("꿸거껫경꺽먹께겔법많겡밌뙨렷륑꽥뜰봤륑밖밞갑가흐\n")
  end

  describe '-D/--decode' do
    it 'decodes text file passed as an argument' do
      create_file('basehangul.txt',
                  ['꿸거껫경꺽먹께겔법많겡밌뙨렷륑꽥뜰봤륑밖밞갑가흐'])
      expect(cli.run(['--decode', 'basehangul.txt'])).to be(0)
      expect($stdout.string).to eq('ABCDE' \
                                   '12345' \
                                   '가나다라마' \
                                   "\u3000\n")
    end

    it 'decodes string passed as an stdin argument' do
      allow($stdin).to receive(:read).once
        .and_return('꿸거껫경꺽먹께겔법많겡밌뙨렷륑꽥뜰봤륑밖밞갑가흐')
      expect(cli.run(['--decode'])).to be(0)
      expect($stdout.string) .to eq('ABCDE' \
                                    '12345' \
                                    '가나다라마' \
                                    "\u3000\n")
    end
  end
end
