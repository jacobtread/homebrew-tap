class TilepadCli < Formula
  desc "CLI for developing tilepad plugins"
  homepage "https://tilepad.pages.dev"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tilepad/tilepad-cli/releases/download/0.6.0/tilepad-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b1dc9a85fb876efb835b575a8b96af1edf4865064453792827b07d38a08a8d5e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tilepad/tilepad-cli/releases/download/0.6.0/tilepad-cli-x86_64-apple-darwin.tar.xz"
      sha256 "6eda4e49cfc08f8ec2542d2c0e860ad1f25a41ee8f4ea704c4381a4d72a7b483"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tilepad/tilepad-cli/releases/download/0.6.0/tilepad-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2c347d2c695cf824c11de48082fbd74d27dbb51eadb4fcfdd07a5d395a0ac7d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tilepad/tilepad-cli/releases/download/0.6.0/tilepad-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5310618ef2075740d102e33b02f736f710f4a2e06d62e9fc411b2d7184c57b44"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-pc-windows-gnu":            {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "tilepad"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "tilepad"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "tilepad"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "tilepad"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
