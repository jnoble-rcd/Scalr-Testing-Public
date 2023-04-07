mn=$(ls ./.terraform/modules/ | grep -v 'modules' | tr ' ' '\n' | cut -f1 -d"." | uniq)
outputs=$(grep "output" .terraform/modules/$mn/outputs.tf)
outputname=(${SUBSTRING=`echo "$outputs" | cut -d'"' -f 2`})
values=$(grep "value" .terraform/modules/$mn/outputs.tf)
valuesname=(${SUBSTRING1=`echo "$values" | cut -d'=' -f 2`})
cp .terraform/modules/$mn/outputs.tf ./
i=0
for output in ${outputname[*]}
do
 findvalue=${valuesname[$i]}
rv=${outputname[$i]}
sed -i  "s~$findvalue~module.$mn.$rv~g" outputs.tf
((i++))
done
