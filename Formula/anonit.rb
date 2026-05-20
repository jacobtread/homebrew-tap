class Anonit < Formula
  desc "Data anonymizing tool."
  homepage "https://github.com/jacobtread/anonit"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.2/anonit-aarch64-apple-darwin.tar.xz"
      sha256 "459b9e9e328e3f7f7705fad72c4ea172d2fb620dafbaae88d808429ea901bf85"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.2/anonit-x86_64-apple-darwin.tar.xz"
      sha256 "8bba134ece5216f34b1174b51e33d6e2b74ed2bfe2ca884e408df83dd0559201"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.2/anonit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "40287df7155a4bbc30c795d9c3075ee04d47ca91ee6d793c8e3d4e5bcb4d60c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/anonit/releases/download/0.0.2/anonit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "387d0ba1e760071ba6d709589025febe013178b23de5788ca1d4c44de1a22a94"
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
