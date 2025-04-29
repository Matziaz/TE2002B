transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/matia/Documents/TE2002B/PROYECTOS_FINALES/Encryptor_Decryptor/TE2002B/Decryptor/Top.vhd}
vcom -93 -work work {C:/Users/matia/Documents/TE2002B/PROYECTOS_FINALES/Encryptor_Decryptor/TE2002B/Decryptor/SubBytesKey.vhd}
vcom -93 -work work {C:/Users/matia/Documents/TE2002B/PROYECTOS_FINALES/Encryptor_Decryptor/TE2002B/Decryptor/StateMach.vhd}
vcom -93 -work work {C:/Users/matia/Documents/TE2002B/PROYECTOS_FINALES/Encryptor_Decryptor/TE2002B/Decryptor/Rcon.vhd}
vcom -93 -work work {C:/Users/matia/Documents/TE2002B/PROYECTOS_FINALES/Encryptor_Decryptor/TE2002B/Decryptor/Mux2to1.vhd}
vcom -93 -work work {C:/Users/matia/Documents/TE2002B/PROYECTOS_FINALES/Encryptor_Decryptor/TE2002B/Decryptor/KeySchedule.vhd}
vcom -93 -work work {C:/Users/matia/Documents/TE2002B/PROYECTOS_FINALES/Encryptor_Decryptor/TE2002B/Decryptor/Keyprocessor.vhd}
vcom -93 -work work {C:/Users/matia/Documents/TE2002B/PROYECTOS_FINALES/Encryptor_Decryptor/TE2002B/Decryptor/Keymem.vhd}
vcom -93 -work work {C:/Users/matia/Documents/TE2002B/PROYECTOS_FINALES/Encryptor_Decryptor/TE2002B/Decryptor/InvSubBytes.vhd}
vcom -93 -work work {C:/Users/matia/Documents/TE2002B/PROYECTOS_FINALES/Encryptor_Decryptor/TE2002B/Decryptor/InvShiftRows.vhd}
vcom -93 -work work {C:/Users/matia/Documents/TE2002B/PROYECTOS_FINALES/Encryptor_Decryptor/TE2002B/Decryptor/GaloisPackage.vhd}
vcom -93 -work work {C:/Users/matia/Documents/TE2002B/PROYECTOS_FINALES/Encryptor_Decryptor/TE2002B/Decryptor/AddRoundKey.vhd}
vcom -93 -work work {C:/Users/matia/Documents/TE2002B/PROYECTOS_FINALES/Encryptor_Decryptor/TE2002B/Decryptor/InvMixColumns.vhd}

vcom -93 -work work {C:/Users/matia/Documents/TE2002B/PROYECTOS_FINALES/Encryptor_Decryptor/TE2002B/Decryptor/Top_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  Top_tb

add wave *
view structure
view signals
run 6000 ns
