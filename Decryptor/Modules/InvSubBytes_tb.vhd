library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InvSubBytes_tb is
end entity InvSubBytes_tb;

architecture behavior of InvSubBytes_tb is

  -- Component Declaration for the Unit Under Test (UUT)
  component InvSubBytes
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
  uut: InvSubBytes port map (
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
	 
	 Enable <= '1';
	 TxtIn <= x"193DE3BEA0F4E22B9AC68D2AE9F84808";
	 wait for Clk_period*4;
	 
	 Enable <= '0';
	 

--    -- Test case 1: All zeros input
--    TxtIn <= (others => '0');
--    Enable <= '1';
--    wait for Clk_period;
--    Enable <= '0';
--    wait until Finish = '1';
--    wait for Clk_period;
--    report "Test case 1: All zeros input";
--    --report "Output: " & to_hstring(TxtOut);
--    
--    -- Test case 2: Sequential values (00 to FF in first byte, others 00)
--    TxtIn <= x"000000000000000000000000000000" & "00000001";
--    Enable <= '1';
--    wait for Clk_period;
--    Enable <= '0';
--    wait until Finish = '1';
--    wait for Clk_period;
--    report "Test case 2: Input 0x01";
--    --report "Output: " & to_hstring(TxtOut);
--    
--    -- Test case 3: All bytes 0x53
--    TxtIn <= (others => '0');
--    for i in 0 to 15 loop
--      TxtIn((i*8)+7 downto i*8) <= x"53";
--    end loop;
--    Enable <= '1';
--    wait for Clk_period;
--    Enable <= '0';
--    wait until Finish = '1';
--    wait for Clk_period;
--    report "Test case 3: All bytes 0x53";
--    --report "Output: " & to_hstring(TxtOut);
--    
--    -- Test case 4: Random test vector (AES test vector)
--    TxtIn <= x"00102030405060708090a0b0c0d0e0f0";
--    Enable <= '1';
--    wait for Clk_period;
--    Enable <= '0';
--    wait until Finish = '1';
--    wait for Clk_period;
--    report "Test case 4: AES test vector";
--    --report "Output: " & to_hstring(TxtOut);
--    
--    -- Test case 5: Reset during operation
--    TxtIn <= x"00112233445566778899aabbccddeeff";
--    Enable <= '1';
--    wait for Clk_period/2;
--    Rst <= '1';
--    wait for Clk_period;
--    Rst <= '0';
--    Enable <= '0';
--    wait for Clk_period*2;
--    report "Test case 5: Reset during operation";
--    --report "Output should be all zeros: " & to_hstring(TxtOut);
--    
--    -- Test case 6: Enable pulse verification
--    TxtIn <= x"0123456789abcdef0123456789abcdef";
--    Enable <= '1';
--    wait for Clk_period;
--    Enable <= '0';
--    -- Try to change input while not enabled
--    TxtIn <= x"00000000000000000000000000000000";
--    wait until Finish = '1';
--    wait for Clk_period;
--    report "Test case 6: Enable pulse verification";
--    --report "Output should be for previous input: " & to_hstring(TxtOut);
--
--    -- End simulation
--    report "Simulation completed" severity note;

    wait;
  end process;

end architecture behavior;
