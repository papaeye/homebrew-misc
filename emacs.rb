require 'formula'

class Emacs < Formula
  homepage 'http://www.gnu.org/software/emacs/'
  url 'http://ftpmirror.gnu.org/emacs/emacs-24.3.tar.gz'
  mirror 'http://ftp.gnu.org/pub/gnu/emacs/emacs-24.3.tar.gz'
  sha256 '0098ca3204813d69cd8412045ba33e8701fa2062f4bff56bedafc064979eef41'

  depends_on :autoconf
  depends_on :automake

  def patches
    [
     # Make Mac port self-contained
     'https://gist.github.com/papaeye/5187924/raw/d07175f714cc0e5182ed5478bdb0c92ecbb558c6/mac-self-contained.patch',
     # http://debbugs.gnu.org/cgi/bugreport.cgi?bug=14156
     'https://gist.github.com/papaeye/5693703/raw/10a05fb40180f47107e16e14a7835acd7e890fb9/bug14156-emacs24.3.patch'
    ]
  end

  def install
    patch_mac_port

    ENV['CC'] = 'clang -fobjc-arc'
    ENV['LANG'] = 'C'

    # from configure.in
    appbindir = prefix+'Emacs.app/Contents/MacOS'
    appresdir = prefix+'Emacs.app/Contents/Resources'
    args = ["--without-dbus",
            "--with-mac",
            "--enable-locallisppath=#{appresdir+'sitelisp'}",
            "--enable-mac-app=#{prefix}"]
    system "./configure", *args
    system "make bootstrap"
    system "make install"

    # from Makefile.in
    unless (appresdir+'site-lisp/subdirs.el').file?
      mkdir_p appresdir+'site-lisp'
      (appresdir+'site-lisp/subdirs.el').write <<-EOS.undent
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))
      EOS
    end
    rm_f Dir[appbindir+'bin/{emacs,emacs-*}']
    rm_rf appresdir+'share'
  end

  def patch_mac_port
    pwd = Pathname.pwd

    EmacsMacPortPatch.new.brew do
      safe_system '/usr/bin/patch', '-p0', '-d', pwd, '-i', Pathname.pwd+'patch-mac'

      mv 'mac', pwd
      mv pwd+'nextstep/Cocoa/Emacs.base/Contents/Resources/Emacs.icns',
         pwd+'mac/Emacs.app/Contents/Resources/Emacs.icns'
      mv Dir['etc/images/*'], pwd+'etc/images'
      mv Dir['src/*'], pwd+'src'
      mv 'lisp/term/mac-win.el', pwd+'lisp/term'
    end
  end
end

class EmacsMacPortPatch < Formula
  url 'ftp://ftp.math.s.chiba-u.ac.jp/emacs/emacs-24.3-mac-4.8.tar.gz'
  sha1 '0fe243f9ca60ead00b692026a26813d6713d1473'

  # http://papaeye.tumblr.com/post/27256875523/emacs-mac-port
  def patches
    [
     'https://gist.github.com/papaeye/5187551/raw/7995bb89324089843b3b80cf79a766f5973c7e95/tweak-font-height.patch'
    ]
  end
end
