require 'formula'

class Aquaskk < Formula
  homepage 'http://aquaskk.sourceforge.jp/'
  head 'svn+http://svn.sourceforge.jp/svnroot/aquaskk/aquaskk/trunk'

  # 64bit build + 10.8 SDK
  def patches
    DATA
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

__END__
diff --git a/platform/mac/proj/AquaSKK.xcodeproj/project.pbxproj b/platform/mac/proj/AquaSKK.xcodeproj/project.pbxproj
index 4b6c403..eec1bef 100644
--- a/platform/mac/proj/AquaSKK.xcodeproj/project.pbxproj
+++ b/platform/mac/proj/AquaSKK.xcodeproj/project.pbxproj
@@ -1076,14 +1076,14 @@
 				GCC_WARN_UNUSED_VARIABLE = YES;
 				MACOSX_DEPLOYMENT_TARGET = 10.7;
 				RUN_CLANG_STATIC_ANALYZER = YES;
-				SDKROOT = macosx;
+				SDKROOT = macosx10.8;
 			};
 			name = Debug;
 		};
 		C01FCF5008A954540054247B /* Release */ = {
 			isa = XCBuildConfiguration;
 			buildSettings = {
-				ARCHS = "$(ARCHS_STANDARD_32_64_BIT)";
+				ARCHS = "$(ARCHS_STANDARD_64_BIT)";
 				CLANG_WARN_CONSTANT_CONVERSION = YES;
 				CLANG_WARN_ENUM_CONVERSION = YES;
 				CLANG_WARN_INT_CONVERSION = YES;
@@ -1095,7 +1095,7 @@
 				GCC_WARN_UNUSED_VARIABLE = YES;
 				MACOSX_DEPLOYMENT_TARGET = 10.7;
 				RUN_CLANG_STATIC_ANALYZER = YES;
-				SDKROOT = macosx;
+				SDKROOT = macosx10.8;
 			};
 			name = Release;
 		};
@@ -1131,7 +1131,7 @@
 				);
 				PRODUCT_NAME = AquaSKK;
 				RUN_CLANG_STATIC_ANALYZER = YES;
-				SDKROOT = macosx10.7;
+				SDKROOT = macosx10.8;
 				WRAPPER_EXTENSION = app;
 				ZERO_LINK = YES;
 			};
@@ -1165,7 +1165,7 @@
 				);
 				PRODUCT_NAME = AquaSKK;
 				RUN_CLANG_STATIC_ANALYZER = YES;
-				SDKROOT = macosx10.7;
+				SDKROOT = macosx10.8;
 				WRAPPER_EXTENSION = app;
 				ZERO_LINK = NO;
 			};
@@ -1194,7 +1194,7 @@
 				);
 				PRODUCT_NAME = AquaSKKPreferences;
 				RUN_CLANG_STATIC_ANALYZER = YES;
-				SDKROOT = macosx10.7;
+				SDKROOT = macosx10.8;
 				WRAPPER_EXTENSION = app;
 			};
 			name = Debug;
@@ -1221,7 +1221,7 @@
 				);
 				PRODUCT_NAME = AquaSKKPreferences;
 				RUN_CLANG_STATIC_ANALYZER = YES;
-				SDKROOT = macosx10.7;
+				SDKROOT = macosx10.8;
 				WRAPPER_EXTENSION = app;
 			};
 			name = Release;
