-- StateMach_driver_tb.vhd
library ieee;
use ieee.std_logic_1164.all;

entity StateMach_tb is
end entity StateMach_tb;

architecture sim of StateMach_tb is

  -- Señales de reloj y reset
  signal Clk    : std_logic := '0';
  signal Rst    : std_logic := '1';

  -- Señales de control de la FSM
  signal SubBytesEn, ShiftRowsEn, MixColumnsEn, AddRoundKeyEn, KeyEn : std_logic;
  signal SubBytesFin, ShiftRowsFin, MixColumnsFin, AddRoundKeyFin, KeyFin : std_logic := '0';
  signal MuxSel : std_logic;

begin

  -- Clock generator: periodo de 20 ns (50 MHz)
  clk_proc: process
  begin
    wait for 10 ns;
    Clk <= not Clk;
  end process;

  -- Instanciación de la FSM bajo prueba
  UUT: entity work.StateMach
    port map (
      Clk            => Clk,
      Rst            => Rst,
      SubBytesEn     => SubBytesEn,    SubBytesFin     => SubBytesFin,
      ShiftRowsEn    => ShiftRowsEn,   ShiftRowsFin    => ShiftRowsFin,
      MixColumnsEn   => MixColumnsEn,  MixColumnsFin   => MixColumnsFin,
      AddRoundKeyEn  => AddRoundKeyEn, AddRoundKeyFin  => AddRoundKeyFin,
      KeyEn          => KeyEn,         KeyFin          => KeyFin,
      MuxSel         => MuxSel
    );

  -- Proceso de estímulos: aplica reset y luego simula cada etapa
  stim_proc: process
  begin
    -- 1) Reset asíncrono
    Rst <= '1';      wait for 25 ns;
    Rst <= '0';      wait for 20 ns;

    -- 2) Ronda inicial (AddRoundKey 0)
    wait until AddRoundKeyEn = '1';
    wait for 20 ns;  AddRoundKeyFin <= '1';
    wait for 20 ns;  AddRoundKeyFin <= '0';

    -- 3) Rondas 1..9
    for i in 1 to 9 loop

      -- InvSubBytes
      wait until SubBytesEn = '1';
      wait for 20 ns;  SubBytesFin <= '1';
      wait for 20 ns;  SubBytesFin <= '0';

      -- InvShiftRows
      wait until ShiftRowsEn = '1';
      wait for 20 ns;  ShiftRowsFin <= '1';
      wait for 20 ns;  ShiftRowsFin <= '0';

      -- InvMixColumns
      wait until MixColumnsEn = '1';
      wait for 20 ns;  MixColumnsFin <= '1';
      wait for 20 ns;  MixColumnsFin <= '0';

      -- AddRoundKey
      wait until AddRoundKeyEn = '1';
      wait for 20 ns;  AddRoundKeyFin <= '1';
      wait for 20 ns;  AddRoundKeyFin <= '0';

    end loop;

    -- 4) Ronda final (sin MixColumns)
    wait until SubBytesEn = '1';
    wait for 20 ns;  SubBytesFin <= '1';
    wait for 20 ns;  SubBytesFin <= '0';

    wait until ShiftRowsEn = '1';
    wait for 20 ns;  ShiftRowsFin <= '1';
    wait for 20 ns;  ShiftRowsFin <= '0';

    wait until AddRoundKeyEn = '1';
    wait for 20 ns;  KeyFin <= '1';
    wait for 20 ns;  KeyFin <= '0';

    -- 5) Fin de simulación
    wait for 50 ns;
    report "Simulación completada. MuxSel=" & std_logic'image(MuxSel);
    wait;
  end process;

end architecture sim;