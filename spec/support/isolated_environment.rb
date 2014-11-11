# encoding: utf-8

require 'tmpdir'

RSpec.shared_context 'isolated environment' do
  around do |example|
    Dir.mktmpdir do |tmpdir|
      tmpdir = File.realpath(tmpdir)
      Dir.chdir(tmpdir) do
        example.run
      end
    end
  end
end
