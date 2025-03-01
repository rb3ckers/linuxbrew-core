class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.18.tar.gz"
  sha256 "a220559de76ac802745fc902015d69d3f49dbf916abcddb73c2942afe6115b84"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e53b4faf66e2ee6c725e51bd170f9fb402a61fb02192c79536a951c2096c33c5"
    sha256 cellar: :any_skip_relocation, big_sur:       "1ec6ff74177c1d345b14410d7a3230770c99d9bbab66cb543fc5867fa0b9e68c"
    sha256 cellar: :any_skip_relocation, catalina:      "50a7f53f51e49b248e154c6014bd76269e77cddbb2dde81cf621b1bf17faeee9"
    sha256 cellar: :any_skip_relocation, mojave:        "3d143cd95091061bb2963b259f3fa35514410d28574489695f3e65f20d20575a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fae0ae6b4a03edc105ab9780686574c5c7e69dc9bafc251252507b9dde770717"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
