#!/usr/bin/env bash

WORK_DIR=`mktemp --directory`

WORKFILE="$WORK_DIR/word.list"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd "$WORK_DIR"


# Grab just words without any numbers or punctuation
sed --expression 's/[^a-zA-Z]/ /g' $SCRIPT_DIR/source-material/{book-of-mormon-2008.txt,prophets.txt,standard-works-83501-eng.txt} | sed --expression 's/\s\+/\n/g' > "$WORKFILE"

cat SCRIPT_DIR/common-passwords.lds >> "$WORKFILE"
cat SCRIPT_DIR/unitnumbers.txt >> "$WORKFILE"

#####

git clone https://github.com/danielmiessler/SecLists.git

find SecLists/Passwords -type f -exec cat {} +  > "$WORKFILE.SecLists.part"

cat "$WORKFILE.SecLists.part" >> "$WORKFILE"

#####



#####
sort --unique --output "$WORKFILE"     "$WORKFILE"

wc --lines "$WORKFILE"

# John the Ripper 1.9.0-jumbo-1 OMP
john --config=john-rules.conf --rules --wordlist="$WORKFILE" --stdout > "$WORKFILE.ruled"
```
