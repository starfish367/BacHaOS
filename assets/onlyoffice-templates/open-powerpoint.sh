#!/bin/bash
mkdir -p "$HOME/Documents"
TMPFILE="$HOME/Documents/Bài trình chiếu mới.pptx"
[ ! -f "$TMPFILE" ] && cp /opt/onlyoffice-templates/blank.pptx "$TMPFILE"
onlyoffice-desktopeditors "$TMPFILE"
