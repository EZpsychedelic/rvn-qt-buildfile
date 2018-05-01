#!/bin/bash

# Error wrapper
error ()
{
	echo >&2 `tput setaf 1`"[-] FAILED: ${*}"`tput sgr0`
	exit 78
}

# Check for root
check_root ()
{
	if [ $EUID -ne 0 ] ; then
		error "User must be root!"
	fi
}

# Install preliminary repositories
depend ()
{
	if apt-get -y install libevent-dev libboost-all-dev libminiupnpc10 libzmq5 software-properties-common libqrencode3; then
		echo "[+] Repositories installed..."
	else
		echo "Install libevent-dev libboost-all-dev libminiupnpc10 libzmq5 software-properties-common"
		error "Use apt-get -y install libevent-dev libboost-all-dev libminiupnpc10 libzmq5 software-properties-common"
	fi
}

# Install DB repositories
berkleydb ()
{
	if add-apt-repository ppa:bitcoin/bitcoin; then
		echo "[+] BerkleyDB installed successfully"
	else		
		error "Could not install BerkleyDB repositories. Consult latest DB documentation. Version 4 is required."
	fi
}

# Update system
sys_update ()
{
	check_root
	if apt-get update; then
		echo "[+] System Updated with 'apt-get update'"
	else
	error "Run 'sudo apt-get update' and continue with installation"
	fi
}

# And then add BerkelyDB4 dependencies
berkley_new ()
{
	if apt-get -y install libdb4.8-dev libdb4.8++-dev; then
		echo "[+] libdb4.8-dev libdb4.8++-dev added to repositories"
	else
	error "Run 'apt-get update' and 'apt-get -y install libdb4.8-dev libdb4.8++-dev'"
	fi
}

gen_ravend ()
{
	check_root
	sys_update
	depend
	berkleydb
	sys_update
	berkley_new
}

gen_ravend