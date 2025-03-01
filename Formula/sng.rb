class Sng < Formula
  desc "Enable lossless editing of PNGs via a textual representation"
  homepage "https://sng.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sng/sng-1.1.0.tar.gz"
  sha256 "119c55870c1d1bdc65f7de9dbc62929ccb0c301c2fb79f77df63f5d477f34619"
  license "Zlib"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "441c39690c079231af81a27fce72a0f0ea7cf982c9e48e320160ccc7304486a0"
    sha256 big_sur:       "f0e4ce732890622d796d3ab7d5c2d078f9ad327e5d64bdf9d7625b15d7a38281"
    sha256 catalina:      "070137e810c2ea02cdb3727ef7fc0da31065762ed6fee972a33d8690fc43e051"
    sha256 mojave:        "de4c08894b82e37ff3fc07fd0ade38ede24bcf241757f0b6392ab2f4a5f87d67"
    sha256 x86_64_linux:  "0ce9666cfd5eea30852cfab6733bc7b4c5dd8b03d3beedc729e62acccb0813a6"
  end

  depends_on "libpng"
  depends_on "xorgrgb"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-rgbtxt=#{Formula["xorgrgb"].share}/X11/rgb.txt"
    system "make", "install"
  end

  test do
    cp test_fixtures("test.png"), "test.png"
    system bin/"sng", "test.png"
    assert_include File.read("test.sng"), "width: 8; height: 8; bitdepth: 8;"
  end
end
