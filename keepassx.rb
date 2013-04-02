require 'formula'

class Keepassx < Formula
  homepage 'http://www.keepassx.org/'
  url 'http://downloads.sourceforge.net/keepassx/keepassx-0.4.3.tar.gz'
  sha1 'd25ecc9d3caaa5a6d0f39a42c730a95997f37e2e'

  depends_on 'qt4'

  def install
    system "qmake PREFIX=#{prefix}"
    system "make"
    system "make install"
  end

  def caveats
    <<-EOS.undent
      KeePassX.app was installed in:
        #{prefix}
    EOS
  end
end
