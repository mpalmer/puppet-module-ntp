class ntp::core {
	package { "ntp": }

	file {
		"/var/lib/ntp":
			ensure  => directory,
			mode    => "0755",
			owner   => "ntp",
			group   => "ntp",
			require => Package["ntp"],
			before  => Service["ntpd"];
		"/etc/ntp/drift":
			ensure  => absent,
			require => Package["ntp"],
			before  => Service["ntpd"];
	}

	case $::operatingsystem {
		"RedHat", "CentOS": {
			if $operatingsystem == "RedHat" and to_i($::operatingsystemrelease) < 4 {
				$sysconfig = "puppet:///modules/ntp/etc/sysconfig/ntpd.4.1"
			} else {
				$sysconfig = "puppet:///modules/ntp/etc/sysconfig/ntpd"
			}
			file { "/etc/sysconfig/ntpd":
				source  => $sysconfig,
				mode    => "0444",
				require => Package["ntp"],
				before  => Service["ntpd"],
				notify  => Service["ntpd"];
			}

			if to_i($::operatingsystemrelease) < 6 {
				file { "/etc/adjtime":
					ensure  => absent,
					require => Package["ntp"],
					before  => Service["ntpd"];
				}
			}

			service { "ntpd":
				ensure     => running,
				enable     => true,
				hasstatus  => true,
				hasrestart => true,
				require    => Package["ntp"],
				subscribe  => Package["ntp"];
			}
		}
		"Debian": {
			file {
				"/etc/default/ntpdate":
					source  => "puppet:///modules/ntp/etc/default/ntpdate",
					mode    => "0444",
					require => Package["ntp"],
					before  => Service["ntpd"],
					notify  => Service["ntpd"];
				"/etc/adjtime":
					ensure  => absent,
					require => Package["ntp"],
					before  => Service["ntpd"];
			}

			service { "ntp":
				ensure     => running,
				enable     => true,
				hasstatus  => true,
				hasrestart => true,
				alias      => "ntpd",
				require    => Package["ntp"],
				subscribe  => Package["ntp"];
			}
		}
		default: {
			fail("Unsupported \$::operatingsystem ${::operatingsystem}.  PR welcome.")
		}
	}
}
