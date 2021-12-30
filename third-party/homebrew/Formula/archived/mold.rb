class Mold < Formula
  desc 'mold: A Modern Linker'
  homepage 'https://github.com/rui314/mold'
  url 'https://github.com/rui314/mold/archive/refs/tags/v1.0.0.tar.gz'
  sha256 'd7cf170b57a3767d944c80c7468215fa9f8fa176f94f411a5b62b3f56cf07400'
  license 'GNU-AGPL'

  depends_on 'gcc@11' => :build
  depends_on 'mimalloc' => :build
  depends_on 'tbb' => :build
  depends_on 'xxhash' => :build
  depends_on 'openssl@1.1' => :build
  depends_on 'zlib' => :build

  def install
    ENV['CC'] = Formula['gcc@11'].opt_bin / 'gcc-11'
    ENV['CXX'] = Formula['gcc@11'].opt_bin / 'g++-11'

    deps = Array['openssl@1.1', 'xxhash', 'zlib', 'mimalloc', 'tbb']
    ENV.prepend 'LDFLAGS', deps.map { |d| "-L#{Formula[d.to_s].opt_lib}" }.join(' ')
    ENV.prepend 'CPPFLAGS', deps.map { |d| "-I#{Formula[d.to_s].opt_include}" }.join(' ')

    ENV['SYSTEM_TBB'] = '1'
    ENV['SYSTEM_MIMALLOC'] = '1'
    ENV['SYSTEM_XXHASH'] = '1'
    system 'make', "PREFIX=#{prefix}"
    system 'make', 'install', "PREFIX=#{prefix}"
  end

  test do
  end
end
