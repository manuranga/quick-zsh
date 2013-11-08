function gocarbon(){
    if [[ "$#" = "0" ]]; then
        cd  '/home/manu/installations/carbon'
    else
        cd  '/home/manu/installations/carbon/wso2'$1
    fi
}

carbon_cmpl(){
    reply=(`ls -d ~/installations/carbon/wso2*/ -t | awk '{print substr($0,37)}'`)
}

compctl -K carbon_cmpl gocarbon


function rename-as-plugin(){
}

function runcarbon(){
    local current
    current="$PWD"
    while [[ $current != "/" ]] do;
        if [[ -f  "$current/bin/wso2server.sh" ]]; then
            sh "$current/bin/wso2server.sh" $*
            break
        elif [[ -f  "$current/bin/server.sh" ]]; then
            sh "$current/bin/server.sh" $*
            break
        fi
        current=`dirname  $current`
    done
}
alias cclog='sed -e "s/ ERROR \({.*}\) - \(.*\)/[0m [38;5;197m\1[0m\2[38;5;167m/g" -e "s/  WARN \({.*}\) - /[0m [38;5;184m\1[0m/g" -e "s/  INFO \({.*}\) - /[0m [38;5;113m\1[0m/g" -e "s/^TID: //g" -e "s/\[.* \([0-9\:\,]*\)\]/[0m[38;5;237m\1[0m/g"' 

function color-carbon() {
  local INFO_COL="[38;5;113m"
  local ERROR_COL="[38;5;197m"
  local WARN_COL="[38;5;184m"
  local TIME_COL="[38;5;237m"
  local DEBUG_COL="[38;5;183m"
  local EX_COL="[38;5;167m"
  runcarbon $* | sed -e "s/ ERROR \({.*}\) - \(.*\)/${RESET_FORMATTING} ${ERROR_COL}\1${RESET_FORMATTING}\2${EX_COL}/g" \
               -e "s/  WARN \({.*}\) - /${RESET_FORMATTING} ${WARN_COL}\1${RESET_FORMATTING}/g" \
               -e "s/  INFO \({.*}\) - /${RESET_FORMATTING} ${INFO_COL}\1${RESET_FORMATTING}/g" \
               -e "s/ DEBUG \({.*}\) - /${RESET_FORMATTING} ${DEBUG_COL}\1${RESET_FORMATTING}/g" \
               -e "s/^TID: //g" \
               -e "s/\[.* \([0-9\:\,]*\)\]/${RESET_FORMATTING}${TIME_COL}\1${RESET_FORMATTING}/g"

  # Make sure formatting is reset
  echo -ne ${RESET_FORMATTING}
}


alias rr='r && color-carbon'
alias rrr='reset && rr'
alias rro='runcarbon -DosgiConsole'
alias rrd='rr debug 5005'
alias rrm='rr -DmodRefresh=true'
alias rrdo='rr -DosgiConsole debug 5005'
alias rrw='rr -DworkerNode=true'
alias rrwd='rr -DworkerNode=true debug 5005'

alias rrnocolor='runcarbon'
alias rrnoreset='color-carbon'


function renewcarbon {
    local p=$(echo "${PWD##*/}" | sed -e "s/wso2\([a-z]*\)-\([0-9]\)\.\([0-9]\)\.\([0-9]\).*/wso2\1-\2.\3.\4/g")
    local currentfolder="../${PWD##*/}"
    local tempfolder="../${PWD##*/}_renew_temp"
    local newcarbon="${tempfolder}/${p}"
    local zipfile="../${p}.zip"

    rm $tempfolder -rf
    mkdir $tempfolder
    if [ -f $zipfile ]; then
        unzip $zipfile -d $tempfolder
        find -type l \
           -exec rm -f -r $newcarbon/{} \; \
           -exec cp -v --parent -r --preserve=links {}  $newcarbon \;
    fi
    cd $tempfolder
    rm $currentfolder -r
    mv $p $currentfolder
    cd $currentfolder
    rm $tempfolder -r
}

function patchcarbon(){
    temp='/tmp/temp'
    filetemp='/tmp/temp/files'
    unziptemp='/tmp/temp/unzip'
    carbontopatch='/home/manu/installations/carbon/wso2'$1

    if [ -d $filetemp ];
    then
        rm $filetemp -r
        mkdir -p $filetemp
    else
        mkdir -p $filetemp
    fi

    for file in **/*.jar
        #for file in $carbontopatch/repository/components/plugins/*.jar
    do
        if [ -d $unziptemp ];
        then
            rm $unziptemp -r
            mkdir -p $unziptemp
        else
            mkdir -p $unziptemp
        fi

        md5file=`\md5sum $file | sed -e "s/\(.*\)  \(.*\)/\1/g"`

        unzip  -j $file "META-INF/MANIFEST.MF"  -d $unziptemp  >/dev/null 2>&1 

        filename=`basename $file`

        if [ -f "$unziptemp/MANIFEST.MF" ];
        then
            version=`strings "$unziptemp/MANIFEST.MF" | awk 'BEGIN{RS = "\0"} {gsub(/\n /,""); print $0}' | grep "Bundle-Version" | sed -e "s/Bundle-Version: //g" -e "s/;.*//g"`
            name=`strings "$unziptemp/MANIFEST.MF"  | awk 'BEGIN{RS = "\0"} {gsub(/\n /,""); print $0}' | grep "Bundle-SymbolicName" | sed -e  "s/Bundle-SymbolicName: //g" -e "s/;.*//g"`
            #echo "$file as $name.$version.jar"
            newname="${name}_$version.jar"
            renamed=false
            if [ $filename != $newname ];
            then
                renamed=true
            fi
            #cp $file "$filetemp/$newname"
            fileincarbon="$carbontopatch/repository/components/plugins/$newname"
            if [ -f $fileincarbon ];
            then
                md5fileincarbon=`\md5sum $fileincarbon | sed -e "s/\(.*\)  \(.*\)/\1/g"`
                if [ "$md5fileincarbon" = "$md5file" ]; then 
                    copycolor=$TEXT_GREEN
                else
                    copycolor=$TEXT_RED
                fi

                if ($renamed);
                then
                    echo "${copycolor}$md5file $md5fileincarbon $filename copyed as $newname"
                else
                    echo "${copycolor}$md5file $md5fileincarbon $filename copyed"
                fi
                cp "$file" "$fileincarbon" 
            else
                if ($renamed);
                then
                    echo "$md5file -------------------------------- $filename dose not exist in cabon as $newname"
                else
                    echo "$md5file -------------------------------- $filename dose not exist in cabon"
                fi
            fi
        else
            echo "$md5file -------------------------------- $filename has no manifest"
        fi
        echo -n $RESET_FORMATTING

    done

    if [ -d $temp ];
    then
        rm $temp -r
    fi
}

alias mpatchcarbon='m && patchcarbon'

compctl -K carbon_cmpl patchcarbon
compctl -K carbon_cmpl mpatchcarbon
