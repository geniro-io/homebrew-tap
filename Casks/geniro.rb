cask "geniro" do
  version "1.4.0"
  sha256 "339621e72f1ac9bf853951f383d36bc1462b8eaf940d25229bb28d7595192a1c"

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
