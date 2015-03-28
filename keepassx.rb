class Keepassx < Formula
  homepage "http://www.keepassx.org/"
  head "https://github.com/keepassx/keepassx.git"

  stable do
    url "https://downloads.sourceforge.net/project/keepassx/KeePassX/0.4.3/keepassx-0.4.3.tar.gz"
    sha1 "d25ecc9d3caaa5a6d0f39a42c730a95997f37e2e"

	  # Avoid "error: use of undeclared identifier 'getpid'" on OS X 10.9.
    patch :DATA
  end

  devel do
    url "https://github.com/keepassx/keepassx/archive/2.0-alpha6.tar.gz"
    sha256 "592f9995b13c4f84724fb24a0078162246397eedccd467daaf0fd3608151f2b0"
    version "2.0-alpha6"
  end

  depends_on "cmake" => :build unless build.stable?
  depends_on "qt"
  depends_on "libgcrypt"

  def install
    if build.stable?
      system "qmake PREFIX=#{prefix}"
      system "make"
      system "make install"
    else
      system "cmake . -DCMAKE_INSTALL_PREFIX=#{prefix}"
      system "make install"
    end
  end
end

__END__
diff --git a/src/lib/random.cpp b/src/lib/random.cpp
index 1007172..9c73a47 100644
--- a/src/lib/random.cpp
+++ b/src/lib/random.cpp
@@ -22,6 +22,7 @@
 
 
 #if defined(Q_WS_X11) || defined(Q_WS_MAC)
+	#include <unistd.h>
 	#include <QFile>
 #elif defined(Q_WS_WIN)
 	#include <windows.h>
