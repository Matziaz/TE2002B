--------------------------------------------------------------------------------
--
-- This VHDL file was generated by EASE/HDL 8.4 Revision 4 from HDL Works B.V.
--
-- Ease library  : design
-- HDL library   : design
-- Host name     : R2D2
-- User name     : Arturo
-- Time stamp    : Fri Apr 25 10:47:32 2025
--
-- Designed by   : 
-- Company       : 
-- Project info  : 
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Object        : Entity design.Mux2to1
-- Last modified : Fri May 08 16:43:39 2009
--------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;

entity Mux2to1 is
  port (
    InA    : in     std_logic_vector(127 downto 0);
    InB    : in     std_logic_vector(127 downto 0);
    MuxOut : out    std_logic_vector(127 downto 0);
    Sel    : in     std_logic);
end entity Mux2to1;

--------------------------------------------------------------------------------
-- Object        : Architecture design.Mux2to1.rtl
-- Last modified : Fri May 08 16:43:39 2009
--------------------------------------------------------------------------------


architecture rtl of Mux2to1 is

begin

end architecture rtl ; -- of Mux2to1

