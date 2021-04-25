#!/bin/bash

dir="$(dirname $0)"

function run_test {
    rm -rf output.*
    filename="$dir/tests/$1"

    # echo $filename
    
    outputname="$(dirname $filename)/$(basename $1 .alf).out"
    astoutputname="$(dirname $filename)/$(basename $1 .alf).ast.json"
    echo Running $filename
    node $dir/../index.js $filename output.ast.json &> $outputname
    ERROR=0

    if node verify.js "$astoutputname" "output.ast.json" &> output.report;
    then
       echo "Correct"
    else
        cat $outputname
        cat output.report
        echo "Your output                                                   | Correct output"
        diff --ignore-space-change --side-by-side --suppress-common-lines "output.ast.json" "$astoutputname"
        ERROR=1
    fi
    rm $outputname
    rm -rf output.* 
    rm -rf error
    return $ERROR
}

if [ $# -lt 1 ];
then
    echo "Running all tests"
    for folder in $(cd $dir && find tests -mindepth 1 -maxdepth 1 -type d | sort)
    do
        for file in $(cd $dir/$folder && find . -mindepth 1 -maxdepth 2 -type f -name '*.alf')
        do
            # echo file $(basename $folder)/$(basename $file)
            run_test $(basename $folder)/$(basename $file)
        done
    done
else
    run_test $1
fi
