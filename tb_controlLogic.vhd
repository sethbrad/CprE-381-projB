library IEEE;
use IEEE.std_logic_1164.all;

entity tb_controlLogic is 
    port map(opcode: in std_logic_vector(5 downto 0));
end tb_controlLogic;

architecture struct of controlLogic is

component controlLogic is 
    port map(opcode : in std_logic_vector(5 downto 0);
             memRead : out std_logic;
             memToReg : out std_logic;
             ALUOp : out std_logic;
             memWrie : out std_logic;
             ALUSrc : out std_logic;
             RegWrite : out std_logic);
end component;

begin

end struct;