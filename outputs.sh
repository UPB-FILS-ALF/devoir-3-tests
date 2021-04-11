#!/bin/bash

for folder in tests/*
do
    rm -rf "$folder"/*.json
    rm -rf "$folder"/*.out
    for file in "$folder"/*.alf
    do
        echo $file
        node ../index.js "$file" "$folder"/$(basename $file .alf).ast.json
    done
done