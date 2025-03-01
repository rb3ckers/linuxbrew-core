class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.148.0.tar.gz"
  sha256 "77ff0623bcd48b276a633162c89fe719b931ff2111a204d97eef4bc5b1bb6e7d"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "0feaf978d1c67097f593d3942f9794bf8c9ffab4b319715695c16bd0f9c82129"
    sha256 cellar: :any_skip_relocation, catalina:     "8f1e93701b1433c3aea806a9c6d6f1b24d54b836ea440c7909fa6508573591a2"
    sha256 cellar: :any_skip_relocation, mojave:       "17d893b8a8571305ec799083f2bde9015fb3abe733a12631dea588bbf25b2687"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dd508bb69c22248c8c16687f42dc454517f342bff9bcc1c67cb0e621ffd8dc8a"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
