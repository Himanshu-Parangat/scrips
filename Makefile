.POSIX:
PREFIX ?= /usr

install:
	install -m755 applet $(PREFIX)/bin/applet
	install -m777 applet.desktop $(PREFIX)/share/applications/applet.desktop

reinstall:
	install -m755 applet $(PREFIX)/bin/applet
	install -m777 applet.desktop $(PREFIX)/share/applications/applet.desktop

uninstall:
	rm -f $(PREFIX)/bin/applet $(PREFIX)/share/applications/applet.desktop

.PHONY: install uninstall reinstall
