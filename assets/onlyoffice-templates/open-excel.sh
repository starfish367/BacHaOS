#!/bin/bash
mkdir -p "$HOME/Documents"
TMPFILE="$HOME/Documents/Bảng tính mới.xlsx"
[ ! -f "$TMPFILE" ] && cp /opt/onlyoffice-templates/blank.xlsx "$TMPFILE"
onlyoffice-desktopeditors "$TMPFILE"
