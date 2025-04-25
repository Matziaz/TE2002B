transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/ferna/Documents/TE2002B-master/TE2002B-master/Decryptor/Top.vhd}
vcom -93 -work work {C:/Users/ferna/Documents/TE2002B-master/TE2002B-master/Decryptor/SubBytes.vhd}
vcom -93 -work work {C:/Users/ferna/Documents/TE2002B-master/TE2002B-master/Decryptor/StateMach.vhd}
vcom -93 -work work {C:/Users/ferna/Documents/TE2002B-master/TE2002B-master/Decryptor/ShiftRows.vhd}
vcom -93 -work work {C:/Users/ferna/Documents/TE2002B-master/TE2002B-master/Decryptor/Mux2to1.vhd}
vcom -93 -work work {C:/Users/ferna/Documents/TE2002B-master/TE2002B-master/Decryptor/MixColumns.vhd}
vcom -93 -work work {C:/Users/ferna/Documents/TE2002B-master/TE2002B-master/Decryptor/KeySchedule.vhd}
vcom -93 -work work {C:/Users/ferna/Documents/TE2002B-master/TE2002B-master/Decryptor/CyperKey.vhd}
vcom -93 -work work {C:/Users/ferna/Documents/TE2002B-master/TE2002B-master/Decryptor/AddRoundKey.vhd}

vcom -93 -work work {C:/Users/ferna/Documents/TE2002B-master/TE2002B-master/Decryptor/StateMach_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  StateMach_tb

add wave *
view structure
view signals
run 3000 ns
