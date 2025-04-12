library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SubBytes_tb is
end entity SubBytes_tb;

architecture behavior of SubBytes_tb is

  -- Component Declaration for the Unit Under Test (UUT)
  component SubBytes
    port (
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

  -- Clock period definitions
  constant Clk_period : time := 10 ns;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut: SubBytes port map (
    Clk    => Clk,
    Enable => Enable,
    Finish => Finish,
    Rst    => Rst,
    TxtIn  => TxtIn,
    TxtOut => TxtOut
  );

  -- Clock process definitions
  Clk_process : process
  begin
    Clk <= '0';
    wait for Clk_period/2;
    Clk <= '1';
    wait for Clk_period/2;
  end process;

  -- Stimulus process
  stim_proc: process
  begin
    -- Hold reset state for 100 ns
    Rst <= '1';
    wait for 100 ns;
    Rst <= '0';
    wait for Clk_period*2;
	 
    -- Test with an AES example input vector
    Enable <= '1';
    TxtIn <= x"193DE3BEA0F4E22B9AC68D2AE9F84808";
    wait for Clk_period*4;
    
    Enable <= '0';
    wait until Finish = '1';
    wait for Clk_period;
    
    -- Test with all zeros
    wait for Clk_period*2;
    Enable <= '1';
    TxtIn <= x"00000000000000000000000000000000";
    wait for Clk_period*2;
    
    Enable <= '0';
    wait until Finish = '1';
    wait for Clk_period;
    
    -- Test with sequential values
    wait for Clk_period*2;
    Enable <= '1';
    TxtIn <= x"000102030405060708090A0B0C0D0E0F";
    wait for Clk_period*2;
    
    Enable <= '0';
    wait until Finish = '1';
    wait for Clk_period*2;

    -- End simulation
    report "Simulation completed" severity note;
    wait;
  end process;

end architecture behavior;