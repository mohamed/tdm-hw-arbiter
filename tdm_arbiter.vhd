-- TDM with RR Arbiter
-- Author: Mohamed A. Bamakhrama <m.a.m.bamakhrama@liacs.leidenuniv.nl>
-- Copyrights (c) 2009-2014 by Leiden University, The Netherlands

-- Description:
-- This arbiter implements TDM+RR arbitration between active transmitters.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.tdm_arbiter_pkg.all;

entity tdm_arbiter is
port
(
	clk 		: in std_logic;
	reset_n		: in std_logic;

	hold		: in std_logic;
	exists		: in std_logic_vector(NUM_OF_FIFOS-1 downto 0);
	read		: out std_logic_vector(NUM_OF_FIFOS-1 downto 0)
);
end tdm_arbiter;

architecture rtl of tdm_arbiter is

signal grant_r : std_logic_vector(NUM_OF_FIFOS downto 0);
signal grant_i : std_logic_vector(NUM_OF_FIFOS downto 0);
signal grant_hold_i : std_logic_vector(NUM_OF_FIFOS downto 0);
signal bypass : std_logic_vector(NUM_OF_FIFOS downto 0);
signal nored_present : std_logic;


begin
  
	nor_reduc: process(exists)
	begin
		nored_present <= nor_reduce(exists);  
	end process;

	stages: for i in 0 to NUM_OF_FIFOS generate
		x: if i = 0 generate
			grant_i(i) <= grant_r(NUM_OF_FIFOS) or bypass(NUM_OF_FIFOS) when exists(i) = '1' else '0';
			bypass(i) <= grant_r(NUM_OF_FIFOS) or bypass(NUM_OF_FIFOS) when exists(i) = '0' else '0';
		end generate;
		y: if i > 0 and i < NUM_OF_FIFOS generate
			grant_i(i) <= grant_r(i - 1) or bypass(i - 1) when exists(i) = '1' else '0';
			bypass(i) <= grant_r(i - 1) or bypass(i - 1) when exists(i) = '0' else '0';
		end generate;
		z: if i = NUM_OF_FIFOS generate
			grant_i(i) <= grant_r(i - 1) or bypass(i - 1) when nored_present = '1' else '0';
			bypass(i) <= grant_r(i - 1) or bypass(i - 1) when nored_present = '0' else '0';
		end generate;
	end generate;

	read <= grant_r(NUM_OF_FIFOS-1 downto 0) and exists;
	grant_hold_i <= grant_r when (hold = '1') else grant_i;

	registers: process(clk, reset_n)
	begin
		if (reset_n = '0') then
			grant_r <= (NUM_OF_FIFOS => '1', others => '0');
		elsif rising_edge(clk) then
			grant_r <= grant_hold_i;
		end if;
	end process;
end rtl;





