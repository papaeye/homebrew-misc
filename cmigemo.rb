require 'formula'

class Cmigemo < Formula
  homepage "http://www.kaoriya.net/software/cmigemo"
  head "https://github.com/papaeye/cmigemo.git", :branch => "spike/add-op-regexmeta"

  depends_on 'nkf' => :build

  def install
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
