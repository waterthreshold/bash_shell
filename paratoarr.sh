#!/usr/bin/env bash
arr=()
let i=0
until [ -z "$1" ];
do
arr[i]=$1
shift 
let i++
done

for j in "${arr[@]}"
do
echo $j
done

####shell prime 

function add2prime (){
    index=$1
    shift
    prime=$1
   prime_list[${index}]=$prime
   let index++
}

function my_basename (){
    pathCURRENT=$1
    basename=${pathCURRENT##*/}
    echo $basename
}

function my_cwd (){
    pathCURRENT=$1
    basename=${pathCURRENT%/*}
    echo $basename
}

declare -a prime_list
prime_list=(2)
index=1
MAX_INT=100
flag=0
for (( i=3 ; i <=$MAX_INT ; i++))
do
     flag=0
    for j in "${prime_list[@]}"
    do
    ans=$(($i%$j))
    if [ $ans -eq 0 ];
    then
        flag=1
        break
    fi
    done
    if [ $flag -eq 0 ];
    then 
        add2prime $index $i
     
     fi
done 

#####print prime 
for prime in ${prime_list[*]}
do
    echo $prime
done 

####shell prime


##shell 
pathCURRENT="/aaa/ccc/bbbb"
root_directory=
var1=$(my_basename $pathCURRENT)
[ "$var1" == bbbb ] && echo basename correct 
var1=$(my_cwd $pathCURRENT)
[ "$var1" == "/aaa/ccc" ] && echo cwd correct 

