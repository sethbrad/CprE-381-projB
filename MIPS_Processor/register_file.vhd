library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.a_mux_pack.all;

entity register_file is
  port(i_Clk, i_WriteEnable, i_Reset      : in std_logic;
       i_ReadReg1, i_ReadReg2, i_WriteReg : in std_logic_vector(4 downto 0);
       i_WriteData                        : in std_logic_vector(31 downto 0);
       o_ReadData1, o_ReadData2, o_Reg2   : out std_logic_vector(31 downto 0));
end register_file;

architecture structure of register_file is

  component ndff
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic_vector(31 downto 0);   -- Data value input
         o_Q          : out std_logic_vector(31 downto 0));  -- Data value output
  end component;

  component decoder5_32
    port(i_I   : in std_logic_vector(4 downto 0);     -- Decoder input
         i_En  : in std_logic;			      -- Decoder enable
         o_D   : out std_logic_vector(31 downto 0));  -- Decoder output
  end component;

  component mux32_1
    port(i_Sel  : in std_logic_vector(4 downto 0);    -- Select input
         i_In   : in Mux32_Input;                     -- Input signals
         o_Out  : out std_logic_vector(31 downto 0)); -- Mux output
  end component;
  
  signal s_WE : std_logic_vector(31 downto 0);
  signal s_Data : Mux32_Input;

begin 

  s_Data(0) <= x"00000000"; -- $zero is always zero

  DECODER: decoder5_32
  port map(i_I  => i_WriteReg,
           i_En => i_WriteEnable,
           o_D  => s_WE);

  REG_GEN: for i in 1 to 31 generate
    reg_i: ndff 
      port map(i_CLK => i_Clk,
               i_RST => i_Reset,
               i_WE  => s_WE(i),
               i_D   => i_WriteData,
  	       o_Q   => s_Data(i));
  end generate;

  MUX1: mux32_1
  port map(i_Sel => i_ReadReg1,
           i_In  => s_Data,
           o_Out => o_ReadData1);

  MUX2: mux32_1
  port map(i_Sel => i_ReadReg2,
           i_In  => s_Data,
           o_Out => o_ReadData2);

  o_Reg2 <= s_Data(2);

end structure;
