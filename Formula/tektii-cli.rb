class TektiiCli < Formula
  desc "Command-line interface for Tektii trading platform"
  homepage "https://tektii.com"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tektii/tektii-be/releases/download/tektii-cli-v0.2.0/tektii-cli-aarch64-apple-darwin.tar.xz"
      sha256 "61853845c0ba9f2ed543130707414b98696006e26bea94e0708d9259088fa130"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tektii/tektii-be/releases/download/tektii-cli-v0.2.0/tektii-cli-x86_64-apple-darwin.tar.xz"
      sha256 "000af7cd3444845d362625aa3d906e45a4b8c22032e77fd87ad41cc70aa2ede9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tektii/tektii-be/releases/download/tektii-cli-v0.2.0/tektii-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b9fc05bd9c3e24259b188ee934375c39f395066c72a6c67eb217824a9beac9e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tektii/tektii-be/releases/download/tektii-cli-v0.2.0/tektii-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c9997293456c98457d45f8f0cbc6f61dea8c0bc628b3703902b0a61232417c76"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
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
