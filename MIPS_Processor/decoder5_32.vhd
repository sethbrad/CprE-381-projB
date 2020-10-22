library IEEE;
use IEEE.std_logic_1164.all;

entity decoder5_32 is
  port(i_I   : in std_logic_vector(4 downto 0);     -- Decoder input
       i_En  : in std_logic;			    -- Decoder enable
       o_D   : out std_logic_vector(31 downto 0));  -- Decoder output
end decoder5_32;

architecture dataflow of decoder5_32 is

begin
  
  o_D <= x"00000001" when i_En = '1' and i_I = "00000" else
	 x"00000002" when i_En = '1' and i_I = "00001" else  
	 x"00000004" when i_En = '1' and i_I = "00010" else  
	 x"00000008" when i_En = '1' and i_I = "00011" else  
	 x"00000010" when i_En = '1' and i_I = "00100" else  
	 x"00000020" when i_En = '1' and i_I = "00101" else  
	 x"00000040" when i_En = '1' and i_I = "00110" else  
	 x"00000080" when i_En = '1' and i_I = "00111" else  
	 x"00000100" when i_En = '1' and i_I = "01000" else  
	 x"00000200" when i_En = '1' and i_I = "01001" else  
	 x"00000400" when i_En = '1' and i_I = "01010" else  
	 x"00000800" when i_En = '1' and i_I = "01011" else
	 x"00001000" when i_En = '1' and i_I = "01100" else  
	 x"00002000" when i_En = '1' and i_I = "01101" else  
	 x"00004000" when i_En = '1' and i_I = "01110" else  
	 x"00008000" when i_En = '1' and i_I = "01111" else
	 x"00010000" when i_En = '1' and i_I = "10000" else  
	 x"00020000" when i_En = '1' and i_I = "10001" else  
	 x"00040000" when i_En = '1' and i_I = "10010" else  
	 x"00080000" when i_En = '1' and i_I = "10011" else
	 x"00100000" when i_En = '1' and i_I = "10100" else  
	 x"00200000" when i_En = '1' and i_I = "10101" else  
	 x"00400000" when i_En = '1' and i_I = "10110" else  
	 x"00800000" when i_En = '1' and i_I = "10111" else
	 x"01000000" when i_En = '1' and i_I = "11000" else  
	 x"02000000" when i_En = '1' and i_I = "11001" else  
	 x"04000000" when i_En = '1' and i_I = "11010" else  
	 x"08000000" when i_En = '1' and i_I = "11011" else
	 x"10000000" when i_En = '1' and i_I = "11100" else  
	 x"20000000" when i_En = '1' and i_I = "11101" else  
	 x"40000000" when i_En = '1' and i_I = "11110" else  
	 x"80000000" when i_En = '1' and i_I = "11111" else
	 x"00000000";

end dataflow;
