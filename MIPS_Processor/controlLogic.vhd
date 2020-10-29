library IEEE;
use IEEE.std_logic_1164.all;

entity controlLogic is 
    port(opcode    : in std_logic_vector(5 downto 0);
         regDest   : out std_logic;
         memToReg  : out std_logic;
         ALUOp     : out std_logic_vector(2 downto 0);
         memWrite  : out std_logic;
         ALUSrc    : out std_logic;
         regWrite  : out std_logic;
         loadUpper : out std_logic);
end controlLogic;

architecture behavioral of controlLogic is

signal s_memWrite : std_logic;

begin

    with opcode select ALUSrc <= 
        '0' when "000000",
        '1' when others;
        
    with opcode select ALUOp <=
        "000" when "001000",
        "000" when "001001",
        "000" when "100011",
        "000" when "101011",
        "001" when "001100",
        "010" when "001110",
        "011" when "001101",
        "100" when "001010",
        "100" when "001011",
        "101" when "001111",
        "110" when others;

    with opcode select memToReg <= --sll, srl, sra?
        '1' when "000000",
        '1' when "100011", --lw
        '0' when others;
    
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

end behavioral;