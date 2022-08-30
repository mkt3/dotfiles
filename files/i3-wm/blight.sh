#!/bin/bash

if [ $1 = "up" ]; then
  light -As sysfs/backlight/ddcci7 4
  light -As sysfs/backlight/intel_backlight 4
else
  light -Us sysfs/backlight/ddcci7 4
  light -Us sysfs/backlight/intel_backlight 4
fi
