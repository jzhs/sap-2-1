
# thisScript should be <project dir>/tools/viv.tcl
variable thisScript [file normalize [info script]]

# thisProject should be <project dir>
variable thisProject [file dirname [file dirname $thisScript]]

puts "Project directory is $thisProject"
puts "Script is $thisScript"
# puts "Called with $argc arguments"
# for {variable i 0} {$i < $argc} {incr i} {
#    puts "  Arg[$i]=[lindex $argv $i]"
# }

variable op [lindex $argv 0]

# puts "op = $op"

if [expr {$op == "sim"}] {
    variable tb [lindex $argv 1]
    puts "Simulate $tb"
    
    # Find all the verilog source files in the project source directory
    set SOURCES_V [glob $thisProject/src/*.v]

    # ... apply xvlog to each of those sources
    for {set i 0} {$i < [llength $SOURCES_V]} {incr i} {
	puts "[lindex $SOURCES_V $i]"
	exec xvlog "[lindex $SOURCES_V $i]"
    }
 
    # Find all the verilog source files in the project testing directory
    set TEST_V [glob $thisProject/test/*.v]

    # ... apply xvlog to each of those sources
    for {set i 0} {$i < [llength $TEST_V]} {incr i} {
	puts "[lindex $TEST_V $i]"
	exec xvlog "[lindex $TEST_V $i]"
    }


    exec xelab -top $tb -snapshot my_snapshot -debug all
    exec xsim my_snapshot -tclbatch $thisProject/tools/xsim_cfg.tcl
    exec xsim --gui my_snapshot.wdb

} elseif [expr {$op == "makebits"}] {
    # Does synthesis and implementation and bitstream write
    variable top [lindex $argv 1]
    puts "Making bitstream $top"
    read_verilog [glob $thisProject/src/*.v]
    read_verilog [glob $thisProject/wrap/$top.v]
    read_xdc [subst $thisProject/wrap/$top.xdc]
    
    synth_design -top $top -part xc7a35tcpg236-1
    write_verilog -force post_synth.v
    
    opt_design
    place_design
    route_design
    report_timing_summary
    write_checkpoint -force top_routed.dcp
    
    write_bitstream -force [subst $top.bit]

    
} elseif [expr {$op == "prog"}] {

    variable top [lindex $argv 1]
    puts "Programming bitstream $top"

    # This stuff is determined by watching what the vivado ide
    # does in its tcl console window.

    # FPGA = xc7a35t_0

    open_hw_manager
    connect_hw_server -allow_non_jtag
    open_hw_target
    current_hw_device [get_hw_devices xc7a35t_0]
    refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xc7a35t_0] 0]
    refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]
    set_property PROBES.FILE {} [get_hw_devices xc7a35t_0]
    set_property FULL_PROBES.FILE {} [get_hw_devices xc7a35t_0]
    set_property PROGRAM.FILE [subst $top.bit] [get_hw_devices xc7a35t_0]
    program_hw_devices [get_hw_devices xc7a35t_0]
    refresh_hw_device [lindex [get_hw_devices xc7a35t_0] 0]

}

