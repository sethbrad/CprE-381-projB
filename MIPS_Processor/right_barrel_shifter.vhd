library IEEE;
use IEEE.std_logic_1164.all;

entity right_barrel_shifter is
  port(i_A      : in std_logic_vector(31 downto 0);
       i_Shamt  : in std_logic_vector(4 downto 0);
       i_T      : in std_logic;
       o_F      : out std_logic_vector(31 downto 0));
end right_barrel_shifter;

architecture structure of right_barrel_shifter is

component mux2_1 
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       i_S  : in std_logic;
       o_F  : out std_logic);
end component;

signal s_A1, s_A2, s_A4, s_A8, s_A16, -- No shift inputs
       s_B1, s_B2, s_B4, s_B8, s_B16, -- Shift inputs
       s_F1, s_F2, s_F4, s_F8, s_F16 : std_logic_vector(31 downto 0);

begin

s_A1  <= i_A;
s_A2  <= s_F1;
s_A4  <= s_F2;
s_A8  <= s_F4;
s_A16 <= s_F8;

s_B1  <= (i_A(31) and i_T) & i_A(31 downto 1);
s_B2  <= (1 downto 0  => (i_A(31) and i_T)) & s_F1(31 downto 2);
s_B4  <= (3 downto 0  => (i_A(31) and i_T)) & s_F2(31 downto 4);
s_B8  <= (7 downto 0  => (i_A(31) and i_T)) & s_F4(31 downto 8);
s_B16 <= (15 downto 0 => (i_A(31) and i_T)) & s_F8(31 downto 16);

SHIFT_1: for i in 31 downto 0 generate
  s1_mux2_1_i: mux2_1
    port map(i_A  => s_A1(i),
             i_B  => s_B1(i),
             i_S  => i_Shamt(0),
  	     o_F  => s_F1(i));
end generate;

SHIFT_2: for i in 31 downto 0 generate
  s2_mux2_1_i: mux2_1
    port map(i_A  => s_A2(i),
             i_B  => s_B2(i),
             i_S  => i_Shamt(1),
  	     o_F  => s_F2(i));
end generate;

SHIFT_4: for i in 31 downto 0 generate
  s4_mux2_1_i: mux2_1
    port map(i_A  => s_A4(i),
             i_B  => s_B4(i),
             i_S  => i_Shamt(2),
  	     o_F  => s_F4(i));
end generate;

SHIFT_8: for i in 31 downto 0 generate
  s8_mux2_1_i: mux2_1
    port map(i_A  => s_A8(i),
             i_B  => s_B8(i),
             i_S  => i_Shamt(3),
  	     o_F  => s_F8(i));
end generate;

SHIFT_16: for i in 31 downto 0 generate
  s16_mux2_1_i: mux2_1
    port map(i_A  => s_A16(i),
             i_B  => s_B16(i),
             i_S  => i_Shamt(4),
  	     o_F  => s_F16(i));
end generate;

o_F <= s_F16;
  
end structure;
