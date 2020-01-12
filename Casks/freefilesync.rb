cask 'freefilesync' do
  version '11.14'

  name 'FreeFileSync'
  url "https://freefilesync.org/download/FreeFileSync_#{version}_macOS.zip"
  homepage 'https://www.freefilesync.org/'

  pkg "FreeFileSync_#{version}.pkg"

  uninstall pkgutil: [
    'org.freefilesync.pkg.FreeFileSync',
    'org.freefilesync.pkg.RealTimeSync'
  ]
end
