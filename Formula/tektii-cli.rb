class TektiiCli < Formula
  desc "Command-line interface for Tektii trading platform"
  homepage "https://tektii.com"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://get.tektii.com/download/tektii-cli-v0.2.2/tektii-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6bba76bf9734cedea9479f6469bc5d728b8e8820c58fa1eb282dd631f5c49d0b"
    end
    if Hardware::CPU.intel?
      url "https://get.tektii.com/download/tektii-cli-v0.2.2/tektii-cli-x86_64-apple-darwin.tar.xz"
      sha256 "7d0385614ce9f3c89242d4e09712167721f6740642f769a4478a5dd2f2afc05e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://get.tektii.com/download/tektii-cli-v0.2.2/tektii-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "edda0ba133c9d524990c20b9c919830c53c3cc8611aa18c4c8f232e0cc1aa09a"
    end
    if Hardware::CPU.intel?
      url "https://get.tektii.com/download/tektii-cli-v0.2.2/tektii-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f32a5212f0c2b4892824f073fa7f1c6274ffa151f59b67fe0261d9d3d0f8402a"
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
