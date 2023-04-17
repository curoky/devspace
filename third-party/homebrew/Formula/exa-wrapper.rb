class ExaWrapper < Formula
  desc 'Wrapper script for exa to give it nearly identical switches and appearance to ls.'
  homepage 'https://gist.github.com/curoky/47dcc36c748c668c4252752ab2ae95a7'
  url 'https://gist.github.com/curoky/47dcc36c748c668c4252752ab2ae95a7/archive/master.tar.gz'
  version 'head'

  def install
    bin.install 'exa-wrapper.sh' => 'ls'
  end

  test do
    ohai 'Test complete.'
  end
end
