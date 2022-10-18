val=$(ddcutil getvcp 10 --bus 2 --nodetect --terse)
val=${val#*C }
val=${val% *}
val=$(( val - 5 ))
ddcutil setvcp 10 "$val" --bus 2 --nodetect --noverify
