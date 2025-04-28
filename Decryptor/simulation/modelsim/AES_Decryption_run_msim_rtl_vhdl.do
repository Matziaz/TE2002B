transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/D/ProyQuartus/P19_AES_Decryption_tb_alumnos/Top.vhd}
vcom -93 -work work {C:/D/ProyQuartus/P19_AES_Decryption_tb_alumnos/SubBytesKey.vhd}
vcom -93 -work work {C:/D/ProyQuartus/P19_AES_Decryption_tb_alumnos/StateMach.vhd}
vcom -93 -work work {C:/D/ProyQuartus/P19_AES_Decryption_tb_alumnos/Rcon.vhd}
vcom -93 -work work {C:/D/ProyQuartus/P19_AES_Decryption_tb_alumnos/Mux2to1.vhd}
vcom -93 -work work {C:/D/ProyQuartus/P19_AES_Decryption_tb_alumnos/KeySchedule.vhd}
vcom -93 -work work {C:/D/ProyQuartus/P19_AES_Decryption_tb_alumnos/Keyprocessor.vhd}
vcom -93 -work work {C:/D/ProyQuartus/P19_AES_Decryption_tb_alumnos/Keymem.vhd}
vcom -93 -work work {C:/D/ProyQuartus/P19_AES_Decryption_tb_alumnos/InvSubBytes.vhd}
vcom -93 -work work {C:/D/ProyQuartus/P19_AES_Decryption_tb_alumnos/InvShiftRows.vhd}
vcom -93 -work work {C:/D/ProyQuartus/P19_AES_Decryption_tb_alumnos/GaloisPackage.vhd}
vcom -93 -work work {C:/D/ProyQuartus/P19_AES_Decryption_tb_alumnos/AddRoundKey.vhd}
vcom -93 -work work {C:/D/ProyQuartus/P19_AES_Decryption_tb_alumnos/InvMixColumns.vhd}

vcom -93 -work work {C:/D/ProyQuartus/P19_AES_Decryption_tb_alumnos/Top_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  Top_tb

add wave *
view structure
view signals
run 6000 ns
