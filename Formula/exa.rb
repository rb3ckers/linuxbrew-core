class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.10.0.tar.gz"
  sha256 "27420f7b805941988399d63f388be4f6077eee94a505bf01c2fb0e7d15cbf78d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "17c9a2d3b8dfbe891e75273cc5168c8aaf2637ce5dfa8e4eea8597f87444ccaa"
    sha256 cellar: :any_skip_relocation, big_sur:       "7eb1810c90baefdb929cc0da8c49c6c31c54c68edf6bc28e357294127a439506"
    sha256 cellar: :any_skip_relocation, catalina:      "b57beae48897bdc664fe487d97a5fd2117c898fd1c89903786ffd8214be42020"
    sha256 cellar: :any_skip_relocation, mojave:        "4d6c09c544afcf8fcebc9a18fbaef262e8da65de7c916ccfa5df8c5d55a764b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "289a10323c1ced7a8d0575de72bbee794c596baa40fb8e90c9c70127dde8682b"
  end

  head do
    url "https://github.com/ogham/exa.git"
    depends_on "pandoc" => :build
  end

  depends_on "pandoc" => :build unless Hardware::CPU.arm?
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "libgit2"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/completions.bash" => "exa"
    zsh_completion.install  "completions/completions.zsh"  => "_exa"
    fish_completion.install "completions/completions.fish" => "exa.fish"

    args = %w[
      --standalone
      --to=man
    ]

    unless Hardware::CPU.arm?
      system "pandoc", *args, "man/exa.1.md", "-o", "exa.1"
      system "pandoc", *args, "man/exa_colors.5.md", "-o", "exa_colors.5"

      man1.install "exa.1"
      man5.install "exa_colors.5"
    end
  end

  test do
    (testpath/"test.txt").write("")
    assert_match "test.txt", shell_output("#{bin}/exa")
  end
end
