class Iproute2 < Formula
  desc 'Linux routing utilities'
  homepage 'https://github.com/shemminger/iproute2'
  url 'https://github.com/shemminger/iproute2/archive/refs/tags/v5.11.0.tar.gz'
  sha256 '16b79e6ce65d4d5fd425cef2fd92a58c403a93faeeed0e0a3202b36a8e857d1f'

  bottle do
    root_url 'https://github.com/curoky/homebrew-tap/releases/download/bottles'
    sha256 x86_64_linux: '04c59b68a347d4e3c63c3227704275ea781214a90d80d39f73bd283491f76cdb'
  end

  depends_on 'bison' => :build
  depends_on 'flex' => :build

  def install
    system 'make', 'install',
           "PREFIX=#{prefix}",
           "SBINDIR=#{sbin}",
           "CONFDIR=#{etc}/iproute2",
           "NETNS_RUN_DIR=#{var}/run/netns",
           "NETNS_ETC_DIR=#{etc}/netns",
           "ARPDDIR=#{var}/lib/arpd",
           "KERNEL_INCLUDE=#{include}",
           "DBM_INCLUDE=#{include}"
  end

  test do
    output = shell_output("#{sbin}/ip -V").strip
    assert_match '5.11.0', output
  end
end
