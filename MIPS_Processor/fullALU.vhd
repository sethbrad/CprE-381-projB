library IEEE;
use IEEE.std_logic_1164.all;

entity fullALU is
    port(a : in std_logic_vector(31 downto 0);
         b : in std_logic_vector(31 downto 0);
         s : in std_logic_vector(2 downto 0);
         F : out std_logic_vector(31 downto 0);
         cOut : out std_logic;
         overflow : out std_logic;
         zero : out std_logic);
end fullALU;

architecture structural of fullALU is
    
component oneBitALU is
    port(a : in std_logic;
         b : in std_logic;
         s : in std_logic_vector(2 downto 0);
         less : in std_logic;
         cIn : in std_logic;
         cOut : out std_logic;
         set : out std_logic;
         F : out std_logic);
end component;

signal carries : std_logic_vector(0 to 30);
signal result : std_logic_vector(31 downto 0);
signal slt, cIn0, zeroSig, cOutSig : std_logic;

begin 

-- Passive subtraction for use with slt
with s select
cIn0 <= '0' when b"101",
'1' when b"110",
'1' when others;

    ALU0: oneBitALU
        port map(a => a(0),
                 b => b(0),
                 s => s,
                 less => slt,
                 cIn => cIn0,
                 cOut => carries(0),
                 F => result(0));

G1: for i in 1 to 30 generate
 ALU: oneBitALU
    port map(a => a(i),
             b => b(i),
             s => s,
             less => '0',
             cIn => carries(i-1),
             cOut => carries(i),
             F => result(i));

end generate;

    ALU31: oneBitALU
        port map(a => a(31),
                 b => b(31),
                 s => s,
                 less => '0',
                 cIn => carries(30),
                 cOut => cOutSig,
                 set => slt,
                 F => result(31));

F <= result;
cOut <= cOutSig;
overflow <= (carries(30) xor cOutSig);

-- Checks if any bits in result are 1, then sets zero to low
process(result, zeroSig)
begin
    zeroSig <= '1';
    
    for i in 0 to 31 loop
        if (result(i) = '1') then
            zeroSig <= '0';
        end if;
    end loop;
end process;

zero <= zeroSig;

end structural;