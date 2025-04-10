library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_SubBytes is
end entity tb_SubBytes;

architecture testbench of tb_SubBytes is

  -- Component declaration
  component SubBytes is
    port (
      Clk    : in  std_logic;
      Enable : in  std_logic;
      Finish : out std_logic;
      Rst    : in  std_logic;
      TxtIn  : in  std_logic_vector(127 downto 0);
      TxtOut : out std_logic_vector(127 downto 0)
    );
  end component;

  -- Signals to connect to the Unit Under Test (UUT)
  signal Clk    : std_logic := '0';
  signal Enable : std_logic := '0';
  signal Finish : std_logic;
  signal Rst    : std_logic := '0';
  signal TxtIn  : std_logic_vector(127 downto 0) := (others => '0');
  signal TxtOut : std_logic_vector(127 downto 0);

  -- Clock period definition
  constant clk_period : time := 10 ns;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut: SubBytes
    port map (
      Clk    => Clk,
      Enable => Enable,
      Finish => Finish,
      Rst    => Rst,
      TxtIn  => TxtIn,
      TxtOut => TxtOut
    );

  -- Clock generation
  clk_process : process
  begin
    while now < 200 ns loop
      Clk <= '0';
      wait for clk_period / 2;
      Clk <= '1';
      wait for clk_period / 2;
    end loop;
    wait;
  end process;

  -- Stimulus process
  stim_proc: process
  begin
    -- Reset
    Rst <= '1';
    wait for 2 * clk_period;
    Rst <= '0';

    -- Apply test vector
    TxtIn <= x"00112233445566778899AABBCCDDEEFF";  -- Test vector
    Enable <= '1';
    wait for clk_period;

    Enable <= '0';  -- Desactivar para probar efecto del Enable
    wait for 4 * clk_period;

    -- Segundo vector de prueba
    TxtIn <= x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
    Enable <= '1';
    wait for clk_period;

    Enable <= '0';
    wait;

  end process;

end architecture testbench;
