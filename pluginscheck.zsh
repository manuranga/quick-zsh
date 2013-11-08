function pluginscheck {
    #name of the product e.g: p=wso2esb-4.6.0
    local p=$(echo "${PWD##*/}" | sed -e "s/wso2\([a-z]*\)-\([0-9]\)\.\([0-9]\)\.\([0-9]\).*/wso2\1-\2.\3.\4/g")
    if [ ! -d "../${p}-clean" ]; then
        if [ -f "../${p}.zip" ]; then
            unzip "../${p}.zip" -d "../temp"
            mv "../temp/${p}" "../${p}-clean"
        fi
    fi
    if [ -d "../${p}-clean" ]; then
        diff ./repository/components/plugins/ "../${p}-clean/repository/components/plugins"  | sed -e "s/Binary files \(.*\) and .*/${TEXT_RED}${BOLD}\1${RESET_FORMATTING}/g" \
                                                                                                   -e "s/Files \(.*\) and .*/${TEXT_GREEN}\1${RESET_FORMATTING}/g" \
                                                                                                   -e "/Common subdirectories:.*/d"
    else
        echo "no zip file"
    fi
}
