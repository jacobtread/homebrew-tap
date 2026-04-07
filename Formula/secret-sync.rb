class SecretSync < Formula
  desc "CLI tool for syncing local secret files with remote secret managers"
  homepage "https://github.com/jacobtread/secret-sync"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/secret-sync/releases/download/0.2.1/secret-sync-aarch64-apple-darwin.tar.xz"
      sha256 "1390381fd57ba8e2524f82dc4777a1d2e0b9d10bbb63ecf96c9329e299e967b0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/secret-sync/releases/download/0.2.1/secret-sync-x86_64-apple-darwin.tar.xz"
      sha256 "2fd63b5bdfb1d66e72aaee219a83e392721b696ab3fffc746cfbebb8f67d196b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/secret-sync/releases/download/0.2.1/secret-sync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "20adcc4434d18dec0cdd678bee6ac352b320ca23253a73e9ae76277839870a63"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/secret-sync/releases/download/0.2.1/secret-sync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6af4d46db8f81e68b0cec218a72fe4890950807ddacc0161d5412333c4dcb627"
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
    bin.install "secret-sync" if OS.mac? && Hardware::CPU.arm?
    bin.install "secret-sync" if OS.mac? && Hardware::CPU.intel?
    bin.install "secret-sync" if OS.linux? && Hardware::CPU.arm?
    bin.install "secret-sync" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
