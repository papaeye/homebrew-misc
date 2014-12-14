require 'formula'

class Cmigemo < Formula
  homepage 'http://www.kaoriya.net/software/cmigemo'
  head 'https://github.com/koron/cmigemo.git'

  # Revert koron/cmigemo@e5aeae17daa16f0e2b8dc200ee8093c2bc7a89fe
  patch :DATA

  depends_on 'nkf' => :build

  def install
    system "chmod +x ./configure"
    system "./configure", "--prefix=#{prefix}"
    system "make osx"
    system "make osx-dict"
    ENV.j1 # Install can fail on multi-core machines unless serialized
    system "make osx-install"
  end

  def caveats; <<-EOS.undent
    See also https://github.com/emacs-jp/migemo to use cmigemo with Emacs.
    You will have to save as migemo.el and put it in your load-path.
    EOS
  end
end

__END__
diff --git a/src/main.c b/src/main.c
index e0ef1ba..4abb344 100644
--- a/src/main.c
+++ b/src/main.c
@@ -178,7 +178,7 @@ main(int argc, char** argv)
 	    migemo_set_operator(pmigemo, MIGEMO_OPINDEX_NEST_IN, "\\(");
 	    migemo_set_operator(pmigemo, MIGEMO_OPINDEX_NEST_OUT, "\\)");
 	    if (!mode_nonewline)
-		migemo_set_operator(pmigemo, MIGEMO_OPINDEX_NEWLINE, "[[:space:]\r\n]*");
+		migemo_set_operator(pmigemo, MIGEMO_OPINDEX_NEWLINE, "\\s-*");
 	}
 #ifndef _PROFILE
 	if (word)
	Modified   src/rxgen.c
diff --git a/src/rxgen.c b/src/rxgen.c
index afe2b3d..27bde73 100644
--- a/src/rxgen.c
+++ b/src/rxgen.c
@@ -22,7 +22,7 @@
 #define RXGEN_ENC_SJISTINY
 //#define RXGEN_OP_VIM
 
-#define RXGEN_OP_MAXLEN 16
+#define RXGEN_OP_MAXLEN 8
 #define RXGEN_OP_OR "|"
 #define RXGEN_OP_NEST_IN "("
 #define RXGEN_OP_NEST_OUT ")"
