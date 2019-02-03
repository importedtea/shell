#!/bin/bash

# ISSUE
# This script causes an XML parsing error, the document seems to be retrievable
# There probably isn't a workaround for this because of the complexity of .docx xml files

for i in *.docx; do

unzip $i -d temporary
find temporary -type f | xargs sed -i 's/"Cambria"/Calibri/g'
#find temporary -type f | xargs sed -i 's/"&apos;Times New Roman&apos;"/"Calibri"/g'
cd temporary; zip -r ../$i .
cd ..; rm -rf temporary/

done
