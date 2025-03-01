class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.174.tar.gz"
  sha256 "32a0a842081412eac756bf07a6f7ded421c78b2dcba3d4a8f6c410b532d0c739"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7631e29076f850b3e0715c09c2c9088dc08f9233a9862f7fd2e3740934aac52d"
    sha256 cellar: :any_skip_relocation, big_sur:       "aa2e5aa36eec3aa7aaebd85045370724dd3e0f4c77d488509459ff08ddae9d55"
    sha256 cellar: :any_skip_relocation, catalina:      "3f525e6070e586a7d4cbdf3d10a21fd3f051eccde0f1535c41fd1901e00dbcbb"
    sha256 cellar: :any_skip_relocation, mojave:        "58ed68fcaff777b01dd3d3c218e2ee10d97cc150c10c9a4ff56cb1f767a08f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6937fa06f812a5cd8586cd315d66e7285d375fcbaa2da381e74c9e9ac81dfe6"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
