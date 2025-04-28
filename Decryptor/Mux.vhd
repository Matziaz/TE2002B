----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:44:06 05/04/2009 
-- Design Name: 
-- Module Name:    Mux - Behavioral 
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

entity Mux is
    Port ( A 	: in  STD_LOGIC_VECTOR (127 downto 0);
           Sel	: in	STD_LOGIC_VECTOR (4 downto 0);
           B 	: out	STD_LOGIC_VECTOR (7 downto 0));
end Mux;

architecture Behavioral of Mux is

signal d0	: std_logic_vector (7 downto 0);

begin

process (Sel)
begin
	if(Sel = "00001") then
		d0 <= A(127 downto 120);
	elsif(Sel = "00010") then
		d0 <= A(119 downto 112);
	elsif(Sel = "00011") then
		d0 <= A(111 downto 104);
	elsif(Sel = "00100") then
		d0 <= A(103 downto 96);
	elsif(Sel = "00101") then
		d0 <= A(95 downto 88);
	elsif(Sel = "00110") then
		d0 <= A(87 downto 80);
	elsif(Sel = "00111") then
		d0 <= A(79 downto 72);
	elsif(Sel = "01000") then
		d0 <= A(71 downto 64);
	elsif(Sel = "01001") then
		d0 <= A(63 downto 56);
	elsif(Sel = "01010") then
		d0 <= A(55 downto 48);
	elsif(Sel = "01011") then
		d0 <= A(47 downto 40);
	elsif(Sel = "01100") then
		d0 <= A(39 downto 32);
	elsif(Sel = "01101") then
		d0 <= A(31 downto 24);
	elsif(Sel = "01110") then
		d0 <= A(23 downto 16);
	elsif(Sel = "01111") then
		d0 <= A(15 downto 8);
	elsif(Sel = "10000" OR Sel = "10001") then
		d0 <= A(7 downto 0);
	end if;
end process;

B <= d0;

end Behavioral;

