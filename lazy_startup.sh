#!/bin/bash

# execute code and get it's window ID
function launch(){
  $1 &
  PID=$!
  echo "This is PID- $PID "
  sleep 2
  ID=$(wmctrl -l -p | grep $PID | cut -c1-10)
  echo "This is ID - $ID "
}

# launch terminal in a specific directory
launch "gnome-terminal --working-directory=/home"
sleep 0.3

launch "firefox"
# move firefox to workspace #2
wmctrl -ir $ID -t 1
# maximize window
wmctrl -ir $ID -b add,maximized_vert,maximized_horz
sleep 1.2

# launch main Telegram acc
launch "/path/to/telegram"
wmctrl -ir $ID -t 2
wmctrl -ir $ID -b add,maximized_vert,maximized_horz
wmctrl -ir $ID -b remove,maximized_horz
sleep 0.6
# get available screen size
SCREEN_WIDTH=$(xwininfo -root | awk '$1=="Width:" {print $2}')
SCREEN_HEIGHT=$(xwininfo -id $ID | grep Height | tr -d -c 0-9)
HALF_H=$(($SCREEN_HEIGHT / 2))
HALF_W=$(($SCREEN_WIDTH / 2))
# move windows to the right. syntax - <G>,<X>,<Y>,<W>,<H>
wmctrl -i -r $ID -e 0,0,0,"$HALF_W","$SCREEN_HEIGHT"

# launch second Telegram acc
launch "/path/to/telegram -many -workdir /path/to/second/telegram/account"
wmctrl -ir $ID -t 2
wmctrl -ir $ID -b remove,maximized_vert,maximized_horz
sleep 0.2
wmctrl -i -r $ID -e 0,"$HALF_W",0,"$HALF_W","$HALF_H"

# launch third Telegram acc
launch "/path/to/telegram -many -workdir /path/to/third/telegram/account"
wmctrl -ir $ID -t 2
wmctrl -ir $ID -b remove,maximized_vert,maximized_horz
sleep 0.2
wmctrl -i -r $ID -e 0,"$HALF_W","$SCREEN_WIDTH","$HALF_W","$HALF_H"
sleep 1
#focus on terminal
wmctrl -a gnome-terminal
sleep 0.3s
TERMINAL_ID=$( xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}' )
wmctrl -ir $TERMINAL_ID -b add,maximized_vert,maximized_horz
