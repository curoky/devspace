class Iputils < Formula
  desc 'The iputils package is set of small useful utilities for Linux networking.'
  homepage 'https://github.com/iputils/iputils'
  # NOTE: skip version 20210722, because it cannot skip test.
  url 'https://github.com/iputils/iputils/archive/refs/tags/20210202.tar.gz'
  sha256 '3f557ecfd2ace873801231d2c1f42de73ced9fbc1ef3a438d847688b5fb0e8ab'

  bottle do
    root_url 'https://github.com/curoky/homebrew-tap/releases/download/bottles'
    sha256 x86_64_linux: '78640d4935e46cff27f07f6659f1b693821292c0ccd8a669a74ee024b5d9fe1e'
  end

  depends_on :linux
  depends_on 'meson' => :build
  depends_on 'ninja' => :build
  depends_on 'libcap'

  def install
    ENV.prepend_path 'PATH', Formula['libcap'].sbin

    args = %w[
      -DBUILD_MANS=false
      -DUSE_CAP=false
    ]
    mkdir 'build' do
      system 'meson', *std_meson_args, *args, '..'
      system 'ninja'
      system 'ninja', 'install'
    end
  end

  test do
    output = shell_output("#{bin}/ping -V").strip
    assert_match '20210202', output
  end
end
