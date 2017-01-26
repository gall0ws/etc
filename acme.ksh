newwindow() {
	winid=`9p read acme/new/ctl | awk '{print $1}'`
}

winctl() {
	echo $@ | 9p write acme/$winid/ctl
}

winread() {
	9p read acme/$winid/$1
}

winwrite() {
	9p write acme/$winid/$1
}

winaddr() {
	9p rdwr acme/$winid/addr | tail -1
}

windump() {
	if [ "$1" != "-" ]; then
		winctl dumpdir $1
	fi

	if [ "$2" != "-" ]; then
		winctl dump $2
	fi
}

winname() {
	winctl name $1
}

winwriteevent() {
	echo $1$2$3 $4 | winwrite event
}

windel() {
	if [ "$1" == "sure" ]; then
		winctl delete
	else
		winctl del
	fi
}

wineventloop() {
	winread event 2>/dev/null | acmeevent | while read line; do $line; done
}
