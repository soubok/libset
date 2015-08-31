# update an external library #
```
find . -type f ! -wholename "*[.]svn*" -delete

cp -R NEW_VERSION/* .

Now find empty directories (these with only .svn) and "svn rm" them :
find . -type d -name '.svn' | while read i; do f=$(ls -la "$i/.." |grep -v '\.\.' |grep -v '\.$'|grep -v 'total' |wc -l); test $f -eq 1 && echo "$i/.."; done

svn status | grep "^[^M]" #check ? and ! flags

svn ci -m"- update LIBRARY to version VERSION"

svn cp https://libset.googlecode.com/svn/trunk/CURRENT_VERSION https://libset.googlecode.com/svn/trunk/NEW_VERSION -m"- create NEW_VERSION"
```


# update TraceMonkey #
```
wget http://hg.mozilla.org/mozilla-central/archive/tip.tar.bz2
tar jfx tip.tar.bz2 --wildcards mozilla-central-*/js/src
```