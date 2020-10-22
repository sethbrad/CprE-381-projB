-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- n_mux2_1_struct.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit 2:1 mux
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity n_mux2_1 is
  generic(N : integer);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_S  : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));
end n_mux2_1;

architecture dataflow of n_mux2_1 is

begin

o_F <= i_A when i_S = '0' else
       i_B when i_S = '1' else
       (others => '0');

end dataflow;
