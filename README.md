```
sed --expression 's/[^a-zA-Z]/ /g' source-material/*.txt | sed --expression 's/\s\+/\n/g' > wordlist.lds
cat common-passwords.lds >> wordlist.lds

sort --unique --output wordlist.lds wordlist.lds

wc --lines wordlist.lds

# John the Ripper 1.9.0-jumbo-1 OMP

john --config=john-rules.conf --rules --wordlist=wordlist.lds --stdout > wordlist-ruled.lds
```