class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.8.1.tar.gz"
  sha256 "2a140b1d556c29623e280e85ffe37227a26a27571f084bea8fd1fcfd2ffe5008"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "75b527f36b5ab4279c6f6cf3d71a0f408adb442e27eb63e49142b46a7f0ab676"
    sha256 cellar: :any_skip_relocation, big_sur:       "2a881d23edd63424e25f2aa304c1f390109d930e8d796603fcb7eba1cab20f35"
    sha256 cellar: :any_skip_relocation, catalina:      "e99b9643dc0b94c73a25d837ae042289fd5723a3d826d38f09a3b31c73562fdd"
    sha256 cellar: :any_skip_relocation, mojave:        "3eefd63841f665c083dc2147870738ec49b013e3b72a3c0ea9f32a7ef23e3356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfae4f5e547c62ea8efbe4a2e954134921f969e11a94d100697baf6c7669771d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/tools/cli/main.go"
  end

  test do
    # Given tctl is pointless without a server, not much intersting to test here.
    run_output = shell_output("#{bin}/tctl --version 2>&1")
    assert_match "tctl version", run_output

    run_output = shell_output("#{bin}/tctl --ad 192.0.2.0:1234 n l 2>&1", 1)
    assert_match "rpc error", run_output
  end
end
