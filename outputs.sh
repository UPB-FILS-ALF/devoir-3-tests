#!/bin/bash

classpath="./../libs/antlr-4.12.0-complete.jar:./../libs/jackson-annotations-2.15.0-rc3.jar:./../libs/jackson-core-2.15.0-rc3.jar:./../libs/jackson-databind-2.15.0-rc3.jar:./../libs/jackson-module-parameter-names-2.15.0-rc3.jar"
for folder in tests/*
do
    rm -rf "$folder"/*.json
    rm -rf "$folder"/*.out
    for file in "$folder"/*.alf
    do
        echo $file
        java -cp $classpath:./../out org.example.Main $file "$folder"/$(basename $file .alf).ast.json
    done
done

