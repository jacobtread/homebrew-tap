class Anonit < Formula
  desc "Data anonymizing tool."
  homepage "https://github.com/jacobtread/anonit"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.2/anonit-aarch64-apple-darwin.tar.xz"
      sha256 "97fa37290f2779347154082cd25480b6e4808f095400e404a1482f2d0bba44ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.2/anonit-x86_64-apple-darwin.tar.xz"
      sha256 "2428ed6b8caa221c9ca0d42bdaa28103242f8fccff98f556718a1716af8e433d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.2/anonit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ea636e6518bbf71c139c69eecc7d9735fdb5533f72e6c7a1683731d43ed1c351"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.2/anonit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7b5af2d9bce03687c3de1005b27a1e9a741a42ed9cadd1485b72ce455f814b87"
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
