#script prep 
curl -sL $(curl -s "https://api.github.com/repos/tmccombs/hcl2json/releases" | grep "http.*v0.5.0/hcl2json_linux_amd64" | awk '{print $2}' | sed 's|[\"\,]*||g') --output hcl2json
chmod +x ./hcl2json

modulename=$(ls ./.terraform/modules/ | grep -v 'modules' | tr ' ' '\n' | cut -f1 -d"." | uniq)

##check applicaiton variable tf
appvarsfile="../application_variables.tf"
if [[ -f "$appvarsfile" ]]; then
    echo "file exists"
    cp ../application_variables.tf ./
    appvarsjson=$(cat ../application_variables.tf | ./hcl2json)
    appvarsjsonnames=($(jq --raw-output '.[]| keys[]' <<< $appvarsjson))
fi

### deployment variable tf

varsjson=$(cat .terraform/modules/$modulename/variables.tf | ./hcl2json)
variablenames=($(jq --raw-output '.[]| keys[]' <<< $varsjson))
#echo ${variablenames[*]}
test=$(cat << 'EOF'
variable "unmatchablestring123" {}
EOF
)

if [[ -f "$appvarsfile" ]]; then
    #echo ${variablenames[*]}
    echo ${variablenames[@]}
    #echo ${appvarsjsonnames[@]}
    uniquevars=$(echo ${variablenames[@]} ${appvarsjsonnames[@]} | tr ' ' '\n' | sort | uniq -u)
    #echo ${uniquevars[*]}
    echo "1"
else
    uniquevars=${variablenames[*]}
    echo ${uniquevars[*]}
    echo "2"
fi
#echo $uniquevars
for variable in ${uniquevars[*]}
    do
        updatedvariabletext=$(echo $test | sed "s~unmatchablestring123~$variable~g")
        echo $updatedvariabletext >> autovariables.tf
    done 


