library ieee;
use ieee.std_logic_1164.all;

entity tb_ShiftRows is
end entity;

architecture behavior of tb_ShiftRows is

    signal TxtIn  : std_logic_vector(127 downto 0);
    signal TxtOut : std_logic_vector(127 downto 0);

    component ShiftRows is
        port (
            TxtIn  : in  std_logic_vector(127 downto 0);
            TxtOut : out std_logic_vector(127 downto 0)
        );
    end component;

begin

    UUT: ShiftRows
        port map (
            TxtIn  => TxtIn,
            TxtOut => TxtOut
        );

    stim_proc: process
    begin
        TxtIn <= x"000102030405060708090A0B0C0D0E0F";
        wait for 100 ns;
        wait;
    end process;

end architecture;
