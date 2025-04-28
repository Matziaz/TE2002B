----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:45:12 05/04/2009 
-- Design Name: 
-- Module Name:    DeMux - Behavioral 
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

entity DeMux is
    Port ( A 	: in  STD_LOGIC_VECTOR (7 downto 0);
           Sel	: in	STD_LOGIC_VECTOR (4 downto 0);
           B 	: out	STD_LOGIC_VECTOR (127 downto 0));
end DeMux;

architecture Behavioral of DeMux is

signal d0	: std_logic_vector(7 downto 0);
signal d1	: std_logic_vector(7 downto 0);
signal d2	: std_logic_vector(7 downto 0);
signal d3	: std_logic_vector(7 downto 0);
signal d4	: std_logic_vector(7 downto 0);
signal d5	: std_logic_vector(7 downto 0);
signal d6	: std_logic_vector(7 downto 0);
signal d7	: std_logic_vector(7 downto 0);
signal d8	: std_logic_vector(7 downto 0);
signal d9	: std_logic_vector(7 downto 0);
signal dA	: std_logic_vector(7 downto 0);
signal dB	: std_logic_vector(7 downto 0);
signal dC	: std_logic_vector(7 downto 0);
signal dD	: std_logic_vector(7 downto 0);
signal dE	: std_logic_vector(7 downto 0);
signal dF	: std_logic_vector(7 downto 0);

begin

process (Sel)
begin
	if(Sel = "00001") then
	elsif(Sel = "00010") then
		d0 <= A;
	elsif(Sel = "00011") then
		d1 <= A;
	elsif(Sel = "00100") then
		d2 <= A;
	elsif(Sel = "00101") then
		d3 <= A;
	elsif(Sel = "00110") then
		d4 <= A;
	elsif(Sel = "00111") then
		d5 <= A;
	elsif(Sel = "01000") then
		d6 <= A;
	elsif(Sel = "01001") then
		d7 <= A;
	elsif(Sel = "01010") then
		d8 <= A;
	elsif(Sel = "01011") then
		d9 <= A;
	elsif(Sel = "01100") then
		dA <= A;
	elsif(Sel = "01101") then
		dB <= A;
	elsif(Sel = "01110") then
		dC <= A;
	elsif(Sel = "01111") then
		dD <= A;
	elsif(Sel = "10000") then
		dE <= A;
	elsif(Sel = "10001") then
		dF <= A;
	end if;
end process;

B(127 downto 120)	<= d0;
B(119 downto 112)	<= d1;
B(111 downto 104)	<= d2;
B(103 downto 96)	<= d3;
B(95 downto 88)	<= d4;
B(87 downto 80)	<= d5;
B(79 downto 72)	<= d6;
B(71 downto 64)	<= d7;
B(63 downto 56)	<= d8;
B(55 downto 48)	<= d9;
B(47 downto 40)	<= dA;
B(39 downto 32)	<= dB;
B(31 downto 24)	<= dC;
B(23 downto 16)	<= dD;
B(15 downto 8)		<= dE;
B(7 downto 0)		<= dF;

end Behavioral;

