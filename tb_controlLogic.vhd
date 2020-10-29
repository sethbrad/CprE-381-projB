library IEEE;
use IEEE.std_logic_1164.all;

entity tb_controlLogic is 
    port(opcode : in std_logic_vector(5 downto 0);
         funct : in std_logic_vector(5 downto 0));
end tb_controlLogic;

architecture struct of controlLogic is

component controlLogic is 
    port(opcode : in std_logic_vector(5 downto 0);
	     funct : in std_logic_vector(5 downto 0);
             memRead : out std_logic;
             memToReg : out std_logic;
             ALUOp : out std_logic;
             memWrie : out std_logic;
             ALUSrc : out std_logic;
             regWrite : out std_logic);
end component;

signal opcodeSig, functSig : std_logic_vector(5 downto 0);
signal memReadSig, memToRegSig, ALUOpSig, memWriteSig, ALUSrcSig, regWriteSig : std_logic;

begin
DUT: controlLogic port map(opcodeSig, functSig, memReadSig, memToRegSig, ALUOpSig, memWriteSig, ALUSrcSig, RegWriteSig);

test: process
begin

opcodeSig <= "000000";
functSig <= "100000";
wait for 100 ns;

wait;

end process;
end struct;