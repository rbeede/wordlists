```
WORKFILE=/tmp/word.list

# Grab just words without any numbers or punctuation
sed --expression 's/[^a-zA-Z]/ /g' source-material/{book-of-mormon-2008.txt,prophets.txt,standard-works-83501-eng.txt} | sed --expression 's/\s\+/\n/g' > "$WORKFILE"

cat common-passwords.lds >> "$WORKFILE"
cat unitnumbers.txt >> "$WORKFILE"

#####
sort --unique --output "$WORKFILE"     "$WORKFILE"

wc --lines "$WORKFILE"

# John the Ripper 1.9.0-jumbo-1 OMP
john --config=john-rules.conf --rules --wordlist="$WORKFILE" --stdout > "$WORKFILE.ruled"
```
