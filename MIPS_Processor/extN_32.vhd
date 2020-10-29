library IEEE;
use IEEE.std_logic_1164.all;

entity extN_32 is
  -- ctl: 0 = zero extend, 1 = sign extend
  generic(N : integer := 16);
  port(i_Ctl  : in std_logic;			   -- Control bit
       i_in   : in std_logic_vector(N-1 downto 0); -- N bit input
       o_32  : out std_logic_vector(31 downto 0)); -- 32 bit extended output
end extN_32;

architecture structure of extN_32 is

signal s_ext : std_logic_vector(31-N downto 0);

begin
  
s_ext <= (others => i_in(N-1) and i_Ctl);
o_32 <= s_ext & i_in;

end structure;
