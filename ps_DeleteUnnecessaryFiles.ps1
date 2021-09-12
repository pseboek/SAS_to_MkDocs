Set-Location C:\SAS_to_MkDocs
$curDir = Get-Location
Remove-Item "$curDir\MACROS\*" -recurse -Include *.png
"png files deleted."
Remove-Item "$curDir\MACROS\*" -recurse -Include *.jpg
"jpg files deleted."
Remove-Item "$curDir\MACROS\*" -recurse -Include *.doc
"doc files deleted."
Remove-Item "$curDir\MACROS\*" -recurse -Include *.docx
"docx files deleted."
Remove-Item "$curDir\MACROS\*" -recurse -Include *.xls
"xls files deleted."
Remove-Item "$curDir\MACROS\*" -recurse -Include *.xlsx
"xlsx files deleted."
Remove-Item "$curDir\MACROS\*" -recurse -Include *.pdf
"pdf files deleted."
Remove-Item "$curDir\MACROS\*" -recurse -Include *.egp
"egp files deleted."
Remove-Item "$curDir\MACROS\*" -recurse -Include *.log
"log files deleted."
Remove-Item "$curDir\MACROS\*" -recurse -Include *.txt
"txt files deleted."
Remove-Item "$curDir\MACROS\*" -recurse -Include *.msg
"msg files deleted."