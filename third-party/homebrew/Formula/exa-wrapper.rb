class ExaWrapper < Formula
  desc 'Wrapper script for exa to give it nearly identical switches and appearance to ls.'
  homepage 'https://gist.github.com/eggbean/74db77c4f6404dd1f975bd6f048b86f8'
  url 'https://gist.github.com/eggbean/74db77c4f6404dd1f975bd6f048b86f8/archive/master.tar.gz'
  version 'head'

  def install
    # TODO: remove this line. https://gist.github.com/eggbean/74db77c4f6404dd1f975bd6f048b86f8?permalink_comment_id=4442136#gistcomment-4442136
    inreplace 'exa-wrapper.sh', 'meb == 0', 'meb == 1'
    bin.install 'exa-wrapper.sh' => 'ls'
  end

  test do
    ohai 'Test complete.'
  end
end
