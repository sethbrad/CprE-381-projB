library IEEE;
use IEEE.std_logic_1164.all;

entity ALUControl is
    port(ALUOp : in std_logic;
         funct : in std_logic_vector(5 downto 0);
         opcode : in std_logic_vector(5 downto 0);
         control : out std_logic_vector(3 downto 0));
end ALUControl;

architecture behave of ALUControl is

signal functOp, opcodeFunct : std_logic_vector(3 downto 0);

begin

with funct select functOp <= 
    "0101" when "100000",
    "0101" when "100001",
    "0110" when "000001",
    "0110" when "100011",
    "0000" when "100100",
    "0100" when "100111",
    "0010" when "100110",
    "0001" when "100101",
    "0111" when "101010",
    "0111" when "101011",
    "1000" when "000000",
    "1001" when "000010",
    "1010" when "000011",
    "1000" when "000100",
    "1001" when "000110",
    "1010" when "000111",
    "1111" when others;

with opcode select opcodeFunct <= 
    "0101" when "001000",
    "0101" when "001001",
    "0000" when "001100",
    "0010" when "001110",
    "0001" when "001101",
    "0101" when "100011",
    "0101" when "101011",
    "1000" when "001111",
    "0111" when "001010",
    "0111" when "001011",
    "1111" when others;


    with ALUOp select control <=
        functOp when '0',
        opcodeFunct when '1',
        "0000" when others;

end behave;