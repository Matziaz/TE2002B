library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

package aes_pkg is
    subtype word is STD_LOGIC_VECTOR(31 downto 0);
    type word_array is array(0 to 43) of word; -- AES-128 genera 44 palabras

    function SubWord(w: word) return word;
    function RotWord(w: word) return word;
    function Rcon(i: integer) return word;
end package;

package body aes_pkg is
    function SubWord(w: word) return word is
    begin
        -- Aquí puedes integrar tu implementación de SubBytes para cada byte
        return w; -- Placeholder
    end;

    function RotWord(w: word) return word is
    begin
        return w(23 downto 0) & w(31 downto 24); -- Rotación de bytes
    end;

    function Rcon(i: integer) return word is
        variable rc: STD_LOGIC_VECTOR(7 downto 0);
    begin
        -- Tabla de Rcon simplificada (solo 10 entradas necesarias para AES-128)
        case i is
            when 1 => rc := x"01";
            when 2 => rc := x"02";
            when 3 => rc := x"04";
            when 4 => rc := x"08";
            when 5 => rc := x"10";
            when 6 => rc := x"20";
            when 7 => rc := x"40";
            when 8 => rc := x"80";
            when 9 => rc := x"1B";
            when 10 => rc := x"36";
            when others => rc := x"00";
        end case;
        return rc & x"00" & x"00" & x"00";
    end;
end package body;