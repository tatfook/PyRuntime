#! /usr/bin/env bash

PYTHON=python3.4
LUA=lua5.1
TEST_FOLDER=./codeblock/
pylua=./run_test.py
luatest=./run_test.lua

pyfile_path=$1

function test_pyfile()
{
    pyfile=$1
    pyluafile=$pyfile.lua
    printf "test python file $pyfile ... "

    $PYTHON $pylua $pyfile > $pyluafile

    $PYTHON $pyfile
    py_exit=$?
    
    $LUA $luatest $pyluafile
    lua_exit=$?

    if [[ $py_it -eq 0 ]] && [[ $lua_exit -eq 0 ]]; then
	printf "success\n"
    else
	printf "fail!!!\n"
    fi

    if [[ $py_exit -ne 0 ]]; then
	cat -n $pyfile
    fi

    if [[ $lua_exit -ne 0 ]]; then
	cat -n $pyluafile
    fi
}

if [[ "$pyfile_path" == "" ]]; then
    for f in ${TEST_FOLDER}*.py
    do
	test_pyfile $f
    done
else
    test_pyfile $pyfile_path
fi

