----------------------------------------------------------------------------------
-- Company: 		 ITESM Campus Queretaro
-- Engineers:		 Eder Gomez, Vicente Noguez 
-- 
-- Create Date:    15:29:21 05/01/2009 
-- Design Name: 
-- Module Name:    RoundKey - Behavioral 
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

entity KeySchedule is
    Port ( Clk     : in   STD_LOGIC;
		     Rst     : in   STD_LOGIC;
			  Enable  : in   STD_LOGIC;
           Sel     : in   STD_LOGIC_VECTOR (3 downto 0);
           KeyIn   : in   STD_LOGIC_VECTOR (127 downto 0);
           Finish  : out  STD_LOGIC;
           KeyOut  : out  STD_LOGIC_VECTOR (127 downto 0));
end KeySchedule;

architecture Behavioral of KeySchedule is

	--Main round key generating unit
	component Keyprocessor
		port(
			Clk	    : in  STD_LOGIC;
			Rst       : in  STD_LOGIC;
			Enable    : in  STD_LOGIC;
			KeyIn     : in  STD_LOGIC_VECTOR (127 downto 0);
			Rcon_data : in  STD_LOGIC_VECTOR (31 downto 0);
			SubR	    : in  STD_LOGIC_VECTOR (31 downto 0);
			WE			 : out STD_LOGIC;
			Finish    : out STD_LOGIC;
			Data_out  : out STD_LOGIC_VECTOR (127 downto 0);
			ColW		 : out STD_LOGIC_VECTOR (3 downto 0);
			Rcon_dir  : out STD_LOGIC_VECTOR (3 downto 0);
			SubW		 : out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	--Memory to read/write keys
	component Keymem
		port(
			ColW	    : in  STD_LOGIC_VECTOR (3 downto 0);		--4 bytes to select between 11 different keys
			DataIn	 : in  STD_LOGIC_VECTOR (127 downto 0);
			Clk		 : in  STD_LOGIC;
			WE			 : in  STD_LOGIC;
			ColR      : in  STD_LOGIC_VECTOR (3 downto 0);
			DataOut	 : out STD_LOGIC_VECTOR (127 downto 0));
	end component;
	
	--Rcon ROM
	component Rcon
		port(
			ColumnIn	: in  STD_LOGIC_VECTOR (3  downto 0);		--4 bytes to select between 10 different columns
			DataOut	: out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	--SubBytes unit
	component SubBytesKey
		port(
			DataIn	: in  STD_LOGIC_VECTOR (31 downto 0);
			DataOut  : out STD_LOGIC_VECTOR (31 downto 0));	
	end component;

	signal we       : STD_LOGIC;
	signal colw     : STD_LOGIC_VECTOR (3 downto 0);
	signal rcondir  : STD_LOGIC_VECTOR (3 downto 0);
	signal rcondata : STD_LOGIC_VECTOR (31 downto 0);
	signal subw	    : STD_LOGIC_VECTOR (31 downto 0);
	signal subr     : STD_LOGIC_VECTOR (31 downto 0);
	signal dataw    : STD_LOGIC_VECTOR (127 downto 0);
	
begin

	U01 : Keyprocessor
	port map(
			Clk	    => Clk,
			Rst		 => Rst,
			Enable    => Enable,
			KeyIn     => KeyIn,
			Rcon_data => rcondata,
			SubR	    => subr,
			WE			 => we,
			Finish    => Finish,
			Data_out  => dataw,
			ColW		 => colw,
			Rcon_dir  => rcondir,
			SubW		 => subw);
	
	U02 : Keymem
	port map(
			ColW   	 => colw,
			DataIn	 => dataw,
			Clk		 => Clk,
			WE			 => we,
			ColR 		 => Sel,
			DataOut	 => KeyOut);
	
	U03 : Rcon
	port map(
			ColumnIn  => rcondir,		
			DataOut	 => rcondata);
	
	U04 : SubBytesKey
	port map(
			DataIn	 => subw,
			DataOut   => subr);	

end Behavioral;

