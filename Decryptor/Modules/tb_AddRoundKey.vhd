library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_TEXTIO.all;

entity tb_AddRoundKey is
end tb_AddRoundKey;

architecture Behavioral of tb_AddRoundKey is
    component AddRoundKey
        Port ( TxtIn    : in  STD_LOGIC_VECTOR (127 downto 0);
               KeyIn    : in  STD_LOGIC_VECTOR (127 downto 0);
               TxtOut   : out STD_LOGIC_VECTOR (127 downto 0);
               Enable   : in  STD_LOGIC;
               Clk      : in  STD_LOGIC;
               Rst      : in  STD_LOGIC;
               Finish   : out STD_LOGIC);
    end component;

    signal TxtIn  : STD_LOGIC_VECTOR(127 downto 0) := (others => '0');
    signal KeyIn  : STD_LOGIC_VECTOR(127 downto 0) := (others => '0');
    signal TxtOut : STD_LOGIC_VECTOR(127 downto 0);
    signal Enable : STD_LOGIC := '0';
    signal Clk    : STD_LOGIC := '0';
    signal Rst    : STD_LOGIC := '0';
    signal Finish : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;
    signal test_complete : boolean := false;

begin
    uut: AddRoundKey port map (
        TxtIn => TxtIn,
        KeyIn => KeyIn,
        TxtOut => TxtOut,
        Enable => Enable,
        Clk => Clk,
        Rst => Rst,
        Finish => Finish
    );

    clk_process: process
    begin
        while not test_complete loop
            Clk <= '0';
            wait for CLK_PERIOD/2;
            Clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    stim_proc: process
    begin
        -- Inicialización
        Rst <= '1';
        wait for CLK_PERIOD*2;
        Rst <= '0';
        wait for CLK_PERIOD;
        
        -- Asignar valores de prueba
        TxtIn <= x"3243F6A8885A308D313198A2E0370734";
        KeyIn <= x"2B7E151628AED2A6ABF7158809CF4F3C";
        Enable <= '1';
        
        -- Esperar primer pulso de Finish
        wait until Finish = '1';
        
        -- Desactivar Enable después de completar la operación
        Enable <= '0';
        
        -- Verificar salida
        assert TxtOut = x"193DE3BEA0F4E22B9AC68D2AE9F84808"
            report "AddRoundKey operation failed! Expected: 193DE3BEA0F4E22B9AC68D2AE9F84808"
            severity error;
        
        -- Esperar varios ciclos para verificar que Finish no se reactiva
        wait for CLK_PERIOD*5;
        
        -- Verificar que Finish permanece inactivo
        assert Finish = '0'
            report "Finish se reactivó después de deshabilitar Enable!"
            severity error;
        
        report "Test completed successfully";
        test_complete <= true;
        wait;
    end process;

end Behavioral;