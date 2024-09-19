#!/bin/bash

SHOW_MESSAGE (){

  if [[ -z $1 ]]
  then
    echo "I could not find that element in the database."
  else
    echo "The element with atomic number $1 is $2 ($7). It's a $3, with a mass of $4 amu. $2 has a melting point of $5 celsius and a boiling point of $6 celsius."
  fi    

}

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

INPUT=$1

if [[ -z $INPUT ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $INPUT =~ ^[0-9]+$ ]]
  then 
    GET_ELEMENT=$($PSQL "select atomic_number from elements where atomic_number = $INPUT")
  else
    GET_ELEMENT=$($PSQL "select atomic_number from elements where symbol = '$INPUT'")
    if [[ -z $GET_ELEMENT ]]
    then
      GET_ELEMENT=$($PSQL "select atomic_number from elements where name = '$INPUT'")
    fi
  fi

  if [[ -z $GET_ELEMENT ]]
  then
    SHOW_MESSAGE
  else
    ELEMENT_NAME=$($PSQL "select name from elements where atomic_number=$GET_ELEMENT")
    ELEMENT_SYMBOL=$($PSQL "select symbol from elements where atomic_number=$GET_ELEMENT")
    ELEMENT_PROPERTY=$($PSQL "select type_id,atomic_mass,melting_point_celsius,boiling_point_celsius from properties where atomic_number=$GET_ELEMENT")
    echo "$ELEMENT_PROPERTY" | while read TYPE_ID BAR MASS BAR MELT_POINT BAR BOIL_POINT
      do
        TYPE=$($PSQL "select type from types where type_id=$TYPE_ID")
        SHOW_MESSAGE $GET_ELEMENT $ELEMENT_NAME $TYPE $MASS $MELT_POINT $BOIL_POINT $ELEMENT_SYMBOL
      done
  fi  
fi

  


