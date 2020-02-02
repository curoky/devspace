class Dstat < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc 'Versatile resource statistics tool (the real one, not the Red Hat clone)'
  homepage 'https://github.com/dstat-real/dstat'
  # dstat's fork: https://github.com/scottchiefbaker/dool
  url 'https://github.com/dstat-real/dstat/archive/refs/tags/v0.7.4.tar.gz'
  sha256 '4fbd58f3461c86d09a3ab97472aa204de37aa33d31a0493a3e5ed86a2045abea'
  license 'GPL-2.0'

  depends_on 'python@3.9'

  def install
    virtualenv_create(libexec, 'python3.9')
    system libexec / 'bin/pip', 'install', 'six'
    rewrite_shebang python_shebang_rewrite_info("#{libexec}/bin/python3"), 'dstat'

    # NOTE: add pkgshare to dstat plugin path
    inreplace 'dstat', '/usr/share/dstat/', pkgshare.to_s

    cp 'dstat', 'dstat.py'
    bin.install 'dstat'
    man1.install 'docs/dstat.1'
    pkgshare.install Dir['plugins/*.py']
    pkgshare.install 'dstat.py'
  end

  test do
    output = shell_output("#{bin}/dstat --version").strip
    assert_match '0.8.0', output
  end
end
