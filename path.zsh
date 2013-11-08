function switch-jdk {
    local old=`echo $JAVA_HOME | awk '{print substr($0,31)}'`
    JAVA_HOME=~/installations/java/$1
    PATH=$JAVA_HOME/bin:$PATH
    export JAVA_HOME
    echo "JAVA_HOME was $old now $1"
}
function list-jdk-versions {
   reply=(`ls -d ~/installations/java/jdk* -t | awk '{print substr($0,31)}'`)
}

compctl -K list-jdk-versions switch-jdk
