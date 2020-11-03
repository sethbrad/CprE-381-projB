library IEEE;
use IEEE.std_logic_1164.all;

entity controlLogic is 
    port(opcode    : in std_logic_vector(5 downto 0);
         functCode : in std_logic_vector(5 downto 0);
         regDest   : out std_logic;
         memToReg  : out std_logic;
         ALUOp     : out std_logic_vector(3 downto 0);
         memWrite  : out std_logic;
         ALUSrc    : out std_logic;
         regWrite  : out std_logic;
         shift     : out std_logic;
         loadUpper : out std_logic;
         signExt   : out std_logic);
end controlLogic;

architecture behavioral of controlLogic is

signal s_memWrite, s_FunctShift : std_logic;
signal s_functOp : std_logic_vector(3 downto 0);

begin

  with functCode select s_functOp <=
    "0101" when "100000",
    "0101" when "100001",
    "0110" when "100010",
    "0110" when "100011",
    "0000" when "100100",
    "0100" when "100111",
    "0010" when "100110",
    "0001" when "100101",
    "0111" when "101010",
    "0111" when "101011",
    "1010" when "000000",
    "1000" when "000010",
    "1001" when "000011",
    "1010" when "000100",
    "1000" when "000110",
    "1001" when "000111",
    "0000" when others;
        
  with opcode select ALUOp <=
    "0101" when "001000",
    "0101" when "001001",
    "0101" when "100011",
    "0101" when "101011",
    "0000" when "001100",
    "0010" when "001110",
    "0001" when "001101",
    "0111" when "001010",
    "0111" when "001011",
    "1010" when "001111",
    s_functOp when "000000",
    "0000" when others;

  with opcode select ALUSrc <= 
    '0' when "000000",
    '1' when others;

  with opcode select memToReg <=
    '0' when "100011", --lw
    '1' when others;
    
  with opcode select s_memWrite <= 
    '1' when "101011", --sw
    '0' when others;

  memWrite <= s_memWrite;
  regWrite <= not s_memWrite;

  with opcode select regDest <=
    '1' when "000000",
    '0' when others;

  with opcode select loadUpper <=
    '1' when "001111",
    '0' when others;

  with functCode select s_FunctShift <=
    '1' when "000000",
    '1' when "000010",
    '1' when "000011",
    '0' when others;

  with opcode select shift <=
    s_FunctShift when "000000",
    '0' when others;

  with opcode select signExt <=
    '1' when "001000",
    '1' when "001001",
    '1' when "100011",
    '1' when "101011",
    '1' when "001010",
    '1' when "001011",
    '0' when others;

end behavioral;