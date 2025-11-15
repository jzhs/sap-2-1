# sap-2-1
Malvino SAP-2 first attempt



# Backstory

In earlier projects I implemented Malvino's SAP-1 computer
in Verilog for the Basys3 board.

[sap-1-1](https://github.com/jzhs/sap-1-1)

[sap-1-2](https://github.com/jzhs/sap-1-2)

[sap-1-3](https://github.com/jzhs/sap-1-3)


Sap-1-1 and 1-2 were the same except that 1-2 used a microprogrammed
control unit. 

One thing I learned is that flipping little slide switches and reading
LEDs is no way to program anything. I noticed that 
in the Malvino and Brown text hex i/o is part of SAP-2 so I got a
little head start on that:

Sap-1-3 extended sap-1-2 by adding hexadecimal i/o via the onboard
7-segment display and a
[PMOD hexadecimal keypad](https://digilent.com/shop/pmod-kypd-16-button-keypad/)
that I bought.





Now its time to move on to the SAP-2.



# New: SERIAL IO


The first io scheme in sap-1-1 was slider switches and leds on the
Basys3. This was usable for tiny examples only. The second io scheme
in sap-1-3 was to use a hex keypad and 7-segment display. This was a
great improvement. But it still leaves requires too much human
participation.

The next innovation is a serial line. Many electronic devices have
one. And this will allow our sap-2 to communicate with another
computer. So we'll be able to program the sap-2 with by means of a
laptop or desktop. This is similar to programming an Arduino or a
Basys3 dev board from a pc. On the pc you have a full-featured os with
text editor and compiler and everything else you need. It can help you
prepare a program and then transmit it to the target. The point is you
don't have to actually handle the target. 

The [MB] book talks about serial io that is mostly done in software. A
large problem is that you have to have particular timing for
instructions. So you need to know things like "a LDA takes 5 uS" so
that you can go though a loop say 9600 times per second. This makes it
impossible to vary the clock speed or the number of cylces per
instruction. Instead, I will use a more typical UART protocol. As
simple as possible. If we leave all the bells and whistles it should
be straight-forward.



# New: Larger memory

The SAP-1 models all had only 16 bytes of memory. The SAP-2 has an
address space of 65KB. I anticipate a few KB dedicated to ROM and a
few KB dedicated to RAM. Perhaps a few KB could be used for
memory-mapped io experiments.

Having a ROM will make programming different. Under firmware control
we don't have to take control of the bus via RUN/PROG button. 


# New: More instructions

The SAP-2 will have instructions to write to RAM.

Jump and conditional jump instructions. There will be status flags
(Zero and Sign) for these.

Logical instructions

Shift instructions

Call instruction