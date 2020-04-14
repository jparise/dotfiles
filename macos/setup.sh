#!/bin/sh

# See also:
# - https://github.com/mathiasbynens/dotfiles/blob/master/.osx
# - https://github.com/necolas/dotfiles/blob/master/bin/osxdefaults

chflags nohidden ~/Library

## Input

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

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

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Disable window and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Expand the following File Info panes: "General", "More Info", "Open With"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	MetaData -bool true \
	OpenWith -bool true

## Dock

# Position the Dock on the right
defaults write com.apple.dock orientation right

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

## Safari

# Map Command-W to only close tabs but not the window
defaults write com.apple.Safari NSUserKeyEquivalents -dict-add 'Close Tab' '<string>@w</string></dict>'

## Tweetbot

# Bypass the annoyingly slow t.co URL shortener
defaults write com.tapbots.TweetbotMac OpenURLsDirectly -bool true

## Visual Studio Code

# Disable system "press-and-hold" behavior so we get key repeats
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

## Cleanup

# Restart all affected applications.
for app in "Dashboard" "Dock" "Finder" "SystemUIServer"; do
	killall "$app" > /dev/null 2>&1
done
