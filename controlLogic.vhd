library IEEE;
use IEEE.std_logic_1164.all;

entity controlLogic is 
    port(opcode : in std_logic_vector(5 downto 0);
             funct : in std_logic_vector(5 downto 0);
             regDest : out std_logic;
             memToReg : out std_logic;
             ALUOp : out std_logic;
             memWrite : out std_logic;
             ALUSrc : out std_logic;
             regWrite : out std_logic);
end controlLogic;

architecture behavioral of controlLogic is

signal regDestIntermediate, ALUSrcSig, memWriteSig : std_logic;

begin

    with opcode select ALUSrcSig <= 
        '0' when "000000",
        '1' when others;
        
    ALUOp <= ALUSrcSig;
    ALUSrc <= ALUSrcSig;

    with opcode select memToReg <= 
        '1' when "001111", --lui
        '1' when "100011", --lw
        '0' when others;
    
    with opcode select memWriteSig <= 
        '1' when "101011", --sw
        '0' when others;

    regWrite <= not memWriteSig;
    memWrite <= memWriteSig;

    with opcode select regDestIntermediate <= --sll, srl, sra?
        '1' when "000000",
        '0' when others;

    with funct select regDest <=
        '0' when "000000", --sll
        '0' when "000010", --srl
        '0' when "000011", --sra
        regDestIntermediate when others;

end behavioral;