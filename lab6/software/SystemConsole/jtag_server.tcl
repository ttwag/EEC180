# -----------------------------------------------------------------
# jtag_server_cmds.tcl
#
# 9/14/2011 D. W. Hawkins (dwh@ovro.caltech.edu)
#
# Altera JTAG socket server Tcl commands.
#
# The JTAG server provides remote hardware access/control functions
# to clients.
#
# The server accept Tcl string commands from the client, issues the
# command to the hardware, and then returns any response data
# to the client.
#
# -----------------------------------------------------------------
# Notes:
# ------
#
# 1. To use the commands via a console, use:
#
#    quartus_stp -s
#    tcl> source jtag_server_cmds.tcl
#
#    This same procedure can be used with SystemConsole
#
# 2. When this script is run under quartus_stp, it requires
#    the package: altera_jtag_to_avalon_stp.
#
#    The package contains Tcl scripts for accessing
#    JTAG-to-Avalon-ST/MM bridges from quartus_stp.
#
#    See jtag_server.tcl for how to load the package.
#
# -----------------------------------------------------------------
# References
# ----------
#
# 1. Brent Welch, "Practical Programming in Tcl and Tk",
#    3rd Ed, 2000.
#
# -----------------------------------------------------------------

# =================================================================
# Tool detection
# =================================================================
#
# The server can be run from either quartus_stp or SystemConole.
#
# Tcl usually allows you to detect the toolname using
# 'info nameofexecutable', however, under SystemConsole this
# is an empty string. In other cases, the global argv0
# holds the application name, but under the Quartus Tcl console
# there is no argv0! However, nameofexecutable does work there,
proc has_fileevent {} {
	if {[string compare [info command fileevent] "fileevent"] == 0} {
		return 1
	} else {
		return 0
	}
}

proc jtag_open {{index 0}} {
	global jtag

	# Close any open service
	if {[info exists jtag(master)]} {
		close_service master $jtag(master)
	}
	# Get the list of masters
	set masters [get_service_paths master]
	if {[llength $masters] == 0} {
		error "Error: No JTAG-to-Avalon-MM device found!"
	}
	# Access the first master in the masters list
	set jtag(master) [lindex $masters $index]
	open_service master $jtag(master)
	return
}

proc jtag_close {} {
	global jtag
	if {[info exists jtag(master)]} {
		close_service master $jtag(master)
		unset jtag(master)
	}
	return
}

proc jtag_read {addr bytes} {
	global jtag
	# Check the argument is a valid value by reformatting
	# the address as an 8-bit hex value
	set addr [expr {$addr & 0xFFFFFFFF}]
	if {[catch {format "0x%.8X" $addr} addr]} {
		error "Error: Invalid address\n -> '$addr'"
	}
	if {![info exists jtag(master)]} {
		jtag_open
	}
	if {[catch {master_read_memory $jtag(master) $addr $bytes} result]} {
		# JTAG connection lost?
		jtag_close
		error "Error: Check the JTAG interface\n -> '$result'"
	}
	return $result
}

proc jtag_read_32 {addr words} {
	global jtag
	# Check the argument is a valid value by reformatting
	# the address as an 8-bit hex value
	set addr [expr {$addr & 0xFFFFFFFF}]
	if {[catch {format "0x%.8X" $addr} addr]} {
		error "Error: Invalid address\n -> '$addr'"
	}
	if {![info exists jtag(master)]} {
		jtag_open
	}
	if {[catch {master_read_32 $jtag(master) $addr $words} result]} {
		# JTAG connection lost?
		jtag_close
		error "Error: Check the JTAG interface\n -> '$result'"
	}
	return $result
}


proc jtag_write {addr args} {
	global jtag
	set addr [expr {$addr & 0xFFFFFFFF}]
	if {[catch {format "0x%.8X" $addr} addr]} {
		error "Error: Invalid address\n -> '$addr'"
	}

	if {![info exists jtag(master)]} {
		jtag_open
	}

	if {[catch {master_write_memory $jtag(master) $addr $args} result]} {
		# JTAG connection lost?
		jtag_close
		error "Error: Check the JTAG interface\n -> '$result'"
	}
	return
}

proc jtag_write_32 {addr args} {
	global jtag
	set addr [expr {$addr & 0xFFFFFFFF}]
	if {[catch {format "0x%.8X" $addr} addr]} {
		error "Error: Invalid address\n -> '$addr'"
	}

	if {![info exists jtag(master)]} {
		jtag_open
	}

	if {[catch {master_write_32 $jtag(master) $addr $args} result]} {
		# JTAG connection lost?
		jtag_close
		error "Error: Check the JTAG interface\n -> '$result'"
	}
	return
}

# Start the server on the specified port
proc server_listen {port} {
	global jtag
	if {[catch {socket -server server_accept $port} result]} {
		exit
	}
	set jtag(port)   $port
	set jtag(socket) $result
	return
}

# Server client-accept callback
proc server_accept {client addr port} {

    # Connections not originating from local-host will be terminated.
    if {$addr != "127.0.0.1"} {
       puts "Rejecting connection from address $addr"
       close $client
       return
    }

	fconfigure $client -buffering line

	# Setup the client handler
	if  {[has_fileevent]} {
		fileevent $client readable [list client_handler $client]
	} else {
		while {![eof $client]} {
			client_handler $client
		}
		puts "SERVER ($client): disconnected"
	}
	return
}

proc client_handler {client} {
	if {[eof $client]} {
		puts "SERVER ($client): disconnected"
		close $client
	} elseif {[catch {gets $client cmd}]} {
		puts "SERVER ($client): error reading a line"
		close $client
	} elseif {[string length $cmd] == 0} {
		# When the client closes a connection, an empty
		# command is generated, followed by EOF
		# (which the SystemConsole loop breaks on)
		puts "SERVER ($client): empty command"
	} else {
		# Execute the command and return the response
		# puts "SERVER ($client): long command"
		if {[catch {eval $cmd} rsp]} {
			# puts "SERVER ($client): Invalid command from the client"
		} else {
			if {[string length $rsp] > 0} {
				# puts "SERVER ($client): long response"
				puts $client $rsp
			}
		}
	}
	return
}

if {![info exists port]} {
	set port 2540
}

# -----------------------------------------------------------------
# Start-up message
# -----------------------------------------------------------------
#
set tool "system console"
puts [format "\nJTAG server running under %s\n" $tool]

if {[has_fileevent]} {
		puts "This version of SystemConsole ([get_version]) supports fileevent."
		puts "The server can support multiple clients.\n"
} else {
		puts "This version of SystemConsole ([get_version]) does not support fileevent."
		puts "The server can only support a single client.\n"
}

puts "Open JTAG to access the JTAG-to-Avalon-MM master\n"
jtag_open

puts "Start the server on port $port\n"
server_listen $port

puts "Wait for clients\n"
vwait forever
