define ntp::timezone($timezone) {
	file { "/etc/localtime":
		ensure  => "link",
		target  => "/usr/share/zoneinfo/${timezone}",
	}

	# Debian also has a plaintext timezone file
	case $::operatingsystem {
		Debian: {
			file { "/etc/timezone":
				content => "${timezone}\n",
				mode    => 0444;
			}
		}
	}
}
