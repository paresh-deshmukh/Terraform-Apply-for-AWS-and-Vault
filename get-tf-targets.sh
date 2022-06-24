pwd
dirFilter=false

if [ -z $2 ]; then 
    echo "Specific dir to parse the files in a PR not provided"; 
else 
    echo "Files in the dir $2 will be parsed for applying terraform changes"; 
    dirFilter=true
fi

parseTfFile=true

targetString=""
for f in $1; do

    # check if the file present in the dir passed in 
    if [ $dirFilter = true ]; then
        if  [ "$(readlink -f ${f} | xargs dirname)/" = ${PWD}/$2 ]; then
            parseTfFile=true
        else
            parseTfFile=false
            echo "${f} skipped for getting the terraform targets."
        fi
    fi
    
    # parse the file as per inputs provided
    if  [ $parseTfFile = true ]; then
        echo "${f} being processed for getting the terraform targets."
        # Get the resources that have been changed
        resources=`cat  "$f" | egrep  -e 'resource.*.*.*{'  | sed 's/resource//' | sed 's/" \{1,\}"/./' | sed 's/"//g' | sed 's/{//' | sed 's/ //g'`
        for r in $resources; do
            targetString="${targetString} -target=${r}"
        done

        # Get the modules that have been changed 
        modules=`cat  "$f" | egrep -i -B5  -e 'infrastructure-tf-modules.git//helm/team' | egrep -e 'module.*{' | sed 's/{//' | sed 's/ /./' | sed 's/"//g'`

        for m in $modules; do
            targetString="${targetString} -target=${m}"
        done

    fi
done

echo $targetString
