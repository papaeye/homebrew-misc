require "formula"

class MewBin < Formula
  homepage "http://mew.org/"
  url "http://mew.org/Release/mew-6.6.tar.gz"
  sha1 "3ba1bac6ed9a7a6a85d61b5946418914912063f3"
  head "https://github.com/kazu-yamamoto/Mew.git"

  def install
    system "./configure --prefix=#{prefix}"
    system "make bin"
    system "make install-bin"
  end
end
