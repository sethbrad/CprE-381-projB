library IEEE;
use IEEE.std_logic_1164.all;

entity fullALU_shifter is
  port(i_a         : in std_logic_vector(31 downto 0);
       i_b         : in std_logic_vector(31 downto 0);
       i_s         : in std_logic_vector(3 downto 0);
       o_F         : out std_logic_vector(31 downto 0);
       o_cOut      : out std_logic;
       o_Overflow  : out std_logic;
       o_Zero      : out std_logic);
end fullALU_shifter;

architecture structure of fullALU_shifter is

component fullALU
  port(a         : in std_logic_vector(31 downto 0);
       b         : in std_logic_vector(31 downto 0);
       s         : in std_logic_vector(2 downto 0);
       F         : out std_logic_vector(31 downto 0);
       cOut      : out std_logic;
       overflow  : out std_logic;
       zero      : out std_logic);
end component;

component barrel_shifter 
  port(i_A      : in std_logic_vector(31 downto 0);
       i_Shamt  : in std_logic_vector(4 downto 0);
       i_Ctl    : in std_logic_vector(1 downto 0);
       o_F      : out std_logic_vector(31 downto 0));
end component;

signal s_FALU, s_Fshift : std_logic_vector(31 downto 0);

begin

ALU: fullALU
port map(a        => i_a,
         b        => i_b,
         s        => i_s(2 downto 0),
         F        => s_FALU,
         cOut     => o_cOut,
         overflow => o_Overflow,
         zero     => o_Zero);

SHIFTER: barrel_shifter
port map(i_A      => i_b,
         i_Shamt  => i_a(4 downto 0),
         i_Ctl    => i_s(1 downto 0),
         o_F      => s_Fshift);

with i_s(3) select
  o_F <= s_FALU when '0',
         s_Fshift when '1',
         (others => '0') when others;
  
end structure;
