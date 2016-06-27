# Terminfo

These terminfo database customizations add escape sequences for italics and
overwrite conflicting sequences for standout text. To verify:

```sh
echo `tput sitm`italics`tput ritm` `tput smso`standout`tput rmso`
```

Credit goes to [Greg Hurrell](https://github.com/wincent)
([Screencast](https://www.youtube.com/watch?v=n1cKtZfwOgQ)).
