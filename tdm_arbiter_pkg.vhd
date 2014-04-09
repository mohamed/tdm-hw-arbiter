-- Package library
-- Author: Mohamed A. Bamakhrama <m.a.m.bamakhrama@liacs.leidenuniv.nl>
-- Copyrights (c) 2009-2014 by Leiden University, The Netherlands

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

package tdm_arbiter_pkg is

-----------------------------------------------------------------
-- User-supplied Constants
-----------------------------------------------------------------

constant NUM_OF_FIFOS : natural := 16;

-----------------------------------------------------------------
-- Functions
-----------------------------------------------------------------
function nor_reduce(v : std_logic_vector(NUM_OF_FIFOS-1 downto 0)) return std_logic;  


-----------------------------------------------------------------
-- Components
-----------------------------------------------------------------

component tdm_arbiter
port
(
	clk 		: in std_logic;
	reset_n		: in std_logic;

	hold		: in std_logic;
	exists		: in std_logic_vector(NUM_OF_FIFOS-1 downto 0);
	read		: out std_logic_vector(NUM_OF_FIFOS-1 downto 0)
);    
end component;

end tdm_arbiter_pkg;

package body tdm_arbiter_pkg is

	function nor_reduce(v : std_logic_vector(NUM_OF_FIFOS-1 downto 0)) return std_logic is
	variable r : std_logic := '0';
	begin
		for i in v'range loop
			r := r or v(i);
		end loop;
		return not r;
	end nor_reduce;

end tdm_arbiter_pkg;
