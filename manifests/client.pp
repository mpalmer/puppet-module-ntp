define ntp::client($servers) {
	ntp::config { $name:
		servers => $servers
	}
}
