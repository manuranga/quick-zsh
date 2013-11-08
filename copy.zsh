#alias cpdir='echo -n $PWD | xclip -selection c'
alias copy='xclip -selection c'

function cpdir() {
    local p=$1
    if (( $# == 0 ));then
        if read line;then
            p=$line
        fi
    fi
    if [[ $p == '.'* ]];then
        p=${p[2,-1]}
    fi
    if [[ $p != '/'* ]];then
        p="/$p"
    fi
    echo -n "$PWD$p" | xclip -selection c
}

#alias cpdirlast='fc -s | cpdir'
function cplastasdir() {
    local a
    a=`fc -nl -1`
    eval $a | cpdir
}

function cplast() {
    local a
    a=`fc -nl -1`
    eval $a | copy
}

