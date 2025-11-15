
# The project directory is passed in via tclargs. Normalize to unix-style.
set PROJ [file normalize [lindex $argv 0]]

# Find all the verilog source files in the project source directory
set SOURCES_V [glob $PROJ/src/*.v]

# Apply xvlog to each of those sources
for {set i 0} {$i < [llength $SOURCES_V]} {incr i} {
    puts "[lindex $SOURCES_V $i]"
    exec xvlog "[lindex $SOURCES_V $i]"
}
 


# Find all the verilog source files in the project testing directory
set TEST_V [glob $PROJ/test/*.v]

# Apply xvlog to each of those sources
for {set i 0} {$i < [llength $TEST_V]} {incr i} {
    puts "[lindex $TEST_V $i]"
    exec xvlog "[lindex $TEST_V $i]"
}


exec xelab -top tb_clock -snapshot my_snapshot -debug all
exec xsim my_snapshot -tclbatch $PROJ/tools/xsim_cfg.tcl
exec xsim --gui my_snapshot.wdb

