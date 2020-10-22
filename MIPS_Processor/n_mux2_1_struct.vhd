library IEEE;
use IEEE.std_logic_1164.all;

entity n_mux2_1_struct is
  generic(N : integer := 32);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_S  : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));
end n_mux2_1_struct;

architecture structure of n_mux2_1_struct is

component mux2_1
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       i_S  : in std_logic;
       o_F  : out std_logic);
end component;

begin

G1: for i in 0 to N-1 generate
  mux_i: mux2_1
    port map(i_A  => i_A(i),
             i_B  => i_B(i),
             i_S  => i_S,
  	     o_F  => o_F(i));
end generate;
  
end structure;
