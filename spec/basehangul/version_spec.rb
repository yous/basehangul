# encoding: utf-8

RSpec.describe BaseHangul::Version do
  subject(:version) { described_class }

  describe '::STRING' do
    it { expect(defined? version::STRING).to eql('constant') }
  end
end
