----------------------------------------------------------------------------------
-- Company:		ITESM - IRS 2025
-- Author:           	Andrés Zegales Taborga, Ana Carolina Coronel, Yumee Chung, Adrián Márquez Núñez  
-- Create Date: 	22/04/2025
-- Design Name: 	Mix Columns Testbench
-- Module Name:		Mix Columns Module
-- Target Devices: 	DE10-Lite
-- Description: 	Mix Columns AES - Module
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all; 

entity MixColumns_tb is
end MixColumns_tb;

architecture behavior of MixColumns_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component MixColumns
    port(
        Clk    : in  std_logic;
        Enable : in  std_logic;
        Finish : out std_logic;
        Rst    : in  std_logic;
        TxtIn  : in  std_logic_vector(127 downto 0);
        TxtOut : out std_logic_vector(127 downto 0)
    );
    end component;

    --Inputs
    signal Clk    : std_logic := '0';
    signal Enable : std_logic := '0';
    signal Rst    : std_logic := '0';
    signal TxtIn  : std_logic_vector(127 downto 0) := (others => '0');

    --Outputs
    signal Finish : std_logic;
    signal TxtOut : std_logic_vector(127 downto 0);

    -- Clock period definitions
    constant Clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: MixColumns port map (
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
		  

        -- Test case 1: Standard AES test vector
        TxtIn <= x"d4bf5d30e0b452aeb84111f11e2798e5";
        Enable <= '1';
        wait for Clk_period;
        Enable <= '0';
		  
	wait until Finish = '1';
	wait for Clk_period;
			
        -- Expected output: x"046681e5e0cb199a48f8d37a2806264c"
	-- if the expected output is not generated then the next error message will be sent 
        assert TxtOut = x"046681e5e0cb199a48f8d37a2806264c"
            report "Test case 1 failed" severity error;
        wait for Clk_period*2;
        
        -- End of test
        wait;
    end process;

end architecture;
