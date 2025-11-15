

@echo off

set XILINX_VIVADO=C:\Xilinx\Vivado\2024.2
set PATH=%XILINX_VIVADO%\bin;%PATH%


rem TOOLS is the directory of this script
rem PROJ is the parent of TOOLS

set TOOLS=%~p0
set PROJ=%~p0..

vivado.bat -mode batch -source %TOOLS%sim.tcl -tclargs %PROJ%
