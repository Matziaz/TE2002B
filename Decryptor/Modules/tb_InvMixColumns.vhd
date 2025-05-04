library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_InvMixColumns is
end tb_InvMixColumns;

architecture test of tb_InvMixColumns is
  component InvMixColumns
    port (
      Clk     : in  std_logic;
      Enable  : in  std_logic;
      Finish  : out std_logic;
      Rst     : in  std_logic;
      DataIn  : in  std_logic_vector(127 downto 0);
      DataOut : out std_logic_vector(127 downto 0)
    );
  end component;

  signal clk      : std_logic := '0';
  signal enable   : std_logic := '0';
  signal finish   : std_logic;
  signal rst      : std_logic := '0';
  signal data_in  : std_logic_vector(127 downto 0) := (others => '0');
  signal data_out : std_logic_vector(127 downto 0);

  constant CLK_PERIOD : time := 10 ns;
  
  -- Vectores de prueba estándar (NIST FIPS-197)
  constant TEST_VECTOR : std_logic_vector(127 downto 0) := 
    x"046681e5e0cb199a48f8d37a2806264c";
  constant EXPECTED_RESULT : std_logic_vector(127 downto 0) := 
    x"d4bf5d30e0b452aeb84111f11e2798e5";

begin
  uut: InvMixColumns
    port map (
      Clk => clk,
      Enable => enable,
      Finish => finish,
      Rst => rst,
      DataIn => data_in,
      DataOut => data_out
    );

  clk_process: process
  begin
    clk <= '0';
    wait for CLK_PERIOD/2;
    clk <= '1';
    wait for CLK_PERIOD/2;
  end process;

  stim_proc: process
  begin
    -- Reset inicial
    rst <= '1';
    wait for CLK_PERIOD;
    rst <= '0';
    wait for CLK_PERIOD;
    
    -- Test 1: Operación normal
    report "Test 1: Verificación de transformación estándar";
    data_in <= TEST_VECTOR;
    enable <= '1';
    wait until finish = '1';
    wait for CLK_PERIOD/4;
    
    assert data_out = EXPECTED_RESULT
      report "Error en transformación InvMixColumns" severity error;
    
    enable <= '0';
    wait for CLK_PERIOD;
    
    -- Test 2: Verificación con todos ceros
    report "Test 2: Entrada con todos ceros";
    data_in <= (others => '0');
    enable <= '1';
    wait until finish = '1';
    wait for CLK_PERIOD/4;
    
    assert data_out = x"00000000000000000000000000000000"
      report "Error con entrada de ceros" severity error;
    
    enable <= '0';
    wait for CLK_PERIOD;
    
    -- Test 3: Verificación con todos unos
    report "Test 3: Entrada con todos unos";
    data_in <= (others => '1');
    enable <= '1';
    wait until finish = '1';
    wait for CLK_PERIOD/4;
    
    assert data_out = x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
      report "Error con entrada de unos" severity error;
    
    enable <= '0';
    
    report "Testbench completado exitosamente";
    wait;
  end process;
end architecture test;