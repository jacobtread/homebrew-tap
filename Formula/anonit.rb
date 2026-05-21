class Anonit < Formula
  desc "Data anonymizing tool."
  homepage "https://github.com/jacobtread/anonit"
  version "0.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.3/anonit-aarch64-apple-darwin.tar.xz"
      sha256 "f6840567fd6832863a12e5074c0ef2bc3923749d401a12231c120ac3521d0fbb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.3/anonit-x86_64-apple-darwin.tar.xz"
      sha256 "451f414f236714958f8467ffb9dbf3aafa4778cf8f3bf466b59fbb227780d64c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.3/anonit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5d86abf51731d69c34e91aba480fd7e9053f758f9343c433ff2175aa4536d7d3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.3/anonit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8f9ab5e20b85ed1a317e2e6ca5e4f0828eb9e5c0414b6b5fcdd388a423535d74"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
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
    bin.install "anonit" if OS.mac? && Hardware::CPU.arm?
    bin.install "anonit" if OS.mac? && Hardware::CPU.intel?
    bin.install "anonit" if OS.linux? && Hardware::CPU.arm?
    bin.install "anonit" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
