require 'formula'

class Aquaskk < Formula
  homepage 'http://aquaskk.sourceforge.jp/'
  head 'https://github.com/t-suwa/aquaskk.git'

  def patches
    [
      # 64bit build + Latest OS X SDK
      DATA,
      # sticky key support (https://gist.github.com/anyakichi/1242540)
      'https://gist.github.com/papaeye/8368908/raw/6053615ae23736baaf24a566d837d9cf5b7bdd79/aquaskk-sticky-key.patch'
    ]
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
index 4b6c403..b2137df 100644
--- a/platform/mac/proj/AquaSKK.xcodeproj/project.pbxproj
+++ b/platform/mac/proj/AquaSKK.xcodeproj/project.pbxproj
@@ -1074,7 +1074,7 @@
 				GCC_WARN_ABOUT_RETURN_TYPE = YES;
 				GCC_WARN_UNINITIALIZED_AUTOS = YES;
 				GCC_WARN_UNUSED_VARIABLE = YES;
-				MACOSX_DEPLOYMENT_TARGET = 10.7;
+				MACOSX_DEPLOYMENT_TARGET = 10.9;
 				RUN_CLANG_STATIC_ANALYZER = YES;
 				SDKROOT = macosx;
 			};
@@ -1083,7 +1083,7 @@
 		C01FCF5008A954540054247B /* Release */ = {
 			isa = XCBuildConfiguration;
 			buildSettings = {
-				ARCHS = "$(ARCHS_STANDARD_32_64_BIT)";
+				ARCHS = "$(ARCHS_STANDARD)";
 				CLANG_WARN_CONSTANT_CONVERSION = YES;
 				CLANG_WARN_ENUM_CONVERSION = YES;
 				CLANG_WARN_INT_CONVERSION = YES;
@@ -1093,7 +1093,7 @@
 				GCC_WARN_ABOUT_RETURN_TYPE = YES;
 				GCC_WARN_UNINITIALIZED_AUTOS = YES;
 				GCC_WARN_UNUSED_VARIABLE = YES;
-				MACOSX_DEPLOYMENT_TARGET = 10.7;
+				MACOSX_DEPLOYMENT_TARGET = 10.9;
 				RUN_CLANG_STATIC_ANALYZER = YES;
 				SDKROOT = macosx;
 			};
@@ -1131,7 +1131,7 @@
 				);
 				PRODUCT_NAME = AquaSKK;
 				RUN_CLANG_STATIC_ANALYZER = YES;
-				SDKROOT = macosx10.7;
+				SDKROOT = macosx;
 				WRAPPER_EXTENSION = app;
 				ZERO_LINK = YES;
 			};
@@ -1165,7 +1165,7 @@
 				);
 				PRODUCT_NAME = AquaSKK;
 				RUN_CLANG_STATIC_ANALYZER = YES;
-				SDKROOT = macosx10.7;
+				SDKROOT = macosx;
 				WRAPPER_EXTENSION = app;
 				ZERO_LINK = NO;
 			};
@@ -1194,7 +1194,7 @@
 				);
 				PRODUCT_NAME = AquaSKKPreferences;
 				RUN_CLANG_STATIC_ANALYZER = YES;
-				SDKROOT = macosx10.7;
+				SDKROOT = macosx;
 				WRAPPER_EXTENSION = app;
 			};
 			name = Debug;
@@ -1221,7 +1221,7 @@
 				);
 				PRODUCT_NAME = AquaSKKPreferences;
 				RUN_CLANG_STATIC_ANALYZER = YES;
-				SDKROOT = macosx10.7;
+				SDKROOT = macosx;
 				WRAPPER_EXTENSION = app;
 			};
 			name = Release;
