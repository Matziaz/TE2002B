----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       
-- 
-- Create Date:    18:14:58 05/01/2009 
-- Design Name: 
-- Module Name:    Keymem - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Keymem is
		port(
			ColW	    : in  STD_LOGIC_VECTOR (3 downto 0);		--4 bytes to select between 11 different keys
			DataIn	 : in  STD_LOGIC_VECTOR (127 downto 0);
			Clk		 : in  STD_LOGIC;
			WE			 : in  STD_LOGIC;
			ColR      : in  STD_LOGIC_VECTOR (3 downto 0);
			DataOut	 : out STD_LOGIC_VECTOR (127 downto 0));
end Keymem;

architecture Behavioral of Keymem is

  TYPE Arreglo_Keys is ARRAY (15 downto 0) of STD_LOGIC_VECTOR (127 downto 0);
  signal KEYs: Arreglo_Keys;


begin
	
	-- Writing is synchronous
	process (Clk)
	begin
		if (Clk'event and Clk = '1') then
			if (WE = '1') then
				KEYs(conv_integer(ColW)) <= DataIn;
			end if;
		end if;
	end process;
	
	-- Reading is asynchronous
	DataOut <= KEYs(conv_integer(ColR));

end Behavioral;


