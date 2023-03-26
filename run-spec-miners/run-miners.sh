if [ $# -ne 1 ]; then
    echo "USAGE: bash $0 csv"
    exit
fi

rm -rf ./text-files/*
mkdir ./text-files/
exec < $1
read header
while read line
do
    # Set comma as delimiter
    IFS=','
    #Read the split words into an array based on comma delimiter
    read -a strarr <<< "$line"

    # echo "Project Repo: ${strarr[0]}"
    # echo "Repo SHA: ${strarr[1]}"
    # echo "Name: ${strarr[2]}"

    touch ./text-files/${strarr[2]}.txt
    
    echo "${strarr[0]} ${strarr[1]} ${strarr[2]}" >> ./text-files/${strarr[2]}.txt

    bash bddminer.sh ./text-files/${strarr[2]}.txt
    bash javert.sh ./text-files/${strarr[2]}.txt
done 