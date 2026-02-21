class Cli < Formula
  desc "Command-line interface for Tektii trading platform"
  homepage "https://tektii.com"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tektii/tektii-be/releases/download/cli-v0.1.0/cli-aarch64-apple-darwin.tar.xz"
      sha256 "e1eb1ec93c74bb1f2603a4c83f9522791da8a308f8e9c2ea071c5183cffd7b11"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tektii/tektii-be/releases/download/cli-v0.1.0/cli-x86_64-apple-darwin.tar.xz"
      sha256 "e32dd72b2c45ef20ba9da525e72ca5cd05c1c097341f836f4d9c2c387749164f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tektii/tektii-be/releases/download/cli-v0.1.0/cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b1770f721dab9102dd362e983f8ee1af6b1bf10d7e7b56790b2e0366b72dd685"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tektii/tektii-be/releases/download/cli-v0.1.0/cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6ec31cb4126d9d3cbee67b50d491153765bcf0b12236eb77cbe4d2ca09e38f82"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "tektii" if OS.mac? && Hardware::CPU.arm?
    bin.install "tektii" if OS.mac? && Hardware::CPU.intel?
    bin.install "tektii" if OS.linux? && Hardware::CPU.arm?
    bin.install "tektii" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
