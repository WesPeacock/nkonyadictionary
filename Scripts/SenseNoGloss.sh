# display guids of entries that have senses with no gloss
cp ~/.local/share/fieldworks/Projects/NkTest/NkTest.fwdata . ; #
xmlstarlet sel -t -c "//rt[@class=\"LexSense\" and not(Gloss)]"  -n NkTest.fwdata |grep -o ownerguid.................. |sort ; # 