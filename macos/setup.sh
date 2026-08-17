#!/bin/sh

# Targets macOS 26 (Tahoe) and later.
if [ "$(sw_vers -productVersion | cut -d. -f1)" -lt 26 ]; then
	echo "warning: this script targets macOS 26+; some settings may not apply." >&2
fi

chflags nohidden ~/Library

## Input

# Key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 35
defaults write NSGlobalDomain KeyRepeat -int 6

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Autocorrect
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Text replacements. This list is authoritative: `defaults` has no merge
# form for arrays, so anything added through System Settings is lost on
# the next run unless it's also added here.
defaults write NSGlobalDomain NSUserDictionaryReplacementItems -array \
	'{ replace = "<--"; with = "\U2190 "; }' \
	'{ replace = "<->"; with = "\U2194"; }' \
	'{ replace = "-->"; with = "\U2192"; }' \
	'{ replace = "omw"; with = "On my way!"; }' \
	'{ replace = "brt"; with = "Be right there."; }'

## Screen

# Save screenshots to the Desktop as PNGs
defaults write com.apple.screencapture location -string "${HOME}/Desktop"
defaults write com.apple.screencapture type -string "png"

## Finder

# Only show icons for external / removable media on the Desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Use list view by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Open new windows in the home directory
defaults write com.apple.finder NewWindowTarget -string "PfAF"

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Expand the following File Info panes: "General", "More Info", "Open With"
defaults write com.apple.finder FXInfoPanesExpanded -dict-add \
	General -bool true \
	MetaData -bool true \
	OpenWith -bool true

## Dock

# Position the Dock on the right and hide it when unused
defaults write com.apple.dock orientation right
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 36

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock mineffect scale

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Don't show recent applications
defaults write com.apple.dock show-recents -bool false

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Reduce menu bar status item spacing
defaults -currentHost write -globalDomain NSStatusItemSpacing -int 8

## Desktop

# Hide desktop icons unless the Desktop is focused in Finder, and don't
# reveal the desktop on a stray click in the wallpaper
defaults write com.apple.WindowManager HideDesktop -bool true
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Tile windows edge to edge, and don't tile on a drag to the screen top
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false
defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false

## Visual Studio Code

# Disable system "press-and-hold" behavior so we get key repeats
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

## Cleanup

# Restart all affected applications.
for app in "Dock" "Finder" "SystemUIServer" "WindowManager"; do
	killall "$app" > /dev/null 2>&1
done
