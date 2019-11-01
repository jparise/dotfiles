" Also recognize `+` characters in Objective-C header filenames.
syn match objcImported display contained "\(<\h[-+a-zA-Z0-9_/]*\.h>\|<[a-z0-9]\+>\)"
