class TektiiCli < Formula
  desc "Command-line interface for Tektii trading platform"
  homepage "https://tektii.com"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://get.tektii.com/download/tektii-cli-v0.2.3/tektii-cli-aarch64-apple-darwin.tar.xz"
      sha256 "91507d8a75cc4ba054cfaaf0e49123f4977ee0d24777dbd20752d8777ed54cf5"
    end
    if Hardware::CPU.intel?
      url "https://get.tektii.com/download/tektii-cli-v0.2.3/tektii-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d56e28daa66744a618e9f2f76935311d08cacfcf51a0e323c56b1e2eef9e0076"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://get.tektii.com/download/tektii-cli-v0.2.3/tektii-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d2724dbd927bba2bed47d581ea57812f2dcd12b948532e83e89acdccb469c62a"
    end
    if Hardware::CPU.intel?
      url "https://get.tektii.com/download/tektii-cli-v0.2.3/tektii-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9359fedad625a0a76a8b166feccb7508cc081e33dd8fd040534c01c8e626f929"
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
