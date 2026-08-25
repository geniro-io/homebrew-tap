cask "geniro" do
  version "1.51.1"
  sha256 "58034094f133d9632ff8413c9e283c332f9574550cf50997a43b82659e0be020"

  url "https://github.com/geniro-io/geniro-app/releases/download/v#{version}/Geniro-#{version}-arm64-mac.zip"
  name "Geniro"
  desc "Local-first desktop app for composing and running a DAG of CLI coding agents"
  homepage "https://github.com/geniro-io/geniro-app"

  depends_on arch: :arm64
  # A bare symbol, not ">= :sonoma": Homebrew deprecated the string
  # comparison form and the bare symbol already means "this version or
  # newer", so the requirement is unchanged. Observed live on
  # 2026-08-17 — every `brew` command touching this cask printed
  # "Calling string comparison format for `depends_on macos:` is
  # deprecated", loudly enough to bury the output of `brew outdated`.
  depends_on macos: :sonoma

  # The app replaces its own bundle in place, so the version on disk
  # can be ahead of the cask's. Without this, `brew upgrade` would
  # keep reinstalling over a self-updated app and report it outdated
  # forever; with it, brew leaves an app that updates itself alone
  # (`--greedy` still forces the reinstall).
  auto_updates true

  app "Geniro.app"

  # Ad-hoc build: strip com.apple.quarantine so the app can spawn its
  # bundled daemon instead of being Gatekeeper-blocked (Homebrew 6.x
  # always quarantines and dropped --no-quarantine).
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Geniro.app"]
  end

  zap trash: [
    "~/Library/Application Support/Geniro",
    "~/Library/Application Support/geniro",
    "~/Library/Preferences/io.geniro.desktop.plist",
    "~/Library/Logs/Geniro",
    "~/Library/Saved Application State/io.geniro.desktop.savedState",
  ]
end
