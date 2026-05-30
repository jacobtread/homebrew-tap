class Crabbyqlite < Formula
  desc "Tool for working with SQLite files"
  homepage "https://github.com/jacobtread/crabbyqlite"
  version "0.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/crabbyqlite/releases/download/0.0.3/crabbyqlite-aarch64-apple-darwin.tar.xz"
      sha256 "e32b7f3445b00763484b9f96b359f3791ba43fa5eb7d140128c69ddfaea12546"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/crabbyqlite/releases/download/0.0.3/crabbyqlite-x86_64-apple-darwin.tar.xz"
      sha256 "f34f7f49098f53a288a6c2a72988f20e106af268713d44a1dd14d5e3e82a8941"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/crabbyqlite/releases/download/0.0.3/crabbyqlite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3326715210cb47fecf9f933519b2f7e024b8e7061361929a21c9a98893dae942"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/crabbyqlite/releases/download/0.0.3/crabbyqlite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "63a31a6cee4d52fb473651f083e8dfdf620fc2450b0709408709fab8976ee443"
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
