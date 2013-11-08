alias l='ls'
alias r='reset'

alias ack='ack-grep'
alias explore='nautilus . &'
alias :q=exit
alias su='sudo -s'
alias fileserver='python -m SimpleHTTPServer'
alias cleanidea='( ff .iml | xargs rm ) ; ( ff .ipr | xargs rm ) ; ( ff .iws | xargs rm ) ; ( ff .idea | xargs rm -r)'
alias m='mvn clean install -o -Dmaven.test.skip=true -e'
alias mo='mvn clean install -Dmaven.test.skip=true -e'

function findpom(){
    find . -iname pom.xml -exec grep -H --color=auto $1 {} \;
}

