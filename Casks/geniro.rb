cask "geniro" do
  version "1.4.1"
  sha256 "fd4f342478dbdd6fca6941c3d4ba0d23da773970a8efdf70e8980abf82a9d44b"

  url "https://github.com/geniro-io/geniro-app/releases/download/v#{version}/Geniro-#{version}-arm64-mac.zip"
  name "Geniro"
  desc "Local-first desktop app for composing and running a DAG of CLI coding agents"
  homepage "https://github.com/geniro-io/geniro-app"

  depends_on arch: :arm64
  depends_on macos: ">= :sonoma"

  app "Geniro.app"

  # The build is ad-hoc signed (no Apple Developer ID / notarization). Modern
  # Homebrew (6.x) always applies com.apple.quarantine to a cask artifact and no
  # longer offers `--no-quarantine`, so a quarantined ad-hoc app cannot spawn its
  # bundled daemon subprocess (Gatekeeper blocks the child) and hangs on launch.
  # Strip the quarantine bit after install so the app runs. (The proper fix is a
  # Developer ID signature + notarization; until then this is the ad-hoc path.)
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
