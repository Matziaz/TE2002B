--------------------------------------------------------------------------------
-- Top.vhd: Integración del Decryptor AES con la FSM de control (StateMach)
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity Top is
  port (
    Clk        : in  std_logic;
    PlainText  : in  std_logic_vector(127 downto 0);
    CypherText : out std_logic_vector(127 downto 0);
    Reset      : in  std_logic
  );
end entity Top;

architecture structure of Top is

  ----------------------------------------------------------------------------
  -- Señales de datos intermedias (bus para AddRoundKey y salidas de los demás)
  ----------------------------------------------------------------------------
  signal u0_TxtBus    : std_logic_vector(127 downto 0);
  signal u1_TxtOut    : std_logic_vector(127 downto 0);
  signal u2_TxtOut    : std_logic_vector(127 downto 0);
  signal u3_TxtOut    : std_logic_vector(127 downto 0);
  signal u4_TxtBus    : std_logic_vector(127 downto 0);
  signal u5_TxtOut    : std_logic_vector(127 downto 0);
  signal u6_TxtOut    : std_logic_vector(127 downto 0);
  signal u7_TxtBus    : std_logic_vector(127 downto 0);

  signal MuxOut       : std_logic_vector(127 downto 0);
  signal KeyOut       : std_logic_vector(127 downto 0);
  signal u11_KeyOut   : std_logic_vector(127 downto 0);

  ----------------------------------------------------------------------------
  -- Señales de control para cada módulo
  ----------------------------------------------------------------------------
  signal AddRoundEn    : std_logic;
  signal u0_Finish     : std_logic;
  signal u4_Finish     : std_logic;
  signal u7_Finish     : std_logic;

  signal SubBytesEn    : std_logic;
  signal u1_Finish     : std_logic;

  signal ShiftRowsEn   : std_logic;
  signal u2_Finish     : std_logic;

  signal MixColumnsEn  : std_logic;
  signal u3_Finish     : std_logic;

  signal SubBytesu5En  : std_logic;
  signal u5_Finish     : std_logic;

  signal ShiftRowsu6En : std_logic;
  signal u6_Finish     : std_logic;

  signal KeyEn         : std_logic;
  signal Finish        : std_logic;  -- de KeySchedule
  signal KeySel        : std_logic_vector(3 downto 0);
  signal MuxSel        : std_logic;

  -- Señal unificada de finish de todas las AddRoundKey
  signal AddRoundKeyFin : std_logic;  -- la señal que el TB maneja
  signal AddRoundFin    : std_logic;  -- OR de u0_Finish, u4_Finish, u7_Finish


  ----------------------------------------------------------------------------
  -- Component declarations (coinciden exactamente con tus .vhd en Decryptor/)
  ----------------------------------------------------------------------------
  component AddRoundKey
    port (
      Clk    : in  std_logic;
      Enable : in  std_logic;
      Finish : out std_logic;
      KeyIn  : in  std_logic_vector(127 downto 0);
      Rst    : in  std_logic;
      TxtIn  : inout std_logic_vector(127 downto 0)
    );
  end component;

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

  component ShiftRows
    port (
      Clk    : in  std_logic;
      Enable : in  std_logic;
      Finish : out std_logic;
      Rst    : in  std_logic;
      TxtIn  : in  std_logic_vector(127 downto 0);
      TxtOut : out std_logic_vector(127 downto 0)
    );
  end component;

  component MixColumns
    port (
      Clk     : in  std_logic;
      Enable  : in  std_logic;
      Finish  : out std_logic;
      Rst     : in  std_logic;
      DataIn  : in  std_logic_vector(127 downto 0);
      DataOut : out std_logic_vector(127 downto 0)
    );
  end component;

  component Mux2to1
    port (
      InA    : in  std_logic_vector(127 downto 0);
      InB    : in  std_logic_vector(127 downto 0);
      MuxOut : out std_logic_vector(127 downto 0);
      Sel    : in  std_logic
    );
  end component;

  component KeySchedule
    port (
      Clk    : in  std_logic;
      Enable : in  std_logic;
      Finish : out std_logic;
      KeyIn  : in  std_logic_vector(127 downto 0);
      KeyOut : out std_logic_vector(127 downto 0);
      Rst    : in  std_logic;
      Sel    : in  std_logic_vector(3 downto 0)
    );
  end component;

  component StateMach
    port (
      Clk             : in  std_logic;
      Rst             : in  std_logic;
      SubBytesEn      : out std_logic;
      SubBytesFin     : in  std_logic;
      ShiftRowsEn     : out std_logic;
      ShiftRowsFin    : in  std_logic;
      MixColumnsEn    : out std_logic;
      MixColumnsFin   : in  std_logic;
      AddRoundKeyEn   : out std_logic;
      AddRoundKeyFin  : in  std_logic;
      KeyEn           : out std_logic;
      KeyFin          : in  std_logic;
      MuxSel          : out std_logic
    );
  end component;

  component CyperKey
    port (
      KeyOut : out std_logic_vector(127 downto 0)
    );
  end component;

begin

  ----------------------------------------------------------------------------
  -- Señal concurrente para unir finishes de AddRoundKey
  ----------------------------------------------------------------------------
  AddRoundFin <= u0_Finish or u4_Finish or u7_Finish;

  ----------------------------------------------------------------------------
  -- Instanciaciones
  ----------------------------------------------------------------------------

  -- Ronda inicial: AddRoundKey sobre PlainText → u0_TxtBus
  u0: AddRoundKey
    port map(
      Clk    => Clk,
      Enable => AddRoundEn,
      Finish => u0_Finish,
      KeyIn  => KeyOut,
      Rst    => Reset,
      TxtIn  => u0_TxtBus
    );

  -- InvSubBytes (ronda 1)
  u1: SubBytes
    port map(
      Clk    => Clk,
      Enable => SubBytesEn,
      Finish => u1_Finish,
      Rst    => Reset,
      TxtIn  => u0_TxtBus,
      TxtOut => u1_TxtOut
    );

  -- InvShiftRows (ronda 1)
  u2: ShiftRows
    port map(
      Clk    => Clk,
      Enable => ShiftRowsEn,
      Finish => u2_Finish,
      Rst    => Reset,
      TxtIn  => u1_TxtOut,
      TxtOut => u2_TxtOut
    );

  -- InvMixColumns (ronda 1)
  u3: MixColumns
    port map(
      Clk     => Clk,
      Enable  => MixColumnsEn,
      Finish  => u3_Finish,
      Rst     => Reset,
      DataIn  => u2_TxtOut,
      DataOut => u3_TxtOut
    );

  -- AddRoundKey (rondas intermedias 2–8)
  u4: AddRoundKey
    port map(
      Clk    => Clk,
      Enable => AddRoundEn,
      Finish => u4_Finish,
      KeyIn  => KeyOut,
      Rst    => Reset,
      TxtIn  => u3_TxtOut  -- inout, ahora sirve de bus
    );

  u5: SubBytes
    port map(
      Clk    => Clk,
      Enable => SubBytesu5En,
      Finish => u5_Finish,
      Rst    => Reset,
      TxtIn  => u4_TxtBus,  -- ojo: aquí debes renombrar u4_TxtBus al mismo bus declara arriba
      TxtOut => u5_TxtOut
    );

  u6: ShiftRows
    port map(
      Clk    => Clk,
      Enable => ShiftRowsu6En,
      Finish => u6_Finish,
      Rst    => Reset,
      TxtIn  => u5_TxtOut,
      TxtOut => u6_TxtOut
    );

  u7: AddRoundKey
    port map(
      Clk    => Clk,
      Enable => AddRoundEn,
      Finish => u7_Finish,
      KeyIn  => KeyOut,
      Rst    => Reset,
      TxtIn  => u6_TxtOut  -- inout
    );

  -- Mux final (ruta intermedia vs final)
  u8: Mux2to1
    port map(
      InA    => u7_TxtBus,  -- renombra u7_TxtBus si es el bus final
      InB    => u4_TxtBus,
      MuxOut => MuxOut,
      Sel    => MuxSel
    );

  -- KeySchedule
  u9: KeySchedule
    port map(
      Clk    => Clk,
      Enable => KeyEn,
      Finish => Finish,
      KeyIn  => u11_KeyOut,
      KeyOut => KeyOut,
      Rst    => Reset,
      Sel    => KeySel
    );

  -- Máquina de estados
  u10: StateMach
    port map(
      Clk             => Clk,
      Rst             => Reset,
      SubBytesEn      => SubBytesEn,
      SubBytesFin     => u1_Finish,
      ShiftRowsEn     => ShiftRowsEn,
      ShiftRowsFin    => u2_Finish,
      MixColumnsEn    => MixColumnsEn,
      MixColumnsFin   => u3_Finish,
      AddRoundKeyEn   => AddRoundEn,
      AddRoundKeyFin  => AddRoundKeyFin,
      KeyEn           => KeyEn,
      KeyFin          => Finish,
      MuxSel          => MuxSel
    );

  -- CyperKey
  u11: CyperKey
    port map(
      KeyOut => u11_KeyOut
    );

end architecture structure;