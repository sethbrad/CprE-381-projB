library IEEE;
use IEEE.std_logic_1164.all;

package mux_pack is
  type Mux32_Input is array (31 downto 0) of std_logic_vector(31 downto 0);
end mux_pack;