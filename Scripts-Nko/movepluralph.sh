#bash commands to move \pl & \plph up to infront of the first \sn
dos2unix -n Nkolex\ in\ Unicode.txt tmp/nkolex-unix
perl -pe 's/\n*$/##/' <tmp/nkolex-unix |perl -pe 's/##\\lx/\n\\lx/g' |perl -pe 's/(\\sn.*?)(\\pl.*?\\plph.*?##)/$2$1/; s/##/\n/g;' >tmp/nkolex-u1
unix2dos -n tmp/nkolex-u1 tmp/nkolex-u2
mv tmp/nkolex-u2  Nkolex\ in\ Unicode.txt
