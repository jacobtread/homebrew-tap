class Anonit < Formula
  desc "Data anonymizing tool."
  homepage "https://github.com/jacobtread/anonit"
  version "0.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.3/anonit-aarch64-apple-darwin.tar.xz"
      sha256 "7d4a0b1830df6cb974116fa17e74e8d3144385cee3f49e2895e16d9c18f6c39c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.3/anonit-x86_64-apple-darwin.tar.xz"
      sha256 "f9da9ebb5e319754592aea9f7ec3d33ed4ea2c5bfe3b2959b66fcf9c95963418"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.3/anonit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "537f073bb33745a55879c228c907d0125b8199a248ed2934d49030558ed0316a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.3/anonit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a7fa2e313db384f057fbc292b68df619a2f340d068d11a43d2055bd74d42f414"
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
