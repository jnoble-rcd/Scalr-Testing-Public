##check applicaiton variable tf
### deployment variable tf
test=$(cat << 'EOF'
variable "unmatchablestring123" {}
EOF
)

appvarsfile="./terraform.tfvars.json"
if [[ -f "$appvarsfile" ]]; then
    echo "1"
    scalrtfvarjson=$(cat ./terraform.tfvars.json)
    scalrtfvarnames=($(jq --raw-output 'keys[]' <<< $scalrtfvarjson))
    echo "2"
    #echo ${variablenames[*]}
    #echo ${appvarsjsonnames[@]}
    if [[ -f "../application.tfvars" ]]; then
        echo "fileexists"
        applicationtfvarnames=$(cat ../application.tfvars | tr ' ' '\n' | sort | uniq -u)
        uniquevars=$(echo ${scalrtfvarnames[@]} ${applicationtfvarnames[@]} | tr ' ' '\n' | sort | uniq -u)
    else
        uniquevars=${scalrtfvarnames[*]}
    fi

fi


for variable in ${uniquevars[*]}
    do
        updatedvariabletext=$(echo $test | sed "s~unmatchablestring123~$variable~g")
        echo $updatedvariabletext >> autovariables.tf
    done 
