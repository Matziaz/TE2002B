transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/ferna/Documents/TE2002B/Decryptor/Top.vhd}
vcom -93 -work work {C:/Users/ferna/Documents/TE2002B/Decryptor/SubBytes.vhd}
vcom -93 -work work {C:/Users/ferna/Documents/TE2002B/Decryptor/StateMach.vhd}
vcom -93 -work work {C:/Users/ferna/Documents/TE2002B/Decryptor/ShiftRows.vhd}
vcom -93 -work work {C:/Users/ferna/Documents/TE2002B/Decryptor/Mux2to1.vhd}
vcom -93 -work work {C:/Users/ferna/Documents/TE2002B/Decryptor/MixColumns.vhd}
vcom -93 -work work {C:/Users/ferna/Documents/TE2002B/Decryptor/KeySchedule.vhd}
vcom -93 -work work {C:/Users/ferna/Documents/TE2002B/Decryptor/CyperKey.vhd}
vcom -93 -work work {C:/Users/ferna/Documents/TE2002B/Decryptor/AddRoundKey.vhd}

vcom -93 -work work {C:/Users/ferna/Documents/TE2002B/Decryptor/SubBytes_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  SubBytes_tb

add wave *
view structure
view signals
run 8000 us
