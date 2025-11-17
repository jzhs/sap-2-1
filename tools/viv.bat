rem viv.bat

@echo off

set XILINX_VIVADO=C:\Xilinx\Vivado\2024.2
set PATH=%XILINX_VIVADO%\bin;%PATH%


rem MY_TCL is the corresponding tcl script
rem ie remove .bat extension and add .tcl
rem so viv.bat -> viv.tcl

set MY_TCL=%~pn0.tcl


rem Launch vivado to run its tcl interpreter. All batch file
rem args go to the tcl script.
rem Consider removing -notrace while debugging script. 

vivado.bat  -mode batch  -notrace  -source %MY_TCL% -tclargs %*
