class RimeBundle < Formula
  include Language::Python::Virtualenv

  desc 'Bundle rime dict'
  homepage 'https://rime.im'
  url 'https://github.com/rime/squirrel/archive/refs/tags/0.15.2.tar.gz'
  # version '1.0.0'

  resource 'rime-emoji' do
    url 'https://github.com/rime/rime-emoji/archive/master.zip'
  end

  resource 'meow-emoji-rime' do
    url 'https://github.com/hitigon/meow-emoji-rime/archive/master.zip'
  end

  resource 'rime-prelude' do
    url 'https://github.com/rime/rime-prelude/archive/master.zip'
  end

  resource 'rime-symbols' do
    url 'https://github.com/fkxxyz/rime-symbols/archive/master.zip'
  end

  resource 'rime-dict' do
    url 'https://github.com/Iorest/rime-dict/archive/master.zip'
  end

  resource 'rime-cloverpinyin' do
    url 'https://github.com/fkxxyz/rime-cloverpinyin/releases/download/1.1.4/clover.schema-1.1.4.zip'
  end

  keg_only :versioned_formula

  depends_on 'python@3' => :build
  depends_on 'opencc' => :build

  def install
    venv = virtualenv_create(libexec, 'python3')
    venv.pip_install 'opencc'

    resource('rime-emoji').stage do
      (prefix / 'opencc').install Dir['opencc/*']
    end

    resource('rime-symbols').stage do
      system libexec / 'bin/python3', './rime-symbols-gen'
      (prefix / 'opencc').install 'symbol.json'
      (prefix / 'opencc').install 'symbol_word.txt'
      (prefix / 'opencc').install 'symbol_category.txt'
    end

    resource('rime-dict').stage do
      Pathname.glob('**/*.dict.yaml') do |file|
        system 'opencc', '-i', file, '-o', "s.#{file.basename}", '-c', 't2s.json'
        prefix.install Dir['s.*.yaml']
      end
    end

    resource('rime-cloverpinyin').stage do
      prefix.install Dir['*.yaml']
    end
  end

  test do
    ohai 'Test complete.'
  end
end
