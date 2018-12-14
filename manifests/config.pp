define ntp::config($source   = undef,
                   $content  = undef,
                   $servers  = undef,
                   $queriers = undef,
                   $monitors = undef) {
	include ntp::core

	$ntp_config_virtual = $::virtual

	if $servers {
		if $source or $content {
			fail("Only one of servers, source, and content may be specified")
		}
		
		$ntp_servers  = maybe_split($servers,  '[\s,]+')
		$ntp_queriers = maybe_split($queriers, '[\s,]+')
		$ntp_monitors = maybe_split($monitors, '[\s,]+')

		case $::operatingsystem {
			"RedHat", "CentOS": {
				$ntp_driftfile = "/var/lib/ntp/drift"
			}
			"Debian": {
				$ntp_driftfile = "/var/lib/ntp/ntp.drift"
			}
			default: {
				fail("Unsupported \$::operatingsystem '${::operatingsystem}'.  PR welcome.")
			}
		}

		if 0 + $::operatingsystemrelease >= 5 {
			$ntp_has_ipv6 = true
		} else {
			$ntp_has_ipv6 = false
		}

		file { "/etc/ntp.conf":
			content => template("ntp/etc/ntp.conf"),
			require => Package["ntp"],
			before  => Service["ntpd"],
			notify  => Service["ntpd"];
		}
	} else {
		if $queriers {
			fail("Cannot specify queriers unless also specifying servers")
		}
		
		if $monitors {
			fail("Cannot specify monitors unless also specifying servers")
		}
		
		if $source and $content {
			fail("source and content may not be specified together")
		}

		if $content {
			file { "/etc/ntp.conf":
				content => $content,
				require => Package["ntp"],
				before  => Service["ntpd"],
				notify  => Service["ntpd"];
			}
		} else {
			$source_ = coalesce($source, "puppet:///host/etc/ntp.conf")
			file { "/etc/ntp.conf":
				source  => $source_,
				require => Package["ntp"],
				before  => Service["ntpd"],
				notify  => Service["ntpd"];
			}
		}
	}
}
