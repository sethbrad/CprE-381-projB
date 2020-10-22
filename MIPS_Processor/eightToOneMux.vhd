library IEEE;
use IEEE.std_logic_1164.all;

entity eightToOneMux is
	port(s : in std_logic_vector(2 downto 0);
		vIn : in std_logic_vector(7 downto 0);
		F : out std_logic);
end eightToOneMux;

architecture dataflow of eightToOneMux is

begin
	with s select
	F <= vIn(0) when "000", -- 0
    vIn(1) when "001", -- 1
    vIn(2) when "010", -- 2
    vIn(3) when "011", -- 3
	vIn(4) when "100", -- 4
    vIn(5) when "101", -- 5
    vIn(6) when "110", -- 6
    vIn(7) when "111", -- 7
    vIn(0) when others;
    
end dataflow;