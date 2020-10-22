library IEEE;
use IEEE.std_logic_1164.all;

entity controlLogic is 
    port(opcode : in std_logic_vector(5 downto 0);
             regDest : out std_logic;
             memToReg : out std_logic;
             ALUOp : out std_logic;
             memWrite : out std_logic;
             ALUSrc : out std_logic_vector(1 downto 0);
             regWrite : out std_logic);
end controlLogic;

architecture behavioral of controlLogic is

begin

    with opcode select ALUSrc <= 
        '0' when "000000",
        '1' when others;
        
    ALUOp <= ALUSrc;

    with opcode select memToReg <= --sll, srl, sra?
        '1' when "000000",
        '1' when "100011", --lw
        '0' when others;
    
    with opcode select memWrite <= 
        '1' when "101011", --sw
        '0' when others;

    regWrite <= not memWrite;

    with opcode select regDest <=
        '1' when "000000",
        '0' when others;

end behavioral;