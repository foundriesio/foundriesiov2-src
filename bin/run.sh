#!/bin/bash
set -x
token="1EA2rlUu4hSQZM0U6thz0Ii0V99bTf8g2Oip31Kh"

alias jobserv-curl='curl -H '\''OSF-TOKEN: $token'\'' '
filename=blog-post-update-

#jobserv-curl https://api.foundries.io/updates/
curl-it(){
    echo "getting notes for $1, $2, $3 ..."
    echo $1 >> ../src/content/insights/$filename$3.md
    #jobserv-curl https://api.foundries.io/releases/$2/$3/
    echo "$3-$2.json | ./mp2md.py >> ../src/content/insights/$filename$3.md"
    cat $3-$2.json | ./mp2md.py >> ../src/content/insights/$filename$3.md
}

highlight-it(){
    echo "getting summaries $1 $2 ..."
    echo "# Summary" >> ../src/content/insights/$filename$2.md
    echo "" >> ../src/content/insights/$filename$2.md
    echo "## Zephyr microPlatform changes for $2" >> ../src/content/blog/$filename$2.md
    echo "" >> ../src/content/insights/$filename$2.md
    cat $2-zmp.json | ./mp2md-highlights.py >> ../src/content/blog/$filename$2.md
    echo "" >> ../src/content/insights/$filename$2.md
    echo "## Linux microPlatform changes for $2" >> ../src/content/blog/$filename$2.md
    echo "" >> ../src/content/insights/$filename$2.md
    cat $2-lmp.json | ./mp2md-highlights.py >> ../src/content/blog/$filename$2.md
    echo "<!--more-->" >> ../src/content/insights/$filename$2.md
}


header(){
cat > ../src/content/insights/$filename$1.md <<EOL
+++
title = "microPlatform update $1"
date = "$2"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

EOL
}

echo "NOT REGENERATING 17.10.1 release"
#var=17.10.1
#header $var '2017-10-13'
#highlight-it '# Highlights' $var
#curl-it '# Zephyr microPlatform' zmp $var
#curl-it '# Linux microPlatform' lmp $var


var=0.25
header $var '2018-07-12'
highlight-it '# Highlights' $var
curl-it '# Zephyr microPlatform' zmp $var
curl-it '# Linux microPlatform' lmp $var
