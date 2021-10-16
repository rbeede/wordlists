#!/usr/bin/env bash

WORK_DIR=`mktemp --directory`

WORKFILE="$WORK_DIR/word.list"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd "$WORK_DIR"


# Grab just words without any numbers or punctuation
sed --expression 's/[^a-zA-Z]/ /g' $SCRIPT_DIR/source-material/{book-of-mormon-2008.txt,prophets.txt,standard-works-83501-eng.txt} | sed --expression 's/\s\+/\n/g' > "$WORKFILE"

cat $SCRIPT_DIR/source-material/common-passwords.lds >> "$WORKFILE"
cat $SCRIPT_DIR/source-material/unitnumbers.txt >> "$WORKFILE"

cat $SCRIPT_DIR/source-material/book-names.txt >> "$WORKFILE"

# Now add another version with numbers added

# John the Ripper 1.9.0-jumbo-1 OMP
john --config=john-rules.conf --rules --wordlist="${WORKFILE}" --stdout --input-encoding=UTF8 > "${WORKFILE}.ruled"

mv "${WORKFILE}.ruled" "${WORKFILE}"

#####

git clone https://github.com/danielmiessler/SecLists.git

find SecLists/Passwords -type f -exec cat {} +  > "$WORKFILE.SecLists.part"

cat "$WORKFILE.SecLists.part" >> "$WORKFILE"

#####

git clone https://github.com/kaonashi-passwords/Kaonashi

transmission-cli Kaonashi/wordlists/kaonashi.7z.torrent

7z e kaonashi.7z

cat kaonashi.txt >> "$WORKFILE"

#####

# https://crackstation.net/crackstation-wordlist-password-cracking-dictionary.htm

transmission-cli https://crackstation.net/downloads/crackstation.txt.gz.torrent

7z e crackstation.txt.gz

cat realuniq.lst >> "$WORKFILE"

#####

git clone https://github.com/kennyn510/wpa2-wordlists.git

cat wpa2-wordlists/PlainText/* >> "$WORKFILE"

find wpa2-wordlists/Wordlists/ -name '*.gz' -exec zcat {} \; >> "$WORKFILE"

find wpa2-wordlists/Wordlists/ -type f ! -name '*.gz' -exec cat {} \; >> "$WORKFILE"

#####

# https://weakpass.com/download

transmission-cli https://download.weakpass.com/wordlists/1948/weakpass_3a.7z.torrent

7z e crackstation.txt.gz weakpass_3a.7z

cat weakpass_3a >> "$WORKFILE"

#####

# https://wiki.skullsecurity.org/index.php/Passwords

mkdir skullsecurity
cd skullsecurity

curl -O 'http://downloads.skullsecurity.org/passwords/john.txt.bz2'
curl -O 'http://downloads.skullsecurity.org/passwords/cain.txt.bz2'
curl -O 'http://downloads.skullsecurity.org/passwords/conficker.txt.bz2'
curl -O 'http://downloads.skullsecurity.org/passwords/500-worst-passwords.txt.bz2'
curl -O 'http://downloads.skullsecurity.org/passwords/twitter-banned.txt.bz2'
curl -O 'http://downloads.skullsecurity.org/passwords/rockyou.txt.bz2'
curl -O 'http://downloads.skullsecurity.org/passwords/phpbb.txt.bz2'
curl -O 'http://downloads.skullsecurity.org/passwords/myspace.txt.bz2'
curl -O 'http://downloads.skullsecurity.org/passwords/hotmail.txt.bz2'
curl -O 'http://downloads.skullsecurity.org/passwords/faithwriters.txt.bz2'
curl -O 'http://downloads.skullsecurity.org/passwords/elitehacker.txt.bz2'
curl -O 'http://downloads.skullsecurity.org/passwords/hak5.txt.bz2'
curl -O 'http://downloads.skullsecurity.org/passwords/alypaa.txt.bz2'
curl -O 'http://downloads.skullsecurity.org/passwords/facebook-pastebay.txt.bz2'
curl -O 'http://downloads.skullsecurity.org/passwords/porn-unknown.txt.bz2'
curl -O 'http://downloads.skullsecurity.org/passwords/tuscl.txt.bz2'
curl -O 'http://downloads.skullsecurity.org/passwords/facebook-phished.txt.bz2'
curl -O 'http://downloads.skullsecurity.org/passwords/carders.cc.txt.bz2'
curl -O 'http://downloads.skullsecurity.org/passwords/singles.org.txt.bz2'

bunzip2 *.bz2

cat * >> "$WORKFILE" 

cd ..

#####

# https://www.securedyou.com/download-passwords-wordlists-wpa-wpa2-kali-linux/

curl -O 'https://download2266.mediafire.com/iuqqgd41hgmg/mng007wak16c67f/BIG-WPA-LIST-3.rar'

7z e BIG-WPA-LIST-3.rar

cat BIG-WPA-LIST-3 >> "$WORKFILE"

#####

# https://www.wirelesshack.org/wpa-wpa2-word-list-dictionaries.html

curl -O 'https://download2331.mediafire.com/cq1bn1cyjmzg/m7tjhgfd61lfeu4/BIG-WPA-LIST-1.rar'

curl -O 'https://download1442.mediafire.com/owp6cbi6c4fg/6botgtnsy0rjfj9/BIG-WPA-LIST-2.rar'

curl -O 'https://download1514.mediafire.com/65fhw9ydboag/1s2oi5c1nu25uiz/darkc0de.lst'

curl -O 'https://download1483.mediafire.com/zu38evvsw1pg/4pxaixh1qghba2w/names.txt'

7z e *.rar

cat BIG-WPA-LIST-1 >> "$WORKFILE"
cat BIG-WPA-LIST-2 >> "$WORKFILE"
cat darkc0de.lst >> "$WORKFILE"
cat names.txt >> "$WORKFILE"



##################################################

sort --unique --parallel 8    --output "${WORKFILE}.sorted"     "$WORKFILE"

wc --lines "${WORKFILE}.sorted"

