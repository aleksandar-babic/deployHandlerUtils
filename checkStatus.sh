#!/usr/bin/env bash

appName=$1
res=$(ps aux | grep -e "$appName" | grep -v grep | awk '{print $2}' | wc -w )

if [ $res -eq 2 ] ; then
   exit 1
else
   exit 0
fi
