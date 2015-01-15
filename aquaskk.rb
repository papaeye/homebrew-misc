require 'formula'

class Aquaskk < Formula
  homepage 'http://aquaskk.sourceforge.jp/'
  head 'https://github.com/codefirst/aquaskk.git'

  option 'with-sticky-shift', 'Build with sticky-shift support'

  if build.with? 'sticky-shift'
    patch do
      url 'https://gist.github.com/papaeye/8368908/raw/6053615ae23736baaf24a566d837d9cf5b7bdd79/aquaskk-sticky-key.patch'
      sha1 '5dfa557527d650ff8ac1aa99668ae0cc69e07eec'
    end
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
