c = get_config()

c.TerminalIPythonApp.display_banner = False

c.InteractiveShell.confirm_exit = False

c.InteractiveShellApp.extensions = ['autoreload']
c.InteractiveShellApp.exec_lines = ['%autoreload 2']
