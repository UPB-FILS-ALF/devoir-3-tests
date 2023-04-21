#!/bin/bash

javac -cp ./libs/*.jar -sourcepath ./src/main/java/ -d out ./src/main/java/org/example/Main.java
for folder in tests/*
do
    rm -rf "$folder"/*.json
    rm -rf "$folder"/*.out
    for file in "$folder"/*.alf
    do
        echo $file
        java -cp ./libs/gson-2.8.9.jar:./out org.example.Main
#        node ../index.js "$file" "$folder"/$(basename $file .alf).ast.json
    done
done

