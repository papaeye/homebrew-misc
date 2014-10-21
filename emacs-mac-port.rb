require "formula"

class EmacsMacPort < Formula
  homepage "https://www.gnu.org/software/emacs/"
  url "http://ftpmirror.gnu.org/emacs/emacs-24.4.tar.xz"
  mirror "https://ftp.gnu.org/pub/gnu/emacs/emacs-24.4.tar.xz"
  sha256 "47e391170db4ca0a3c724530c7050655f6d573a711956b4cd84693c194a9d4fd"

  resource "mac-port" do
    url "ftp://ftp.math.s.chiba-u.ac.jp/emacs/emacs-24.4-mac-5.0.tar.gz"
    sha256 "fb3740cc9c419883741054300dc87c83c2cd80ece23e4899166081fd2b9f3792"
  end

  resource "hires-icons" do
    url "ftp://ftp.math.s.chiba-u.ac.jp/emacs/emacs-hires-icons-1.0.tar.gz"
    sha256 "111c2f437bbed002480bad76c838caf86fe408da65137ec8ffc8ad1f45560b94"
  end

  patch do
    # http://papaeye.tumblr.com/post/27256875523/emacs-mac-port
    url "https://gist.githubusercontent.com/papaeye/5187551/raw/eb1752c06e5820c673b2925cb2f940f7f7851f52/tweak-font-height.patch"
    sha256 '8786bdc88127a85efe8d50ea6a0be1e1207b2fa7006b70c31e784ad2b3a7dfd6'
  end

  def install
    resource("mac-port").stage do
      system "/usr/bin/patch", "-p0", "-d", buildpath, "-i", Pathname.pwd/"patch-mac"

      mv "mac", buildpath
      mv buildpath/"nextstep/Cocoa/Emacs.base/Contents/Resources/Emacs.icns",
         buildpath/"mac/Emacs.app/Contents/Resources/Emacs.icns"
      mv Dir["src/*"], buildpath/"src"
      mv "lisp/term/mac-win.el", buildpath/"lisp/term"
    end

    resource("hires-icons").stage do
      mv Dir["etc/images/*"], buildpath/"etc/images"
    end

    ENV["CC"] = "clang -fobjc-arc"

    args = [
      "--prefix=#{prefix}/Emacs.app/Contents/Resources",
      "--exec-prefix=#{prefix}/Emacs.app/Contents/MacOS",
      "--datarootdir=#{prefix}/Emacs.app/Contents/Resources",
      "--enable-locallisppath=#{prefix}/Emacs.app/Contents/Resources/site-lisp",
      "--with-mac",
      "--enable-mac-app=#{prefix}"
    ]
    system "./configure", *args
    system "make"
    system "make install"

    rm prefix/"Emacs.app/Contents/MacOS/bin/emacs"
    rm prefix/"Emacs.app/Contents/MacOS/bin/emacs-#{version}"

    mv Dir[prefix/"Emacs.app/Contents/Resources/emacs/#{version}/*"],
       prefix/"Emacs.app/Contents/Resources"
    rm_rf prefix/"Emacs.app/Contents/Resources/emacs"

    rm_rf prefix/"Emacs.app/Contents/Resources/applications"
    rm_rf prefix/"Emacs.app/Contents/Resources/icons"
    rm_rf prefix/"Emacs.app/Contents/Resources/var"
  end
end
