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
preRepo ()
{
	if apt-get -y install libevent-dev libboost-all-dev libminiupnpc10 libzmq5 software-properties-common; then
		echo "[+] Repositories installed..."
	else
		echo "[-] Install: libevent-dev libboost-all-dev libminiupnpc10 libzmq5 software-properties-common"
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

recNew ()
{
	if apt-get update && apt-get -y install libdb4.8-dev libdb4.8++-dev; then
		echo "[+] Connected to CYBERDYNE Servers"
	else
	error "Update system and use 'apt-get -y install libdb4.8-dev libdb4.8++-dev'"
	fi
}

genRepos ()
{
	check_root
	apt-get update
	preRepo
	berkleydb
	recNew
	apt install libqrencode3
}

genRepos
./raven-qt