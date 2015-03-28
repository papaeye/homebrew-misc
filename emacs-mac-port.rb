class EmacsMacPort < Formula
  homepage "https://www.gnu.org/software/emacs/"

  stable do
    url "http://ftpmirror.gnu.org/emacs/emacs-24.4.tar.xz"
    mirror "https://ftp.gnu.org/pub/gnu/emacs/emacs-24.4.tar.xz"
    sha256 "47e391170db4ca0a3c724530c7050655f6d573a711956b4cd84693c194a9d4fd"

    resource "mac-port" do
      url "ftp://ftp.math.s.chiba-u.ac.jp/emacs/emacs-24.4-mac-5.3.tar.gz"
      sha1 "324dff20ddffdfc53a8b18c29fc1b386df4b6762"
    end
  end

  devel do
    url "ftp://alpha.gnu.org/gnu/emacs/pretest/emacs-24.5-rc1.tar.xz"
    sha256 "f5c15527cf7b470423633c189ab1210a9ddef0f824b422f17dc00ca1bd015104"
    version "24.5-rc1-mac-5.6"

    resource "mac-port" do
      url "ftp://ftp.math.s.chiba-u.ac.jp/emacs/emacs-24.5-rc1-mac-5.6.tar.gz"
      sha256 "cdc6183bb15f91f76902d2923f095a37a72aade180065f969cd21d771063dce8"
    end
  end

  option "with-ctags", "Don't remove the ctags executable that emacs provides"
  option "with-arc", "Enable ARC support"

  resource "hires-icons" do
    url "ftp://ftp.math.s.chiba-u.ac.jp/emacs/emacs-hires-icons-1.0.tar.gz"
    sha256 "111c2f437bbed002480bad76c838caf86fe408da65137ec8ffc8ad1f45560b94"
  end

  patch do
    # http://papaeye.tumblr.com/post/27256875523/emacs-mac-port
    url "https://gist.githubusercontent.com/papaeye/5187551/raw/a310175afbc7149d08b1505e5c4f2f87c6ca7fe6/tweak-font-height.patch"
    sha256 '07af7d1946b8ee4a693288a1abc3cf8e7076f3341595c3c9b14d130e7f29d29b'
  end

  def install
    resource("mac-port").stage do
      system "/usr/bin/patch",
             build.devel? ? "-p1" : "-p0",
             "-d", buildpath, "-i", Pathname.pwd/"patch-mac"

      mv "mac", buildpath
      mv buildpath/"nextstep/Cocoa/Emacs.base/Contents/Resources/Emacs.icns",
         buildpath/"mac/Emacs.app/Contents/Resources/Emacs.icns"
      mv Dir["src/*"], buildpath/"src"
      mv "lisp/term/mac-win.el", buildpath/"lisp/term"
    end

    resource("hires-icons").stage do
      mv Dir["etc/images/*"], buildpath/"etc/images"
    end

    if build.with?("arc") && ENV.compiler == :clang
      ENV.append_to_cflags "-fobjc-arc"
    end

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

    # Follow MacPorts and don't install ctags from Emacs. This allows Vim
    # and Emacs and ctags to play together without violence.
    if build.without? "ctags"
      (prefix/"Emacs.app/Contents/MacOS/bin/ctags").unlink
      (prefix/"Emacs.app/Contents/Resources/man/man1/ctags.1.gz").unlink
    end

    emacs_version = version.to_s.split("-")[0]

    rm prefix/"Emacs.app/Contents/MacOS/bin/emacs"
    rm prefix/"Emacs.app/Contents/MacOS/bin/emacs-#{emacs_version}"

    mv Dir[prefix/"Emacs.app/Contents/Resources/emacs/#{emacs_version}/*"],
       prefix/"Emacs.app/Contents/Resources"
    rm_rf prefix/"Emacs.app/Contents/Resources/emacs"

    rm_rf prefix/"Emacs.app/Contents/Resources/applications"
    rm_rf prefix/"Emacs.app/Contents/Resources/icons"
    rm_rf prefix/"Emacs.app/Contents/Resources/var"

    (bin/"emacs").write <<-EOS.undent
      #!/bin/bash
      exec #{prefix}/Emacs.app/Contents/MacOS/Emacs -nw  "$@"
    EOS
  end
end
