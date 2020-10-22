library IEEE;
use IEEE.std_logic_1164.all;

entity mux2_1 is
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       i_S  : in std_logic;
       o_F  : out std_logic);
end mux2_1;

architecture dataflow of mux2_1 is

begin

with i_S select
  o_F <= i_A when '0',
         i_B when '1',
         '0' when others;
  
end dataflow;
