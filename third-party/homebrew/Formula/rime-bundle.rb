class RimeBundle < Formula
  desc "Rime's resource."
  homepage 'https://rime.im'
  url 'https://gist.github.com/curoky/2985fe6d1899b77fd611bde444a8289d/archive/master.zip'
  version '1.0.0'

  resource 'rime-emoji' do
    url 'https://github.com/rime/rime-emoji/archive/master.zip'
  end

  # meow-emoji
  resource 'meow-emoji-rime' do
    url 'https://github.com/hitigon/meow-emoji-rime/archive/master.zip'
  end

  resource 'rime-prelude' do
    url 'https://github.com/rime/rime-prelude/archive/master.zip'
  end

  resource 'rime-symbols' do
    url 'https://github.com/fkxxyz/rime-symbols/archive/master.zip'
  end

  resource 'rime-cloverpinyin' do
    url 'https://github.com/fkxxyz/rime-cloverpinyin/releases/download/1.1.4/clover.schema-1.1.4.zip'
  end

  keg_only :versioned_formula

  depends_on 'python@3.9' => :build

  def install
    system 'pip3', 'install', 'opencc'
    resource('rime-emoji').stage do
      (prefix / 'opencc').install Dir['opencc/*']
    end

    resource('rime-symbols').stage do
      system 'python3', './rime-symbols-gen'
      (prefix / 'opencc').install 'symbol.json'
      (prefix / 'opencc').install 'symbol_word.txt'
      (prefix / 'opencc').install 'symbol_category.txt'
    end

    resource('rime-cloverpinyin').stage do
      prefix.install 'clover.base.dict.yaml'
      prefix.install 'clover.dict.yaml'
      prefix.install 'clover.key_bindings.yaml'
      prefix.install 'clover.phrase.dict.yaml'
      prefix.install 'clover.schema.yaml'
    end

    prefix.install 'curoky.dict.yaml'
  end

  test do
    ohai 'Test complete.'
  end
end
