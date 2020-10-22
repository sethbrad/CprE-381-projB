library IEEE;
use IEEE.std_logic_1164.all;

entity ext16_32 is
  -- ctl: 0 = zero extend, 1 = sign extend
  port(i_Ctl  : in std_logic;			   -- Control bit
       i_16   : in std_logic_vector(15 downto 0);  -- 16 bit input
       o_32  : out std_logic_vector(31 downto 0)); -- 32 bit extended output
end ext16_32;

architecture structure of ext16_32 is

signal s_ext : std_logic_vector(15 downto 0);

begin
  
s_ext <= (others => i_16(15) and i_Ctl);
o_32 <= s_ext & i_16;

end structure;
