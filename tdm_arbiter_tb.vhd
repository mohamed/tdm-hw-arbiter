-- Testbench
-- Author: Mohamed A. Bamakhrama <m.a.m.bamakhrama@liacs.leidenuniv.nl>
-- Copyrights (c) 2009-2014 by Leiden University, The Netherlands

use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library work;
use work.tdm_arbiter_pkg.all;

entity tdm_arbiter_tb is
end tdm_arbiter_tb;

architecture behav of tdm_arbiter_tb is

constant clock_frequency : natural := 400_000_000;
constant clock_period : time := 1000 ms  /clock_frequency;

signal tb_clock : std_logic := '0';
signal tb_reset_n : std_logic := '0'; 

signal tb_hold  : std_logic := '0';
signal tb_exists : std_logic_vector(NUM_OF_FIFOS-1 downto 0) := (others => '0');
signal tb_read : std_logic_vector(NUM_OF_FIFOS-1 downto 0)  := (others => '0');	


begin
	tb_clock <= not tb_clock after clock_period/2;

	uut: tdm_arbiter
	port map
	(
        clk => tb_clock,
        reset_n => tb_reset_n,
        hold => tb_hold,
        exists => tb_exists,
        read => tb_read
	);

	tb: process
	begin
		tb_reset_n <= '0';
		wait for 2*clock_period;
		tb_reset_n <= '1';
		tb_hold <= '0';
		tb_exists <= "0100101000101010";
		wait for 20*clock_period;
		tb_exists <= "1101110000101011";
		wait for 20*clock_period;
		tb_exists <= "1111111111111111";
		wait for 20*clock_period;
		tb_exists <= "1000000000000000";
		wait for 20*clock_period;
		tb_exists <= "0000000000000000";
		wait for 20*clock_period;

		assert false report "Simulation stopped" severity failure;

	end process;
end behav;
