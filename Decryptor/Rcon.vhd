----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:51:27 05/01/2009 
-- Design Name: 
-- Module Name:    Rcon - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Rcon is
	port (
		ColumnIn	: in  STD_LOGIC_VECTOR (3  downto 0);		--4 bytes to sellect between 10 different columns
		DataOut	: out STD_LOGIC_VECTOR (31 downto 0));
end Rcon;

architecture Behavioral of Rcon is

    type Arreglo_Rcon is array (0 to 15) of std_logic_vector (31 downto 0);
    constant Rcon : Arreglo_Rcon := (   x"01000000",x"02000000",x"04000000",x"08000000",x"10000000",
													 x"20000000",x"40000000",x"80000000",x"1b000000",x"36000000",
													 x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",
													 x"00000000");  

begin

	DataOut <= Rcon(conv_integer(ColumnIn));

end Behavioral;

