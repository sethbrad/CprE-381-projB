library IEEE;
use IEEE.std_logic_1164.all;

entity ControlLogic is 
    port(i_Opcode      : in std_logic_vector(5 downto 0);
         i_FunctCode   : in std_logic_vector(5 downto 0);
         o_RegDest     : out std_logic;
         o_MemToReg    : out std_logic;
         o_ALUOp       : out std_logic_vector(3 downto 0);
         o_MemWrite    : out std_logic;
         o_ALUSrc      : out std_logic;
         o_RegWrite    : out std_logic;
         o_Shift       : out std_logic;
         o_LoadUpper   : out std_logic;
         o_SignExt     : out std_logic;
         o_BranchEq    : out std_logic;
         o_BranchNeq   : out std_logic;
         o_Jump        : out std_logic;
         o_JumpReg     : out std_logic;
         o_JumpAndLink : out std_logic);
end ControlLogic;

architecture behavioral of ControlLogic is

signal s_FunctOp : std_logic_vector(3 downto 0);

begin

  with i_FunctCode select s_FunctOp <=
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
        
  with i_Opcode select o_ALUOp <=
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
    "0110" when "000100",
    "0110" when "000101",
    s_FunctOp when "000000",
    "0000" when others;

  with i_Opcode select o_ALUSrc <= 
    '0' when "000000",
    '0' when "000100",
    '0' when "000101",
    '1' when others;

  with i_Opcode select o_MemToReg <=
    '0' when "100011", --lw
    '1' when others;
    
  with i_Opcode select o_MemWrite <= 
    '1' when "101011", --sw
    '0' when others;

  o_RegWrite <=
    '0' when i_Opcode = "101011" else
    '0' when i_Opcode = "000100" else
    '0' when i_Opcode = "000101" else
    '0' when i_Opcode = "000010" else
    '0' when i_Opcode= "000000" and i_FunctCode = "001000" else
    '1';

  with i_Opcode select o_RegDest <=
    '1' when "000000",
    '0' when others;

  with i_Opcode select o_LoadUpper <=
    '1' when "001111",
    '0' when others;

  o_Shift <=
    '1' when i_Opcode = "000000" and i_FunctCode = "000000" else
    '1' when i_Opcode = "000000" and i_FunctCode = "000010" else
    '1' when i_Opcode = "000000" and i_FunctCode = "000011" else
    '0';

  with i_Opcode select o_SignExt <=
    '1' when "001000",
    '1' when "001001",
    '1' when "100011",
    '1' when "101011",
    '1' when "001010",
    '1' when "001011",
    '1' when "000100",
    '1' when "000101",
    '0' when others;

  with i_Opcode select o_BranchEq <=
    '1' when "000100",
    '0' when others;

  with i_Opcode select o_BranchNeq <=
    '1' when "000101",
    '0' when others;

  with i_Opcode select o_Jump <=
    '1' when "000010",
    '1' when "000011",
    '0' when others;

  with i_Opcode select o_JumpAndLink <=
    '1' when "000011",
    '0' when others;

  o_JumpReg <=
    '1' when i_Opcode = "000000" and i_FunctCode = "001000" else
    '0';

end behavioral;