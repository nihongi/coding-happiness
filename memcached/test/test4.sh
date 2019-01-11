#!/bin/sh
echo "Started ${BASHPID}" >&2

data_get() {
    echo "Called data_get() ${BASHPID}" >&2
    echo -n ${data}
}

data_set() {
    echo "Called data_set() ${BASHPID}" >&2
    data=${1}
}

first_son() {
    echo "Called first_son() ${BASHPID}" >&2
    data_set "123"
}

second_son() {
    echo "Called second_son() ${BASHPID}" >&2
    echo "check2 ${data}" >&2
    echo -n $(data_get)
}

#(first_son)&
#wait
#first_son
dummy=$(first_son)
echo "check ${data}"
echo $(second_son)
