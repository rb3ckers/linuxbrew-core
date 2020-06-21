require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.48.tgz"
  sha256 "339edb5e8e25251b21f8e7b21268b90928627ef477190f88fa777595e6672eaa"

  bottle do
    cellar :any_skip_relocation
    sha256 "954996c3957b750156358bea80eb480d17f9e223308a13da9f21da427aa23c66" => :catalina
    sha256 "ea8dface9d468ae899b7d4de82d85d03ade462fb8b1570c2a6fb6523202b52b4" => :mojave
    sha256 "430e339b6b29dc970a7f49bb5a45e92174e96bc43ce9a8f1ec71113c3253500d" => :high_sierra
    sha256 "107d3e80093033fabd68820bff36c93d0b17360936c2777db88c2f07ecd4ad4d" => :x86_64_linux
  end

  depends_on "node"

  on_linux do
    depends_on "linuxbrew/xorg/xorg"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Avoid references to Homebrew shims
    rm_f "#{libexec}/lib/node_modules/gatsby-cli/node_modules/websocket/builderror.log"
  end

  test do
    return if Process.uid.zero?

    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
