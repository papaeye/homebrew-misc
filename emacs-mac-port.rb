class EmacsMacPort < Formula
  homepage "https://www.gnu.org/software/emacs/"

  stable do
    url "http://ftpmirror.gnu.org/emacs/emacs-24.5.tar.xz"
    mirror "https://ftp.gnu.org/pub/gnu/emacs/emacs-24.5.tar.xz"
    sha256 "dd47d71dd2a526cf6b47cb49af793ec2e26af69a0951cc40e43ae290eacfc34e"
    version "24.5-mac-5.8"

    resource "mac-port" do
      url "ftp://ftp.math.s.chiba-u.ac.jp/emacs/emacs-24.5-mac-5.8.tar.gz"
      sha256 "3942a62479541ab93522cd7ba8f45860e366699aaf6ad7c589e8295a9eca5052"
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
      system "/usr/bin/patch", "-p1", "-d", buildpath, "-i", Pathname.pwd/"patch-mac"

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
