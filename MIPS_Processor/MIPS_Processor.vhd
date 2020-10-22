-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal v0             : std_logic_vector(N-1 downto 0); -- TODO: should be assigned to the output of register 2, used to implement the halt SYSCALL
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. This case happens when the syscall instruction is observed and the V0 register is at 0x0000000A. This signal is active high and should only be asserted after the last register and memory writes before the syscall are guaranteed to be completed.

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

  signal s_ReadData1        : std_logic_vector(N-1 downto 0);  -- Register file ReadData1 output
  signal s_ReadData2        : std_logic_vector(N-1 downto 0);  -- Register file ReadData2 output
  signal s_Imm              : std_logic_vector(N-1 downto 0);  -- Sign extended immediate
  signal s_ALUOut           : std_logic_vector(N-1 downto 0);  -- ALU output
  signal s_ALUOp            : std_logic_vector(3 downto 0);    -- ALU operation signal
  signal s_ALUIn2           : std_logic_vector(N-1 downto 0);  -- ALU input 2
  signal s_NextNextInstAddr : std_logic_vector(N-1 downto 0);  -- PC + 4, next next address to be read

  component register_file is
    port(i_Clk, i_WriteEnable               : in std_logic;
         i_ReadReg1, i_ReadReg2, i_WriteReg : in std_logic_vector(4 downto 0);
         i_WriteData		            : in std_logic_vector(31 downto 0);
         o_ReadData1, o_ReadData2           : out std_logic_vector(31 downto 0));
  end component;

  component fullALU_shifter is
    port(i_a         : in std_logic_vector(31 downto 0);
         i_b         : in std_logic_vector(31 downto 0);
         i_s         : in std_logic_vector(3 downto 0);
         o_F         : out std_logic_vector(31 downto 0);
         o_cOut      : out std_logic;
         o_Overflow  : out std_logic;
         o_Zero      : out std_logic);
  end component;

  component ext16_32 is
    -- i_Ctl: 0 = zero extend, 1 = sign extend
    port(i_Ctl  : in std_logic;
         i_16   : in std_logic_vector(15 downto 0);
         o_32  : out std_logic_vector(31 downto 0));
  end component;

  component n_mux2_1 is
    generic(N : integer);
    port(i_A  : in std_logic_vector(N-1 downto 0);
         i_B  : in std_logic_vector(N-1 downto 0);
         i_S  : in std_logic;
         o_F  : out std_logic_vector(N-1 downto 0));
  end component;

  component ndff is
    generic(N : integer := 32);
    port(i_CLK        : in std_logic; 
         i_RST        : in std_logic;
         i_WE         : in std_logic; 
         i_D          : in std_logic_vector(N-1 downto 0); 
         o_Q          : out std_logic_vector(N-1 downto 0)); 
  end component;

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  s_Halt <='1' when (s_Inst(31 downto 26) = "000000") and (s_Inst(5 downto 0) = "001100") and (v0 = "00000000000000000000000000001010") else '0';

  -- TODO: Implement the rest of your processor below this comment! 

  oALUOut    <= s_ALUOut;
  s_DMemAddr <= s_ALUOut;

  PC: ndff
    port map(i_CLK => iCLK, 
             i_RST => '0', 
             i_WE  => '1',  
             i_D   => s_NextNextInstAddr, 
             o_Q   => s_NextInstAddr); 

  RegFile: register_file
    port map(i_Clk         => iCLK, 
             i_WriteEnable => s_RegWr,
             i_ReadReg1    => s_Inst, 
             i_ReadReg2    => s_Inst, 
             i_WriteReg    => s_RegWrAddr,
             i_WriteData   => s_RegWrData,
             o_ReadData1   => s_ReadData1,
             o_ReadData2   => s_ReadData2);

  DataALU: fullALU_shifter
    port map(i_a        => s_ReadData1,
             i_b        => s_ALUIn2,
             i_s        => s_ALUOp,
             o_F        => s_ALUOut,
             o_cOut     => open,
             o_Overflow => open,
             o_Zero     => open);

  PCALU: fullALUshifter
    port map(i_a        => "100",
             i_b        => s_NextInstAddr,
             i_s        => "0101",
             o_F        => s_NextNextInstAddr,
             o_cOut     => open,
             o_Overflow => open,
             o_Zero     => open);

  WriteReg: n_mux2_1
    generic map(N => 5);
    port map(i_A => s_Inst(20 downto 16),
             i_B => s_Inst(15 downto 11),
             i_S => ,
             o_F => s_RegWrAddr);

  ALUIn: n_mux2_1
    generic map(N => 32);
    port map(i_A => s_ReadData2,
             i_B => s_Imm,
             i_S => ,
             o_F => s_ALUIn2);

  MemToReg: n_mux2_1
    generic map(N => 32);
    port map(i_A => s_DMemOut,
             i_B => s_ALUOut,
             i_S => ,
             o_F => s_RegWrData);

  SignExtend: ext16_32
    port map(i_Ctl => '1',
             i_16  => s_Inst(15 downto 0),
             o_32  => s_Imm);

end structure;
