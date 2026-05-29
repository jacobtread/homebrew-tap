class Crabbyqlite < Formula
  desc "Tool for working with SQLite files"
  homepage "https://github.com/jacobtread/crabbyqlite"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/crabbyqlite/releases/download/0.0.2/crabbyqlite-aarch64-apple-darwin.tar.xz"
      sha256 "1f793ca75c9b19ac9ab6ea378269dd698e7acc72f591941b367d942f88c5faaf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/crabbyqlite/releases/download/0.0.2/crabbyqlite-x86_64-apple-darwin.tar.xz"
      sha256 "b6377d0bdbd9fd9967747da74cbc445d408edd188c1afad908a751dc63922332"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/crabbyqlite/releases/download/0.0.2/crabbyqlite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ec7ce38ae33493bb8ed3ed47287c978f88262cf67a9ea20c108b3c7c2def6ac3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/crabbyqlite/releases/download/0.0.2/crabbyqlite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "48b61dfc27c19da0c75ef85278e32038217bf1f05ada3e6ddd4c219c9db22026"
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
