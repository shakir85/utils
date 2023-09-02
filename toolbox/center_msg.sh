#!/bin/bash

# Function takes string input and print it in the center
# of the terminal window with lines on the sides of the test.
# Example:
# __________________hello worl_________________
#

print_center() {
  termwidth="$(tput cols)"
  padding="$(printf '%0.1s' -{1..500})"
  printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}
# print_center "info message goes here"

