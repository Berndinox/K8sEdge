/usr/bin/find . -name *.drawio -exec rm -f {}.pdf \; -exec draw.io --crop -x -o {}.pdf {} \;
