class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.4/libupnp-1.14.4.tar.bz2"
  sha256 "cd649ef53070e9b88680f730ed5b3f919658582d43dd315a2ed8b6105c6fbe63"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "442183f8a3b818a78bdf61f7c8f570428222c9e29cb1c05d558995d3b6a5f2f5"
    sha256 cellar: :any,                 big_sur:       "03342b7244d40c4c29cbee728188da749b54973b4341d5cc65e152ad28b3f7b3"
    sha256 cellar: :any,                 catalina:      "22be8335b2cae7ea2400aedc18e8de3e97546b8fc0a6a5ce9bb3525a0edbf081"
    sha256 cellar: :any,                 mojave:        "976d36ef89fa0f5dd45a3804841d9434a0c385aa642a8b2142f116f65c8d8a5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bd59b06b4c0749756dec9a798b5d6cddd142322a981c1a41e53e5e11f2e2f83"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ipv6
    ]

    system "./configure", *args
    system "make", "install"
  end
end
