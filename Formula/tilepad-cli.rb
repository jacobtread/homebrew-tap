class TilepadCli < Formula
  desc "CLI for developing tilepad plugins"
  homepage "https://tilepad.pages.dev"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TilePad/tilepad-cli/releases/download/0.6.0/tilepad-cli-aarch64-apple-darwin.tar.xz"
      sha256 "671bae55d442e985d06c5ecbd6afb366b65d5407c2f2a79d0978e25c94519e6d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TilePad/tilepad-cli/releases/download/0.6.0/tilepad-cli-x86_64-apple-darwin.tar.xz"
      sha256 "51eacce4c18c46f998d41d174e647a88f9e4567aeca52016678a10a7d73fa924"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TilePad/tilepad-cli/releases/download/0.6.0/tilepad-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "75b957f75cb539c2ae38de7084a5a21f259b46c4f6f8408471032f69644304bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TilePad/tilepad-cli/releases/download/0.6.0/tilepad-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "979e7608822d3423e3aa7771bc2853cc64cadfa585d89924671554649e0126d6"
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
