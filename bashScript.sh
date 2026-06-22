#! /usr/bin/bash

echo "running bash script"
echo "all bash scripts:"


find ~/code -type f -name "*.sh" -exec ls -lh {} \;  # \# -> so find knows which args are for exec and which are for itself

echo ""
echo "files with todo:"
find ~/code -maxdepth 4 -type f -exec grep -l "todo" {} +

if [ "$USER" = "matej" ]; 
then echo "Hello myself";
fi

while ! ping -c 1 google.com > /dev/null; do
  echo "Waiting for internet...";
  sleep 2;
done

echo "Internet is up!"

echo ""
echo "all users:"
for user in $(/usr/bin/users); do
  echo "User: $user"
done