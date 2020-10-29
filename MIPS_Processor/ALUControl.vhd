library IEEE;
use IEEE.std_logic_1164.all;

entity ALUControl is
    port(ALUOp   : in std_logic_vector(2 downto 0);
         funct   : in std_logic_vector(5 downto 0);
         shift   : out std_logic;
         control : out std_logic_vector(3 downto 0));
end ALUControl;

architecture behavioral of ALUControl is

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
  "0000" when others;

with ALUOp select control <= 
  "0101" when "000",
  "0000" when "001",
  "0010" when "010",
  "0001" when "011",
  "0110" when "100",
  "1000" when "101",
  functOp when others;

with funct select shift <=
  '1' when "000000",
  '1' when "000010",
  '1' when "000011",
  '0' when others;

end behavioral;