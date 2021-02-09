class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.8.3",
      revision: "e282a1f927086cc046b967f0171840e238a9aa8c"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "51f95a0a78d7bda884aaa3c480921399a6879ccd6d2ca40ca1221f1c72b99cd2"
    sha256 cellar: :any_skip_relocation, catalina:     "e0b6f5a6369c34ddc92a483327148e9e9db4f378f2df448b70c0641e2a3f36a8"
    sha256 cellar: :any_skip_relocation, mojave:       "e9f71192aaf6d3f314820336c99b5df0209299b4bd1ce3790aa36515a7b7aba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c3faa43ba173b18cf0802b4220b372095ee69adde4db4756f11f43b96b892f02"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["VERSION"] = version.to_s
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    srcpath = buildpath/"src/istio.io/istio"
    outpath = OS.mac? ? srcpath/"out/darwin_amd64" : srcpath/"out/linux_amd64"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "gen-charts", "istioctl", "istioctl.completion"
      bin.install outpath/"istioctl"
      bash_completion.install outpath/"release/istioctl.bash"
      zsh_completion.install outpath/"release/_istioctl"
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
