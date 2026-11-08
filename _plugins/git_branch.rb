# Exposes the checked-out git branch and commit to Liquid as site.git_branch
# and site.git_commit. GitHub Pages builds in safe mode, so this plugin is
# skipped there and the footer line is hidden on the published site.

module GitBranch
  def self.ref(source)
    git_path = File.join(source, ".git")

    git_dir =
      if File.directory?(git_path)
        git_path
      elsif File.file?(git_path)
        # Worktrees have a .git file pointing at the real git directory.
        File.read(git_path)[/gitdir:\s*(.+)/, 1]&.strip
      end

    head = git_dir && File.join(git_dir, "HEAD")
    return unless head && File.file?(head)

    ref = File.read(head).strip
    ref.start_with?("ref: refs/heads/") ? ref.sub("ref: refs/heads/", "") : ref[0, 7]
  end

  def self.commit(source)
    out = IO.popen(["git", "-C", source, "rev-parse", "--short", "HEAD"], err: File::NULL, &:read).strip
    out.empty? ? nil : out
  rescue SystemCallError
    nil
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  site.config["git_branch"] = GitBranch.ref(site.source)
  site.config["git_commit"] = GitBranch.commit(site.source)
end
