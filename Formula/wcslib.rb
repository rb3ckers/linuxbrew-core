class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-7.3.tar.bz2"
  sha256 "4b01cf425382a26ca4f955ed6841a5f50c55952a2994367f8e067e4183992961"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c733b73fe01c146992c2fa05865c631907c61cbc26e5c66980471441c5c7910f"
    sha256 cellar: :any, big_sur:       "14760499e809a0b5878d03b2f22f15975906fea80bb63b173a35c67645c3654a"
    sha256 cellar: :any, catalina:      "a0e15ea5ee23106c24960feed0c7dad6762d8e75cb9d42445c197fb38f079965"
    sha256 cellar: :any, mojave:        "d8b3561a7e87031d7d6f8042af1c75f21663874921da17d5061d3ffe558263f1"
    sha256 cellar: :any, high_sierra:   "941ce001ceb21e53dc6af78e8e09ebc52a24b57efcd51c009f8416789674f8ee"
    sha256 cellar: :any, x86_64_linux:  "a398ac370732838e136277a93392ba7a30960121c6dd2bec2ca97a27a6171eef"
  end

  depends_on "cfitsio"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-cfitsiolib=#{Formula["cfitsio"].opt_lib}",
                          "--with-cfitsioinc=#{Formula["cfitsio"].opt_include}",
                          "--without-pgplot",
                          "--disable-fortran"
    system "make", "install"
  end

  test do
    piped = "SIMPLE  =" + " "*20 + "T / comment" + " "*40 + "END" + " "*2797
    pipe_output("#{bin}/fitshdr", piped, 0)
  end
end
