class TilepadCli < Formula
  desc "CLI for developing tilepad plugins"
  homepage "https://tilepad.pages.dev"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tilepad/tilepad-cli/releases/download/0.6.0/tilepad-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f5b88b786ba45d9ef33e3e3dc4f051aa560ceab8123b99a2d6ab395049cf6af3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tilepad/tilepad-cli/releases/download/0.6.0/tilepad-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9b4220e01940c22b0373433c323b200c855cbe1486d7d68655e4328129a9c7eb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tilepad/tilepad-cli/releases/download/0.6.0/tilepad-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "19568d0e0abf24a33b38a2e1d72cf3e7064dcf7d94274ca7ad06c8a69d2f7f26"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tilepad/tilepad-cli/releases/download/0.6.0/tilepad-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "151eb0c904f7615fac6b22172096ac6e103d71ccbc1fb0027d7ab869a25fc704"
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
