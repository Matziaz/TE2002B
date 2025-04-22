----------------------------------------------------------------------------------
-- Company:				ITESM - IRS 2025
-- Author:           Emiliano Camacho, Obiel Rangel, Evan Santana, Alfredo Soto 
-- Create Date: 		22/04/2025
-- Design Name: 		Add Round Key
-- Module Name:		Add Round Key Module
-- Target Devices: 	DE10-Lite
-- Description: 		Add Round Key AES - Module
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity AddRoundKey is
  port (
    Clk    : in     std_logic;
    Enable : in     std_logic;
    Finish : out    std_logic;
    KeyIn  : in     std_logic_vector(127 downto 0);
    Rst    : in     std_logic;
    TxtIn  : in     std_logic_vector(127 downto 0);
    TxtOut : out    std_logic_vector(127 downto 0));
end entity AddRoundKey;

architecture rtl of AddRoundKey is
	begin
	-- Clock for control signals
	ApplyKey : process (Clk)
	begin 
		if(rising_edge(Clk)) then
			if(Rst = '1') then 
				TxtOut <= (others => '0');
				Finish <= '0';
			else 
				if(Enable = '1') then 
					-- XOR for Add Round Key
					TxtOut <= KeyIn xor TxtIn;
					Finish <= '1';
				else Finish <= '0';
				
				end if;
			end if;
		end if;		
	end process;
end architecture rtl ;
