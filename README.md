This module manages the Network Time Protocol service on Debian and
RHEL/CentOS systems.


# Configuring as an NTP client

The simplest, and most common, mode for configuring a machine with NTP is to
make it an NTP client.  This simply means that the machine connects to a
list of NTP servers and tries to keep its time as close as possible to that
of the servers.  This is very simple to do:

    ntp::client { "ntp":
       servers => "0.pool.ntp.org, 1.pool.ntp.org, 2.pool.ntp.org"
    }

The only required parameter is `servers`, which is either a comma-separated
list, or an array, of server names to use.  If you like to make sure that
your clients are keeping correct time, you can also provide a set of IP
addresses (with optional CIDR netmasks) to allow query and trap access to the
NTP service:

    ntp::client { "ntp":
       servers  => "...",
       monitors => "192.0.2.0/25, 192.0.2.142"
    }


# Configuring the timezone

Whilst not technically an NTP task, it is time management, and having a
"timezone" module seems a little overoptimistic.

    ntp::timezone { "timezone":
       timezone => "Australia/Sydney"
    }
