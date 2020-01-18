require 'os/linux/glibc'

class Libiberty < Formula
  desc 'The libiberty library is a collection of subroutines used by various GNU programs.'
  homepage 'https://gcc.gnu.org/onlinedocs/libiberty'
  url 'https://ftp.gnu.org/gnu/gcc/gcc-11.1.0/gcc-11.2.1.tar.xz'
  mirror 'https://ftpmirror.gnu.org/gcc/gcc-11.1.0/gcc-11.1.0.tar.xz'
  license 'GPL-3.0'

  keg_only :versioned_formula

  bottle do
    root_url 'https://github.com/curoky/homebrew-tap/releases/download/bottles'
    sha256 x86_64_linux: '5be48192ec61fbb1c6972a403d19c757b1b35a909bff2468bc434d994805d383'
  end

  depends_on 'gcc@11'

  def install
    ENV['CC'] = Formula['gcc@11'].opt_bin / 'gcc-11'
    ENV['CXX'] = Formula['gcc@11'].opt_bin / 'g++-11'

    args = %W[
      --prefix=#{prefix}
      --enable-install-libiberty
    ]

    mkdir 'build' do
      ENV.append_to_cflags '-fPIC'
      system '../libiberty/configure', *args
      system 'make'
      system 'make', 'install'
    end
  end

  test do
    ohai 'Test complete.'
  end
end
