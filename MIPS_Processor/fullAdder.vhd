library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdder is
	port(cIn : in std_logic;
		a : in std_logic;
		b : in std_logic;
		sum : out std_logic;
		cOut : out std_logic);
end fullAdder;

architecture struct of fullAdder is

component andg2 is 
	port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component org2 is
	port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component xorg2 is
	port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

signal aXorB, aAndB, out1AndCin : std_logic;

begin

	s0: xorg2 port map(i_A => a, i_B => b, o_F => aXorB);
	s1: andg2 port map(i_A => a, i_B => b, o_F => aAndB);
	s2: xorg2 port map(i_A => aXorB, i_B => cIn, o_F => sum);
	s3: andg2 port map(i_A => aXorB, i_B => cIn, o_F => out1AndCin);
	s4: org2 port map(i_A => out1AndCin, i_B => aAndB, o_F => cOut);

end struct;
	
