#!/bin/zsh

echo "Finding passcode...";
  result=$(sqlite3 ~/Library/Messages/chat.db 'SELECT text FROM message WHERE datetime(date/1000000000 + 978307200,"unixepoch","localtime") > datetime("now","localtime","-60 second") ORDER BY date DESC LIMIT 1;')

  name="验证码";
  name2="ode";

  if [ ! $result ]; then
      echo "Passcode not found.";
      osascript -e "display notification \"No passcode was received within the past 60 seconds!\" with title \"Passcode not found.\"   ";
  fi

  if [[ "$result" =~ "$name" || "$result" =~ "$name2" ]]; then
      code=`echo $result | grep -m1 -o "\\d\{4,6\}" | head -1`;
      echo "The code is $code";
      echo "$code" | pbcopy;

      osascript -e "display notification \"$code\" with title \"Passcode has been copied!\"";
  fi