	library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InvMixColumns is
  port (
    Clk     : in  std_logic;
    Enable  : in  std_logic;
    Finish  : out std_logic;
    Rst     : in  std_logic;
    DataIn  : in  std_logic_vector(127 downto 0);
    DataOut : out std_logic_vector(127 downto 0)
  );
end entity InvMixColumns;

architecture Behavioral of InvMixColumns is

	--Multiplicar Byte por 2 numero de veces, teniendo en cuenta las reglas
	function timesTwo (a : std_logic_vector(7 downto 0); b : integer) return std_logic_vector is 
		variable result : std_logic_vector(7 downto 0);
	begin 
		result := a;
		
		for i in 0 to b -1 loop
		if result(7) = '1' then
          result := a(6 downto 0) & '0' xor "00011011";
        else
          result := a(6 downto 0) & '0';
		end if;
		end loop;
	
	return result;
	end function;
	

  -- Función corregida para multiplicación en GF(2^8)
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
  -- (El resto de la arquitectura permanece igual)
  MixColumns_Process: process(Clk)
    variable col0, col1, col2, col3 : std_logic_vector(31 downto 0);
    variable new_col0, new_col1, new_col2, new_col3 : std_logic_vector(31 downto 0);
  begin
    if rising_edge(Clk) then
      if Rst = '1' then
        DataOut <= (others => '0');
        Finish <= '0';
      elsif Enable = '1' then
        -- (Implementación del procesamiento de columnas)
        -- ... (código existente)
      end if;
    end if;
  end process;
end architecture Behavioral;