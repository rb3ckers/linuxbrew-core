class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver.git",
    tag:      "v0.0.28",
    revision: "b997190cf70bbd3fef78ca12ef296cbe14daaf7d"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "499446c25b2badc8ac38d574b973462f127a22dd2572ff4dc40b3368df3663c8"
    sha256 cellar: :any_skip_relocation, big_sur:       "f6ce3f7dac6fd7a9758df174c34a938557e7b553eff9724ab3d6990d8dd0823c"
    sha256 cellar: :any_skip_relocation, catalina:      "6dff49d3273db600f9e5b0fe3ab3d5ba9d1d8014e019733c4709fdf739179f57"
    sha256 cellar: :any_skip_relocation, mojave:        "d71f9e059ef6b77f746dc0bed334365b663e7f46072d9c39ad41b0c4dd1c51e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a42287c60ddc068825ae6642cb107e9d7da589c54dd6945e931e8649d9fc3778"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"config.yml").write <<~EOS
      version: 2
      root-markers:
        - ".git/"
      languages:
        python:
          - lint-command: "flake8 --stdin-display-name ${INPUT} -"
            lint-stdin: true
    EOS
    output = shell_output("#{bin}/efm-langserver -c #{testpath/"config.yml"} -d")
    assert_match "version: 2", output
    assert_match "lint-command: flake8 --stdin-display-name ${INPUT} -", output
  end
end
