#!/bin/bash 

#--------------------------------------------------------------
#Written by: Isaree Benjabawornnun
#Created Date: 13 Feb 2023
#Revised Date: 19 Feb 2023
#Overview:
#This script designs to scrape a selected web page:
#https://en.wikipedia.org/wiki/List_of_data_breaches 
#and prepare the output for further data analysis.
#--------------------------------------------------------------

#set variables 
outputfile="data.txt" 
url="https://en.wikipedia.org/wiki/List_of_data_breaches" 
value1="Entity"
value2="References\[edit\]"

#Scrape the web page and save as a raw data file
get_webpage()  {
    curl -o $outputfile $url &>/dev/null
    check_error
}   

#clean the data, leave only what needed in the file
clean_html() { 
    cat $outputfile | sed -e 's/<[^>]*>//g' | 
    sed -n '/'$value1'/,$p' | 
    sed -n '/'"$value2"'/q;p' |
    sed '/\s$/d' > ./temp.txt && cp ./temp.txt $outputfile
} 

#check the content of file while processing 
print_check() { 
    echo "all done!"  
    while read -r check; do
        echo "${check}" 
    done < $outputfile 
} 

#checking for errors 
check_error() { 
    [ $? -ne 0 ] && echo "Error Downloading…" && exit 1
}

#------------------------
#   Run the functions
#------------------------

get_webpage 
clean_html 