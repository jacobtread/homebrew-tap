class SecretSync < Formula
  desc "CLI tool for syncing local secret files with remote secret managers"
  homepage "https://github.com/jacobtread/secret-sync"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/secret-sync/releases/download/0.2.2/secret-sync-aarch64-apple-darwin.tar.xz"
      sha256 "bcbc86b75018198b14675e3e32c87f64eecc465901820f8c9fb807059681225d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/secret-sync/releases/download/0.2.2/secret-sync-x86_64-apple-darwin.tar.xz"
      sha256 "aba2a9dbb76a618ec7889296989f95110a0cdbc6a157411d92400a75ff0ea969"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/secret-sync/releases/download/0.2.2/secret-sync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "162be240768e8651720f1a66df6102b5eb2b45c89791f21ab8ed1c00c33c4241"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/secret-sync/releases/download/0.2.2/secret-sync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5dbe1f0662a38fa6fd01ee10f0bcb534ce4e6115b3d2ae6b07fdea5d153fc87a"
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
