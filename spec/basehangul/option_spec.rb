# encoding: utf-8

RSpec.describe BaseHangul::Option do
  include ExitCodeMatchers

  subject(:option) { described_class.new }

  before(:example) { $stdout = StringIO.new }
  after(:example) { $stdout = STDOUT }

  describe 'option' do
    describe '-h/--help' do
      it 'exits cleanly' do
        expect { option.parse(['-h']) }.to exit_with_code(0)
        expect { option.parse(['--help']) }.to exit_with_code(0)
      end

      it 'shows help text' do
        begin
          option.parse(['--help'])
        rescue SystemExit # rubocop:disable Lint/HandleExceptions
        end

        expected_help = <<-END
Usage: basehangul [options] [source]
    -D, --decode                     Decode the input.
    -h, --help                       Print this message.
    -v, --version                    Print version.
        END

        expect($stdout.string).to eq(expected_help)
      end
    end

    describe '-v/--version' do
      it 'exits cleanly' do
        expect { option.parse(['-v']) }.to exit_with_code(0)
        expect { option.parse(['--version']) }.to exit_with_code(0)
        expect($stdout.string).to eq("#{BaseHangul::Version::STRING}\n" * 2)
      end
    end
  end
end
