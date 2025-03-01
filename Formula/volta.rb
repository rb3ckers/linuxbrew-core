class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
      tag:      "v1.0.2",
      revision: "9606139be374266859264c7931e990ad97ae8419"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "f5cd81c20e5d2e1905ed7a5d2ea9226d2442d9a09e179b3fc0745fff03d02f66"
    sha256 cellar: :any_skip_relocation, catalina:     "fd1a4f0863b40c15ddd020f278fa7a6b3a9767b897261f5a4cca07bb70c00f9b"
    sha256 cellar: :any_skip_relocation, mojave:       "e4cd16ed32908bf0a03d961ae846d31c3d10e158d0b4c9c7ad74b029c8b1f9ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "90d3f1ddab1aa485e742052758744a5910b23bedabd4f29d0ae5e6e3583aebca"
  end

  depends_on "rust" => :build

  uses_from_macos "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read("#{bin}/volta", "completions", "bash")
    (bash_completion/"volta").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/volta", "completions", "zsh")
    (zsh_completion/"_volta").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/volta", "completions", "fish")
    (fish_completion/"volta.fish").write fish_output
  end

  test do
    system "#{bin}/volta", "install", "node@12.16.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "12.16.1", shell_output("#{node} --version")
  end
end
