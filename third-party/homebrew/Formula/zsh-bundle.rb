class ZshBundle < Formula
  desc 'Bundle zsh plugins'
  homepage 'https://github.com/ohmyzsh/ohmyzsh'
  url 'https://github.com/ohmyzsh/ohmyzsh/archive/refs/heads/master.tar.gz'
  head 'https://github.com/ohmyzsh/ohmyzsh.git'
  version 'head'

  resource 'zsh-autosuggestions' do
    url 'https://github.com/zsh-users/zsh-autosuggestions/archive/refs/heads/master.tar.gz'
  end
  resource 'zsh-completions' do
    url 'https://github.com/zsh-users/zsh-completions/archive/refs/heads/master.tar.gz'
  end
  resource 'zsh-syntax-highlighting' do
    url 'https://github.com/zsh-users/zsh-syntax-highlighting/archive/refs/heads/master.tar.gz'
  end
  resource 'spaceship-prompt' do
    url 'https://github.com/denysdovhan/spaceship-prompt/archive/refs/heads/master.tar.gz'
  end
  resource 'conda-zsh-completion' do
    url 'https://github.com/esc/conda-zsh-completion/archive/refs/heads/master.tar.gz'
  end

  keg_only :versioned_formula

  def install
    prefix.install Dir['*']
    (prefix / 'custom/plugins/zsh-autosuggestions').install resource('zsh-autosuggestions')
    (prefix / 'custom/plugins/zsh-completions').install resource('zsh-completions')
    (prefix / 'custom/plugins/zsh-syntax-highlighting').install resource('zsh-syntax-highlighting')

    # (prefix / 'custom/themes/spaceship-prompt').install resource('spaceship-prompt')
    # (prefix / 'custom/plugins/conda-zsh-completion').install resource('conda-zsh-completion')
  end

  test do
    ohai 'Test complete.'
  end
end
