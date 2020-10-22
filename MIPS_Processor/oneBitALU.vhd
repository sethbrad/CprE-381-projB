library IEEE;
use IEEE.std_logic_1164.all;

entity oneBitALU is
    port(a : in std_logic;
         b : in std_logic;
         s : in std_logic_vector(2 downto 0);
         less : in std_logic;
         cIn : in std_logic;
         cOut : out std_logic;
         set : out std_logic;
         F : out std_logic);

end oneBitALU;

architecture mixed of oneBitALU is

component fullAdder is
	port(cIn : in std_logic;
		 a : in std_logic;
		 b : in std_logic;
		 sum : out std_logic;
		 cOut : out std_logic);
end component;

component eightToOneMux is
	port(s : in std_logic_vector(2 downto 0);
		 vIn : in std_logic_vector(7 downto 0);
		 F : out std_logic);
end component;

signal muxIn : std_logic_vector(7 downto 0);
signal bIn, adderOut : std_logic;

begin
    muxIn(0) <= a and b;
    muxIn(1) <= a or b;
    muxIn(2) <= a xor b;
    muxIn(3) <= a nand b;
    muxIn(4) <= a nor b;

    -- FA is passively in subtract mode for use with slt
    with s select
    bIn <= b when b"101",
    (not b) when b"110",
    (not b) when others;

    P1: fullAdder port map(cIn, a, bIn, adderOut, cOut);
    
    muxIn(5) <= adderOut;
    muxIn(6) <= adderOut;
    muxIn(7) <= less;

    set <= adderOut;

    P2: eightToOneMux port map(s, muxIn, F);

end mixed;