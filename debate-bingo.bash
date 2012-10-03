#!/bin/bash

declare -a terms array

IFS=$'\x0a';

echo $@

if [ $# -lt 1 ]; then
  while read -r line; do  terms+=( "$line" ); done
  
  count=${#terms[@]}

  if [ $count -lt 24 ]; then
    echo "Must have at least 24 entries"
    exit
  fi
  
  mp_command=""
  array_create="string bs[]; "
  mp_command+="$array_create";

  i=1;

  declare -a escape_these=("'" "\"");

  for term in ${terms[@]}; do

    for j in ${escape_these[@]}; do
      term=${term//$j/\\$j}
    done

    mp_command+="bs[$i] := \"$term\"; ";
    let "i+=1";
  done;

  mp_command+=" bsmax := $count; "
  mp_command+="input bbcard"

  command_string="mpost '\\$mp_command'"

  eval $command_string
  
else
  while read -r line; do  terms+=( "$line" ); done < $1
  
  count=${#terms[@]}

  if [ $count -lt 24 ]; then
    echo "Must have at least 24 entries"
    exit
  fi

  command_string=$(printf "mpost '\string file; file := \"%s\"; input debate-bingo;'" $1)

  eval $command_string
  
  if [ $# -eq 2 ]; then
    echo "Generating pdf..."
    eval "ps2pdf debate-bingo.ps $2"
    exit
  fi
fi

eval "ps2pdf debate-bingo.ps"

