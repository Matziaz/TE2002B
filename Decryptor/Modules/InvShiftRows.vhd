----------------------------------------------------------------------------------
-- Company: 
-- Engineers: Arturo Urías y Equipo, versión 2 
-- 
-- Create Date:    12:08:56 25/04/2025 
-- Design Name: 
-- Module Name:    InvShiftRows - Behavioral 
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InvShiftRows is
  port (
    Clk    : in     std_logic;
    Enable : in     std_logic;
    Finish : out    std_logic;
    Rst    : in     std_logic;
    TxtIn  : in     std_logic_vector(127 downto 0);
    TxtOut : out    std_logic_vector(127 downto 0)
  );
end entity InvShiftRows;


architecture rtl of InvShiftRows is
  signal output_reg             : std_logic_vector(127 downto 0);
begin

  process(Clk, Rst)
  begin
    if Rst = '1' then
      output_reg <= (others => '0');
      Finish <= '0';

    elsif rising_edge(Clk) then
      if Enable = '1' then
        -- Reconstrucción
		 output_reg <= TxtIn(127 downto 120) & TxtIn(23 downto 16) & TxtIn(47 downto 40) & TxtIn(71 downto 64) &
							TxtIn(95 downto 88) & TxtIn(119 downto 112) & TxtIn(15 downto 8) & TxtIn(39 downto 32) &
							TxtIn(63 downto 56) & TxtIn(87 downto 80) & TxtIn(111 downto 104) & TxtIn(7 downto 0) &
							TxtIn(31 downto 24) & TxtIn(55 downto 48) & TxtIn(79 downto 72) & TxtIn(103 downto 96); 
		  
        Finish <= '1';
      else
        Finish <= '0';
      end if;
    end if;
  end process;

  TxtOut <= output_reg;

end architecture rtl;