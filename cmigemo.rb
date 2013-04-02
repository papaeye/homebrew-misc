require 'formula'

class Cmigemo < Formula
  homepage 'http://www.kaoriya.net/software/cmigemo'
  url 'http://cmigemo.googlecode.com/files/cmigemo-default-src-20110227.zip'
  sha1 '25e279c56d3a8f1e82cbfb3526d1b38742d1d66c'

  depends_on 'nkf' => :build

  # Patch per discussion at: https://github.com/mxcl/homebrew/pull/7005
  def patches
    DATA
  end

  def install
    ENV.j1

    chmod 0755, 'configure'
    system "./configure", "--prefix=#{prefix}"
    system "make osx"
    system "make osx-dict"
    cd 'dict' do
      system "make utf-8"
    end
    system "make osx-install"
    system "install_name_tool -change libmigemo.1.dylib #{prefix}/lib/libmigemo.1.dylib #{prefix}/bin/cmigemo"
 end

  def caveats; <<-EOS.undent
    See also https://gist.github.com/457761 to use cmigemo with Emacs.
    You will have to save as migemo.el and put it in your load-path.
    EOS
  end
end

__END__
diff --git a/dict/dict.mak b/dict/dict.mak
index 49435d6..a5e6f1a 100644
--- a/dict/dict.mak
+++ b/dict/dict.mak
@@ -6,7 +6,7 @@
 
 DICT 		= migemo-dict
 DICT_BASE	= base-dict
-SKKDIC_BASEURL 	= http://openlab.ring.gr.jp/skk/dic
+SKKDIC_BASEURL 	= http://www.ring.gr.jp/archives/elisp/skk/dic
 SKKDIC_FILE	= SKK-JISYO.L
 EUCJP_DIR	= euc-jp.d
 UTF8_DIR	= utf-8.d
--- a/src/wordbuf.c	2011-08-15 02:57:05.000000000 +0900
+++ b/src/wordbuf.c	2011-08-15 02:57:17.000000000 +0900
@@ -9,6 +9,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <limits.h>
 #include "wordbuf.h"
 
 #define WORDLEN_DEF 64
