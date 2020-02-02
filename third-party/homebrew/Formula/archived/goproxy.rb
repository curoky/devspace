class Goproxy < Formula
  desc 'A global proxy for Go modules.'
  homepage 'https://github.com/goproxyio/goproxy'
  url 'https://github.com/goproxyio/goproxy/archive/v2.0.7.tar.gz'
  sha256 'd87f3928467520f8d6b0ba8adcbf5957dc6eb2dc9936249edd6568ceb01a71ca'
  license 'MIT'
  head 'https://github.com/goproxyio/goproxy.git'

  bottle do
    root_url 'https://github.com/curoky/homebrew-tap/releases/download/bottles'
    sha256 x86_64_linux: '8ed76c7edf0100a067214391d68fa364f76613347e1a8347b1f9beddc60e3819'
  end

  depends_on 'go' => :build

  def install
    system 'go', 'build', *std_go_args, '-ldflags', '-s -w', '.'
  end

  test do
  end
end
