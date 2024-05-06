#!/usr/bin/env zsh

set -ue

function clean_backup() {
	local backupBaseDir="${XDF_CACHE_HOME:-$HOME/.cache}/dotbackup"
	if [[ ! -d "$backupBaseDir" ]]; then
		echo "backup dir is not exists"
		exit 1
	fi

	rm -rf "$backupBaseDir"/*

	echo "all backup dir have been cleaned"
}

clean_backup
