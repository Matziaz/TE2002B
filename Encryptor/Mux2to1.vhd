----------------------------------------------------------------------------------
-- Company:				ITESM - IRS 2025
-- Author:           Yumee Chung, Ana Coronel, Adrián Márquez, Andrés Zegales
-- Create Date: 		22/04/2025
-- Design Name: 		Mux 2 to 1
-- Module Name:		Mux 2 to 1 Module
-- Target Devices: 	DE10-Lite
-- Description: 		Mux 2 to 1 AES - Module
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Mux2to1 is
  port (
    InA    : in     std_logic_vector(127 downto 0);
    InB    : in     std_logic_vector(127 downto 0);
    MuxOut : out    std_logic_vector(127 downto 0);
    Sel    : in     std_logic);
end entity Mux2to1;

architecture rtl of Mux2to1 is
	begin
	process(Sel, InA, InB)
	begin
		if Sel = '0' then
			MuxOut <= InA;
		else 
			MuxOut <= InB;
		end if; 
	end process;
end architecture rtl;
