class Crabbyqlite < Formula
  desc "Tool for working with SQLite files"
  homepage "https://github.com/jacobtread/crabbyqlite"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/crabbyqlite/releases/download/0.0.1/crabbyqlite-aarch64-apple-darwin.tar.xz"
      sha256 "bb687faa48bef4d435fd0d9e8a7a4c7c72192c0eb15db8ca871d2c3195aacacc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/crabbyqlite/releases/download/0.0.1/crabbyqlite-x86_64-apple-darwin.tar.xz"
      sha256 "e1e4020317c9235ea633260154d413faf37cc48c7c6f7cf2f5e518d2ccea96ff"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/crabbyqlite/releases/download/0.0.1/crabbyqlite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e06b3be73fbd7e72ee9570436461bde2c1cdc830dd09892cc7f74c2d48e52d96"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/crabbyqlite/releases/download/0.0.1/crabbyqlite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0ef6910ecd1810858dd696323706f4c88f672a27242bb10e5eb5454bcfe2cdf9"
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
    bin.install "crabbyqlite" if OS.mac? && Hardware::CPU.arm?
    bin.install "crabbyqlite" if OS.mac? && Hardware::CPU.intel?
    bin.install "crabbyqlite" if OS.linux? && Hardware::CPU.arm?
    bin.install "crabbyqlite" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
