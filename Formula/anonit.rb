class Anonit < Formula
  desc "Data anonymizing tool."
  homepage "https://github.com/jacobtread/anonit"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.2/anonit-aarch64-apple-darwin.tar.xz"
      sha256 "c928a8081e98fbd663b2f8ddcb10aa993e7d9c0339148471daee11b4d145b9f6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.2/anonit-x86_64-apple-darwin.tar.xz"
      sha256 "324b4679e75eed596eb7c9ba464687de0c73df78b2757bfbdd7db715a2658743"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.2/anonit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8dabe7c5c9880661a482c9ac4bcb3593a10f3cdfd965e6d47628eedc56850827"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.2/anonit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f52b50d1be2155df9a330c2f188fa18eb967f457d3ae63850a6ba3e71f4303c2"
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
