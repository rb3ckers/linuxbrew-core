class Nss < Formula
  desc "Libraries for security-enabled client and server applications"
  homepage "https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS"
  url "https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_63_RTM/src/nss-3.63.tar.gz"
  sha256 "182d2fef629102ae9423aabf2c192242b565cf5098e82c5a26cf70c5e4ea2221"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/security/nss/releases/"
    regex(%r{href=.*?NSS[._-]v?(\d+(?:[._]\d+)+)[._-]RTM/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "a176c5a46787585bf7769b6e8f2e64db0c8c6c9d194c0da7ece7255af75f000d"
    sha256 cellar: :any,                 big_sur:       "6d9c2f02962dba7dca8aab0aedb5cc40d39fac41b6e4402e9d913e138196fe82"
    sha256 cellar: :any,                 catalina:      "fd4e758aca748b18bceb2401db165af15887560579c8b5c74173ed53a4e1b4be"
    sha256 cellar: :any,                 mojave:        "04afd26ad52d0871b1fa033f99459cea01697e9db9ece274dce9681d458857a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2fa0a57ad923480dfa18da19b1894e136458502dec0eee676e3391b727fc026"
  end

  depends_on "nspr"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  conflicts_with "resty", because: "both install `pp` binaries"
  conflicts_with "googletest", because: "both install `libgtest.a`"

  def install
    ENV.deparallelize
    cd "nss"

    args = %W[
      BUILD_OPT=1
      NSS_ALLOW_SSLKEYLOGFILE=1
      NSS_USE_SYSTEM_SQLITE=1
      NSPR_INCLUDE_DIR=#{Formula["nspr"].opt_include}/nspr
      NSPR_LIB_DIR=#{Formula["nspr"].opt_lib}
      USE_64=1
    ]

    # Remove the broken (for anyone but Firefox) install_name
    inreplace "coreconf/Darwin.mk", "-install_name @executable_path", "-install_name #{lib}"
    inreplace "lib/freebl/config.mk", "@executable_path", lib

    system "make", "all", *args

    # We need to use cp here because all files get cross-linked into the dist
    # hierarchy, and Homebrew's Pathname.install moves the symlink into the keg
    # rather than copying the referenced file.
    cd "../dist"
    bin.mkpath
    Dir.glob("*.OBJ/bin/*") do |file|
      cp file, bin unless file.include? ".dylib"
    end

    include_target = include + "nss"
    include_target.mkpath
    Dir.glob("public/{dbm,nss}/*") { |file| cp file, include_target }

    lib.mkpath
    libexec.mkpath
    Dir.glob("*.OBJ/lib/*") do |file|
      if file.include? ".chk"
        cp file, libexec
      else
        cp file, lib
      end
    end
    # resolves conflict with openssl, see #28258
    rm lib/"libssl.a"

    (bin/"nss-config").write config_file
    (lib/"pkgconfig/nss.pc").write pc_file
  end

  test do
    # See: https://developer.mozilla.org/docs/Mozilla/Projects/NSS/tools/NSS_Tools_certutil
    (testpath/"passwd").write("It's a secret to everyone.")
    system "#{bin}/certutil", "-N", "-d", pwd, "-f", "passwd"
    system "#{bin}/certutil", "-L", "-d", pwd
  end

  # A very minimal nss-config for configuring firefox etc. with this nss,
  # see https://bugzil.la/530672 for the progress of upstream inclusion.
  def config_file
    <<~EOS
      #!/bin/sh
      for opt; do :; done
      case "$opt" in
        --version) opt="--modversion";;
        --cflags|--libs) ;;
        *) exit 1;;
      esac
      pkg-config "$opt" nss
    EOS
  end

  def pc_file
    <<~EOS
      prefix=#{prefix}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${prefix}/include/nss

      Name: NSS
      Description: Mozilla Network Security Services
      Version: #{version}
      Requires: nspr >= 4.12
      Libs: -L${libdir} -lnss3 -lnssutil3 -lsmime3 -lssl3
      Cflags: -I${includedir}
    EOS
  end
end
