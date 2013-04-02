require 'formula'

class Emacs < Formula
  homepage 'http://www.gnu.org/software/emacs/'
  url 'http://ftpmirror.gnu.org/emacs/emacs-24.3.tar.gz'
  mirror 'http://ftp.gnu.org/pub/gnu/emacs/emacs-24.3.tar.gz'
  sha256 '0098ca3204813d69cd8412045ba33e8701fa2062f4bff56bedafc064979eef41'

  depends_on :autoconf
  depends_on :automake

  # Make Mac port self-contained
  def patches
    [
     'https://gist.github.com/papaeye/5187924/raw/d07175f714cc0e5182ed5478bdb0c92ecbb558c6/mac-self-contained.patch'
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
  url 'ftp://ftp.math.s.chiba-u.ac.jp/emacs/emacs-24.3-mac-4.0.tar.gz'
  sha1 'a53689d67dd6a1a1d997cb177a0371f89b6757d9'

  # http://papaeye.tumblr.com/post/27256875523/emacs-mac-port
  def patches
    [
     'https://gist.github.com/papaeye/5187551/raw/f221674ab0be67f611e49b8f871e066db94d008b/tweak-font-height.patch'
    ]
  end
end
