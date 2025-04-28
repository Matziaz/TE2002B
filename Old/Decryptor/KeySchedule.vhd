library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.aes_pkg.all;

entity key_schedule_inverse is
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        start    : in  STD_LOGIC;
        key_in   : in  STD_LOGIC_VECTOR(127 downto 0);  -- Llave original (Round 0)
        done     : out STD_LOGIC;                        -- '1' cuando las 11 subllaves están listas
        -- Puerto para leer las subllaves en orden inverso (Round 10 → Round 0)
        round    : in  INTEGER range 0 to 10;            -- Selección de ronda (0=Round 10, 10=Round 0)
        key_out  : out STD_LOGIC_VECTOR(127 downto 0)    -- Subllave seleccionada
    );
end key_schedule_inverse;

architecture Behavioral of key_schedule_inverse is
    -- Almacena las 11 subllaves (Round 0 → Round 10)
    type key_memory is array (0 to 10) of STD_LOGIC_VECTOR(127 downto 0);
    signal subkeys : key_memory := (others => (others => '0'));
    
    -- Señales de control
    signal keys_ready : STD_LOGIC := '0';
begin
    -- Proceso para generar las subllaves
    process(clk, reset)
        variable temp : STD_LOGIC_VECTOR(31 downto 0);
        variable idx : INTEGER range 0 to 43 := 0;
    begin
        if reset = '1' then
            subkeys <= (others => (others => '0'));
            idx := 0;
            keys_ready <= '0';
        elsif rising_edge(clk) then
            if start = '1' and keys_ready = '0' then
                -- Paso 1: Generar todas las subllaves (Round 0 → Round 10)
                if idx = 0 then
                    -- Cargar la llave original (Round 0)
                    subkeys(0) <= key_in;
                    idx := idx + 1;
                elsif idx <= 43 then
                    -- Generar las siguientes subllaves
                    temp := subkeys((idx-1)/4)(31 downto 0);  -- Última palabra de la subllave anterior
                    
                    -- Aplicar RotWord + SubWord + Rcon cada 4 palabras
                    if idx mod 4 = 0 then
                        temp := SubWord(RotWord(temp)) xor Rcon(idx/4);
                    end if;
                    
                    -- Calcular nueva palabra y almacenar
                    temp := temp xor subkeys((idx-4)/4)(31 downto 0);
                    subkeys(idx/4)((idx mod 4)*32 + 31 downto (idx mod 4)*32) <= temp;
                    
                    idx := idx + 1;
                end if;
                
                -- Indicar que todas las subllaves están listas
                if idx = 44 then
                    keys_ready <= '1';
                end if;
            end if;
        end if;
    end process;

    -- Paso 2: Acceso a las subllaves en orden inverso (Round 10 → Round 0)
    key_out <= subkeys(10 - round);  -- Por ejemplo, round=0 devuelve subkeys[10] (Round 10)
    done <= keys_ready;              -- '1' cuando las 11 subllaves están listas
end Behavioral;
