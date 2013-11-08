#kill -9 by part of the command line
function killbyname(){
   ps -ef | grep $1 | grep -v grep
   ps -ef | grep $1 | grep -v grep | awk '{print $2}' | xargs kill -9
}

#kill -9 by part of the command line
function killsoftlybyname(){
   ps -ef | grep $1 | grep -v grep
   ps -ef | grep $1 | grep -v grep | awk '{print $2}' | xargs kill
}
