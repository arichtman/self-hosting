#!/bin/bash

# Presently not fully working but worth holding on to as it allows for sequence-independent nesting of variable expansions
# TODO: Add a recursion count check - referencing $RANDOM or other nondeterministic things will cause infinite looping.
recurse_environment()
{
    CONTENT=$(<$1)
    eval $CONTENT
    while [ $( echo "$CONTENT" | sha256sum -z | awk '{print $1;}' ) != $( echo "$CONTENT" | envsubst | sha256sum -z | awk '{print $1;}' ) ]
    do
        CONTENT=$( echo "$CONTENT" | envsubst )
        eval "$CONTENT"
    done
    echo "$CONTENT"
}