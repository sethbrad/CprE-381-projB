library IEEE;
use IEEE.std_logic_1164.all;

entity basic_mips is
  generic(A : integer := 10;
          D : integer := 32);
  port(i_Clk, i_regWrite, i_ALUSrc, i_rtype, i_memWrite  : in std_logic;
       i_ALUOp           : in std_logic_vector(3 downto 0);
       i_rs, i_rt, i_rd  : in std_logic_vector(4 downto 0);
       i_immediate       : in std_logic_vector(15 downto 0);
       o_Q               : out std_logic_vector(D-1 downto 0));
end basic_mips;

architecture structure of basic_mips is

  component register_file
    port(i_Clk, i_WriteEnable               : in std_logic;
         i_ReadReg1, i_ReadReg2, i_WriteReg : in std_logic_vector(4 downto 0);
         i_WriteData		            : in std_logic_vector(D-1 downto 0);
         o_ReadData1, o_ReadData2           : out std_logic_vector(D-1 downto 0));
  end component;

  component fullALU_shifter
    port(i_a         : in std_logic_vector(31 downto 0);
         i_b         : in std_logic_vector(31 downto 0);
         i_s         : in std_logic_vector(3 downto 0);
         o_F         : out std_logic_vector(31 downto 0);
         o_cOut      : out std_logic;
         o_Overflow  : out std_logic;
         o_Zero      : out std_logic);
  end component;

  component n_mux2_1_struct
    generic(N : integer);
    port(i_A  : in std_logic_vector(N-1 downto 0);
         i_B  : in std_logic_vector(N-1 downto 0);
         i_S  : in std_logic;
         o_F  : out std_logic_vector(N-1 downto 0));
  end component;

  component mem
    generic (DATA_WIDTH : natural := D;
             ADDR_WIDTH : natural := A);
    port (clk  : in std_logic;
          addr : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we   : in std_logic := '1';
          q    : out std_logic_vector((DATA_WIDTH -1) downto 0));
  end component;

  component ext16_32
    port(i_Ctl  : in std_logic := '1'; -- Default set to sign extend
         i_16   : in std_logic_vector(15 downto 0);
         o_32  : out std_logic_vector(31 downto 0));
  end component;

  signal s_ALUcOut, s_ALUOverflow, s_ALUZero : std_logic;
  signal s_WriteReg : std_logic_vector(4 downto 0);
  signal s_ALUOut, s_ALUIn1, s_ALUIn2, s_ReadReg2, s_MemOut, s_RegData, s_extImm : std_logic_vector(D-1 downto 0);

begin 

  REG_FILE: register_file
  port map(i_Clk         => i_Clk,
           i_WriteEnable => i_regWrite,
           i_ReadReg1    => i_rs,
           i_ReadReg2    => i_rt,
           i_WriteReg    => s_WriteReg,
           i_WriteData   => s_RegData,
           o_ReadData1   => s_ALUIn1,
           o_ReadData2   => s_ReadReg2);

  ALU: fullALU_shifter
  port map(i_a        => s_ALUIn1,
           i_b        => s_ALUIn2,
           i_s        => i_ALUOp,
           o_F        => s_ALUOut,
           o_cOut     => s_ALUcOut,
           o_overflow => s_ALUOverflow,
           o_zero     => s_ALUZero);

  MUX_ALU: n_mux2_1_struct
  generic map(N => D)
  port map(i_A => s_ReadReg2,
           i_B => s_extImm,
           i_S => i_ALUSrc,
           o_F => s_ALUIn2);

  MUX_REG_WRITE: n_mux2_1_struct
  generic map(N => 5)
  port map(i_A => i_rt,
           i_B => i_rd,
           i_S => i_rtype,
           o_F => s_WriteReg);

  MUX_REG_DATA: n_mux2_1_struct
  generic map(N => D)
  port map(i_A => s_MemOut,
           i_B => s_ALUOut,
           i_S => i_rtype,
           o_F => s_RegData);

  EXT: ext16_32
  port map(i_Ctl => '1',
           i_16  => i_immediate,
           o_32  => s_extImm);

  DMEM: mem
  port map(clk  => i_Clk,
           addr => s_ALUOut(9 downto 0),
           data => s_ReadReg2,
           we   => i_memWrite,
           q    => s_MemOut);

  o_Q <= s_MemOut;

end structure;
