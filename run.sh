#!/bin/bash

echo "Run is no working, check back later"
exit 1

dir="$(dirname $0)"

function run_test {
    rm -rf output.*
    filename="$dir/tests/$1"

    echo $filename
    
    outputname="$(dirname $filename)/$(basename $1 .dsn).out"
    svgoutputname="$(dirname $filename)/$(basename $1 .dsn).svg"
    echo Running $filename
    node $dir/../index.js $filename output.svg > output.out 2> output.err
    ERROR=0

    PIXELS=10

    compare -verbose -metric AE "$svgoutputname" "output.svg" > /dev/null 2> output.report - 
    tail -n 5 "output.report" > "output.report.tmp"
    mv "output.report.tmp" "output.report"
    red_pixels=`cat "output.report" | grep red | head -1 | cut -d ":" -f 2 | tr -d " "`
    green_pixels=`cat "output.report" | grep green | head -1 | cut -d ":" -f 2 | tr -d " "`
    blue_pixels=`cat "output.report" | grep blue | head -1 | cut -d ":" -f 2 | tr -d " "`
    alpha_pixels=`cat "output.report" | grep alpha | head -1 | cut -d ":" -f 2 | tr -d " "`
    all_pixels=`cat "output.report" | grep all | head -1 | cut -d ":" -f 2 | tr -d " "`
    # echo "all pixels " "{"$all_pixels"}"
    if test "$all_pixels" != "" && [[ "$all_pixels" -le "$PIXELS" ]];
    then
        cat "$outputname" | sort > output.original.sorted
        cat output.out | sort > output.sorted
        if ! diff --ignore-space-change --side-by-side --suppress-common-lines output.sorted output.original.sorted &> error
        then
            echo "Your output                                                   | Correct output"
            cat error
            ERROR=1
        else
            echo Correct
        fi
    else
        ERROR=1
        if [ "$all_pixels" != "" ];
        then
            echo "Pixels that are different"
            head -10 output.report
        else
            echo "Your SVG file has errors"
            head -10 output.report
            echo "Yout output (last 10 lines)"
            tail -10 output.out
            echo "Yout errors (last 10 lines)"
            tail -10 output.err
        fi
    fi
    rm -rf output.* 
    rm -rf error
    return $ERROR
}

if [ $# -lt 1 ];
then
    echo "Running all tests"
    for folder in $(cd $dir && find tests -mindepth 1 -maxdepth 1 -type d)
    do
        for file in $(cd $dir/$folder && find . -mindepth 1 -maxdepth 2 -type f -name '*.dsn')
        do
            echo file $(basename $folder)/$(basename $file)
            run_test $(basename $folder)/$(basename $file)
        done
    done
else
    run_test $1
fi
