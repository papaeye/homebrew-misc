require 'formula'

class Aquaskk < Formula
  homepage 'http://aquaskk.sourceforge.jp/'
  head 'https://github.com/codefirst/aquaskk.git'

  def patches
    [
      # sticky key support (https://gist.github.com/anyakichi/1242540)
      'https://gist.github.com/papaeye/8368908/raw/6053615ae23736baaf24a566d837d9cf5b7bdd79/aquaskk-sticky-key.patch'
    ]
  end

  def install
    cd 'platform/mac' do
      system 'xcodebuild -project proj/AquaSKK.xcodeproj -configuration Release build'
      prefix.install 'proj/build/Release/AquaSKK.app'
    end
  end

  def caveats
    <<-EOS.undent
      To finish installation
        `sudo ln -s #{prefix}/AquaSKK.app '/Library/Input Methods'`
    EOS
  end
end
