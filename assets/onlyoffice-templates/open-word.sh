#!/bin/bash
mkdir -p "$HOME/Documents"
TMPFILE="$HOME/Documents/Tài liệu mới.docx"
[ ! -f "$TMPFILE" ] && cp /opt/onlyoffice-templates/blank.docx "$TMPFILE"
onlyoffice-desktopeditors "$TMPFILE"
