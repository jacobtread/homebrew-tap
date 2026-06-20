class SecretSync < Formula
  desc "CLI tool for syncing local secret files with remote secret managers"
  homepage "https://github.com/jacobtread/secret-sync"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/secret-sync/releases/download/0.2.3/secret-sync-aarch64-apple-darwin.tar.xz"
      sha256 "3af4ba27de5916f13af2b444dfb0be39fe7f33ad1fcf18687f121073f07db011"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/secret-sync/releases/download/0.2.3/secret-sync-x86_64-apple-darwin.tar.xz"
      sha256 "b76408a25475100c8c02a9cdcdf3f9cbcceb47c2b8419cf8b2e9ec38044caa7e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jacobtread/secret-sync/releases/download/0.2.3/secret-sync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6f6b8fb2294205a8987fa81192d5dc4f7de33ff6f808e59529071c04f14b9a54"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jacobtread/secret-sync/releases/download/0.2.3/secret-sync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "36fe817ab042b5f7bc28f186de3297f49c73241aa847b40fe172e8e14ed80fba"
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
