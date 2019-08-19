#!/usr/bin/env bash

for i in `ls -d Sepi*/`
  do
    cd  $i/Assembler ; cat *err | grep "FAIL\|fail\|Fail\|ERROR\|error\|Error" >> failure_catch.log ; cd ../..
    cd  $i/cgMLSTFinder ; cat *err | grep "FAIL\|fail\|Fail\|ERROR\|error\|Error" >> failure_catch.log ; cd ../..
    cd  $i/ContigAnalyzer ; cat *err | grep "FAIL\|fail\|Fail\|ERROR\|error\|Error" >> failure_catch.log ; cd ../..
    cd  $i/KmerFinder ; cat *err | grep "FAIL\|fail\|Fail\|ERROR\|error\|Error" >> failure_catch.log ; cd ../..
    cd  $i/MLST ; cat *err | grep "FAIL\|fail\|Fail\|ERROR\|error\|Error" >> failure_catch.log ; cd ../..
    cd  $i/ResFinder ; cat *err | grep "FAIL\|fail\|Fail\|ERROR\|error\|Error" >> failure_catch.log ; cd ../..
  done

echo "script ran successfully" >> failure_catch.log

exit
