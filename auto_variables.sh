
appvarsfile="./terraform.tfvars.json"
if [[ -f "$appvarsfile" ]]; then
    echo "1"
    scalrtfvarjson=$(cat ./terraform.tfvars.json)
    scalrtfvarnames=($(jq --raw-output 'keys[]' <<< $scalrtfvarjson))
    cat ${scalrtfvarnames[*]}
    echo "2"
fi

### deployment variable tf
test=$(cat << 'EOF'
variable "unmatchablestring123" {}
EOF
)

for variable in ${scalrtfvarnames[*]}
    do
        updatedvariabletext=$(echo $test | sed "s~unmatchablestring123~$variable~g")
        echo $updatedvariabletext >> autovariables.tf
    done 
