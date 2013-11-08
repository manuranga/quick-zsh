search_gg_cmpl(){
    search_st=`cat $ZSH/cache/lastSearchedStr.txt`
    reply=(`find -L -type d -iname '*'$search_st'*'`)
}

search_ggg_cmpl(){
    search_st=`cat $ZSH/cache/lastSearchedStr.txt`
    reply=(`find -L -type f -iname '*'$search_st'*' -printf "%h\n"`)
}

compctl -K search_ggg_cmpl ggg
compctl -K search_gg_cmpl gg

alias ff='find_all_iname'
function find_all_iname(){
    echo $1 > $ZSH/cache/lastSearchedStr.txt
    find -L -iname '*'$1'*' | grep --ignore-case "$1"
}

function gg(){
    cd $1
}

function ggg(){
    cd $1
}
