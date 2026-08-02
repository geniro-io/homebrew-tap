cask "geniro" do
  version "1.16.0"
  sha256 "3de302e26e896104e658fd1fd2d4b2d2d09cd3cfab4b40e6689f58ee6bbecb98"

  url "https://github.com/geniro-io/geniro-app/releases/download/v#{version}/Geniro-#{version}-arm64-mac.zip"
  name "Geniro"
  desc "Local-first desktop app for composing and running a DAG of CLI coding agents"
  homepage "https://github.com/geniro-io/geniro-app"

  depends_on arch: :arm64
  depends_on macos: ">= :sonoma"

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
