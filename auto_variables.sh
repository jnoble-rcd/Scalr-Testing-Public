template=$(cat << 'EOF'
variable "unmatchablestring123" {}
EOF
)

appvarsfile="./terraform.tfvars.json"
if [[ -f "$appvarsfile" ]]; then
    scalrtfvarjson=$(cat ./terraform.tfvars.json)
    scalrtfvarnames=($(jq --raw-output 'keys[]' <<< $scalrtfvarjson))
    if [[ -f "../application.tfvars" ]]; then
        echo "fileexists"
        applicationtfvarnames=$(cat ../application.tfvars |  cut -f1 -d"=" | sort | uniq -u)
        uniquevars=$(echo ${scalrtfvarnames[@]} ${applicationtfvarnames[@]} | tr ' ' '\n' | sort | uniq -u)
        cp ../application.tfvars ./application.auto.tfvars 
    else
        uniquevars=${scalrtfvarnames[*]}
    fi

fi


for variable in ${uniquevars[*]}
    do
        updatedvariabletext=$(echo $template | sed "s~unmatchablestring123~$variable~g")
        echo $updatedvariabletext >> autovariables.tf
    done 
