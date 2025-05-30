--------------------------------------------------------------------------------
--
-- This VHDL file was generated by EASE/HDL 8.4 Revision 4 from HDL Works B.V.
--
-- Ease library  : design
-- HDL library   : design
-- Host name     : Laptop-Fer
-- User name     : ferna
-- Time stamp    : Mon Apr 07 09:58:08 2025
--
-- Designed by   :   Arturo Balboa, Omar Reyes Barrueta
-- Company       : 
-- Project info  : 
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Object        : Entity design.MixColumns
-- Last modified : 23/04/2025
--------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;

entity MixColumns is
  port (
    Clk    : in     std_logic;
    Enable : in     std_logic;
    Finish : out    std_logic;
    Rst    : in     std_logic;
    TxtIn  : in     std_logic_vector(127 downto 0);
    TxtOut : out    std_logic_vector(127 downto 0));
end entity MixColumns;

--------------------------------------------------------------------------------
-- Object        : Architecture design.MixColumns.rtl
-- Last modified : Fri May 08 16:43:39 2009
--------------------------------------------------------------------------------


architecture Behavioral of MixColumns is

--Multiplica a por 2 n veces
function timesTwo (a : std_logic_vector(7 downto 0); b : integer) return std_logic_vector is 
		variable result : std_logic_vector(7 downto 0);
	begin 
		result := a;
		
		for i in 0 to b -1 loop
		if result(7) = '1' then
          result := (result(6 downto 0) & '0') xor "00011011";
        else
          result := result(6 downto 0) & '0';
		end if;
		end loop;
	
	return result;
	end function;
	

  -- Función corregida para multiplicación en GF(2^8)
  -- No tocar
  -- Por favor
  function gf_mult(a : std_logic_vector(7 downto 0); b : integer) return std_logic_vector is
    variable result : std_logic_vector(7 downto 0);
  begin
    case b is
      when 9 =>  -- Multiplicación por 0x09
			result := timesTwo(a, 3) XOR a; --2^3 + 1 
        
      when 11 => -- Multiplicación por 0x0B
        result := timesTwo(a, 3) xor timesTwo(a,1) xor a; -- 2^3 + 2+1
        
      when 13 => -- Multiplicación por 0x0D
        result := timesTwo(timesTwo(a, 1) xor a,2) xor a; --4*(2+1) + 1
        
      when 14 => -- Multiplicación por 0x0E
			result := timesTwo(timesTwo(a, 1) xor a,2) xor timesTwo(a,1); --4*(2+1) + 2
        
      when others =>
        result := (others => '0');
    end case;
    return result;
  end function;
	
begin

  MixColumns_Process: process(Clk)
    variable col : std_logic_vector(31 downto 0);
    variable new_col : std_logic_vector(31 downto 0);
    variable byte0, byte1, byte2, byte3 : std_logic_vector(7 downto 0);
  begin
    if rising_edge(Clk) then
      if Rst = '1' then
        TxtOut <= (others => '0');
        Finish <= '0';
      elsif Enable = '1' then
        -- Procesar las 4 columnas (de 32 bits cada una)
        for col_num in 0 to 3 loop
          -- Extraer la columna actual
          case col_num is
            when 0 => col := TxtIn(127 downto 96);
            when 1 => col := TxtIn(95 downto 64);
            when 2 => col := TxtIn(63 downto 32);
            when 3 => col := TxtIn(31 downto 0);
            when others => col := (others => '0');
          end case;
          
          -- Extraer los 4 bytes de la columna
          byte0 := col(31 downto 24);
          byte1 := col(23 downto 16);
          byte2 := col(15 downto 8);
          byte3 := col(7 downto 0);
          
          -- Aplicar transformación InvMixColumns a cada byte de la columna
          new_col(31 downto 24) := 
            gf_mult(byte0, 14) xor gf_mult(byte1, 11) xor 
            gf_mult(byte2, 13) xor gf_mult(byte3, 9);
            
          new_col(23 downto 16) := 
            gf_mult(byte0, 9) xor gf_mult(byte1, 14) xor 
            gf_mult(byte2, 11) xor gf_mult(byte3, 13);
            
          new_col(15 downto 8) := 
            gf_mult(byte0, 13) xor gf_mult(byte1, 9) xor 
            gf_mult(byte2, 14) xor gf_mult(byte3, 11);
            
          new_col(7 downto 0) := 
            gf_mult(byte0, 11) xor gf_mult(byte1, 13) xor 
            gf_mult(byte2, 9) xor gf_mult(byte3, 14);
          
          -- Almacenar resultado
          case col_num is
            when 0 => TxtOut(127 downto 96) <= new_col;
            when 1 => TxtOut(95 downto 64) <= new_col;
            when 2 => TxtOut(63 downto 32) <= new_col;
            when 3 => TxtOut(31 downto 0) <= new_col;
            when others => null;
          end case;
        end loop;
        
        Finish <= '1';
      else
        Finish <= '0';
      end if;
    end if;
  end process;

end architecture Behavioral;