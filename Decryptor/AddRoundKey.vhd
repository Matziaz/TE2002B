library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AddRoundKey is
  port (
    Clk    : in  std_logic;                     -- Reloj del sistema
    Enable : in  std_logic;                     -- Habilitaci�n del m�dulo
    Finish : out std_logic;                     -- Se�al de operaci�n completada
    KeyIn  : in  std_logic_vector(0 to 127);    -- Llave de 128 bits (bit 0 a bit 127)
    Rst    : in  std_logic;                     -- Reset s�ncrono
    TxtIn  : inout std_logic_vector(0 to 127)   -- Texto de entrada/salida (modificado a inout)
  );
end entity AddRoundKey;

architecture data_processing of InvRoundKey is
  -- Se�al interna para el procesamiento
  signal processed_data : std_logic_vector(0 to 127);
begin

  -- Proceso principal de operaci�n XOR
  process (Clk)
  begin
    if rising_edge(Clk) then
      if Rst = '1' then 
        -- Reset limpia todos los bits
        processed_data <= (others => '0');
        Finish <= '0';
      elsif Enable = '1' then
        -- Operaci�n XOR bit a bit
        for i in 0 to 127 loop
          processed_data(i) <= KeyIn(i) xor TxtIn(i);
        end loop;
        Finish <= '1';
      else
        Finish <= '0';
      end if;
    end if;
  end process;

  -- Asignaci�n de la salida al bus inout
  TxtIn <= processed_data when Enable = '1' and Rst = '0' else (others => 'Z');

end architecture data_processing;