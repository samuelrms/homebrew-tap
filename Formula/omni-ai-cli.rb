class OmniAiCli < Formula
  desc "One chat for Claude Code, Codex, Antigravity and OpenRouter with automatic routing"
  homepage "https://github.com/samuelrms/omni-ai-cli"
  url "https://github.com/samuelrms/omni-ai-cli/archive/refs/tags/v1.24.11.tar.gz"
  sha256 "676f5e12d5039717ed84a0b37528b115f04b3ba9c7c4aaa7528e576671ef0c9a"
  license "MIT"

  depends_on "python@3.12"

  def install
    libexec.install "omni_ai"
    libexec.install "package.json"
    # package.json ships a placeholder version; stamp the real one so `ai --version` is right
    inreplace libexec/"package.json", "0.0.0-development", version.to_s
    (bin/"ai").write <<~EOS
      #!/bin/bash
      export PYTHONPATH="#{libexec}${PYTHONPATH:+:$PYTHONPATH}"
      exec "#{Formula["python@3.12"].opt_bin}/python3.12" -P -m omni_ai "$@"
    EOS
    bin.install_symlink bin/"ai" => "omni-ai"
    bin.install_symlink bin/"ai" => "smart-ai"
  end

  test do
    assert_match "ai", shell_output("#{bin}/ai --help")
  end
end
