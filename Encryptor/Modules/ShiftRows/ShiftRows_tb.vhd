library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ShiftRows_tb is
end ShiftRows_tb;

architecture behavior of ShiftRows_tb is

    -- Component Declaration
    component ShiftRows
    port(
        Clk    : in  std_logic;
        Enable : in  std_logic;
        Finish : out std_logic;
        Rst    : in  std_logic;
        TxtIn  : in  std_logic_vector(127 downto 0);
        TxtOut : out std_logic_vector(127 downto 0)
    );
    end component;

    -- Inputs
    signal Clk    : std_logic := '0';
    signal Enable : std_logic := '0';
    signal Rst    : std_logic := '0';
    signal TxtIn  : std_logic_vector(127 downto 0) := (others => '0');

    -- Outputs
    signal Finish : std_logic;
    signal TxtOut : std_logic_vector(127 downto 0);

    -- Clock period
    constant Clk_period : time := 10 ns;

begin

    -- Instantiate Unit Under Test
    uut: ShiftRows port map (
        Clk    => Clk,
        Enable => Enable,
        Finish => Finish,
        Rst    => Rst,
        TxtIn  => TxtIn,
        TxtOut => TxtOut
    );

    -- Clock generation
    Clk_process: process
    begin
        Clk <= '0';
        wait for Clk_period/2;
        Clk <= '1';
        wait for Clk_period/2;
    end process;

    -- Stimulus process (single test case)
    stim_proc: process
    begin
        -- Initialize inputs
        Rst <= '1';
        Enable <= '0';
        TxtIn <= (others => '0');
        wait for Clk_period*2;
        
        -- Release reset
        Rst <= '0';
        wait for Clk_period;
        
        -- Apply test vector
        TxtIn <= X"000102030405060708090A0B0C0D0E0F";
        Enable <= '1';
        wait for Clk_period;
        Enable <= '0';
        
        -- Wait for completion
        wait until Finish = '1';
        wait for Clk_period;
      
        
        report "Test case completed successfully";
        wait;
    end process;

end architecture;
