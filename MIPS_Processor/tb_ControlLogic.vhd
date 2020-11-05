library IEEE;
use IEEE.std_logic_1164.all;

entity tb_ControlLogic is
  generic(gCLK_HPER   : time := 50 ns);
end tb_ControlLogic;

architecture behavior of tb_ControlLogic is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component ControlLogic is 
    port(i_Opcode      : in std_logic_vector(5 downto 0);
         i_FunctCode   : in std_logic_vector(5 downto 0);
         o_RegDest     : out std_logic;
         o_MemToReg    : out std_logic;
         o_ALUOp       : out std_logic_vector(3 downto 0);
         o_MemWrite    : out std_logic;
         o_ALUSrc      : out std_logic;
         o_RegWrite    : out std_logic;
         o_Shift       : out std_logic;
         o_LoadUpper   : out std_logic;
         o_SignExt     : out std_logic;
         o_BranchEq    : out std_logic;
         o_BranchNeq   : out std_logic;
         o_Jump        : out std_logic;
         o_JumpReg     : out std_logic;
         o_JumpAndLink : out std_logic);
  end component;

  signal s_CLK, s_RegDest, s_MemToReg, s_MemWrite, s_ALUSrc,  
         s_RegWrite, s_Shift, s_LoadUpper, s_SignExt, s_BranchEq,
         s_BranchNeq, s_Jump, s_JumpReg, s_JumpAndLink : std_logic;
  signal s_ALUOp : std_logic_vector(3 downto 0);
  signal s_Opcode, s_FunctCode : std_logic_vector(5 downto 0);

begin

  CtlLogic: ControlLogic 
  port map(i_Opcode      => s_Opcode,
           i_FunctCode   => s_FunctCode,
           o_RegDest     => s_RegDest,
           o_MemToReg    => s_MemToReg,
           o_ALUOp       => s_ALUOp,
           o_MemWrite    => s_MemWrite,
           o_ALUSrc      => s_ALUSrc,
           o_RegWrite    => s_RegWrite,
           o_Shift       => s_Shift,
           o_LoadUpper   => s_LoadUpper,
           o_SignExt     => s_SignExt,
           o_BranchEq    => s_BranchEq,
           o_BranchNeq   => s_BranchNeq,
           o_Jump        => s_Jump,
           o_JumpReg     => s_JumpReg,
           o_JumpAndLink => s_JumpAndLink);


  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin

    -- addi
    s_Opcode <= "001000";
    s_FunctCode <= "XXXXXX";
    wait for cCLK_PER;

    -- add
    s_Opcode <= "000000";
    s_FunctCode <= "100000";
    wait for cCLK_PER;

    -- addiu
    s_Opcode <= "001001";
    s_FunctCode <= "XXXXXX";
    wait for cCLK_PER;

    -- addu
    s_Opcode <= "000000";
    s_FunctCode <= "100001";
    wait for cCLK_PER;

    -- sub
    s_Opcode <= "000000";
    s_FunctCode <= "100010";
    wait for cCLK_PER;

    -- subu
    s_Opcode <= "000000";
    s_FunctCode <= "100011";
    wait for cCLK_PER;

    -- and
    s_Opcode <= "000000";
    s_FunctCode <= "100100";
    wait for cCLK_PER;

    -- andi
    s_Opcode <= "001100";
    s_FunctCode <= "XXXXXX";
    wait for cCLK_PER;

    -- nor
    s_Opcode <= "000000";
    s_FunctCode <= "100111";
    wait for cCLK_PER;

    -- xor
    s_Opcode <= "000000";
    s_FunctCode <= "100110";
    wait for cCLK_PER;

    -- xori
    s_Opcode <= "001110";
    s_FunctCode <= "XXXXXX";
    wait for cCLK_PER;

    -- or
    s_Opcode <= "000000";
    s_FunctCode <= "100101";
    wait for cCLK_PER;

    -- ori
    s_Opcode <= "001101";
    s_FunctCode <= "XXXXXX";
    wait for cCLK_PER;

    -- lw
    s_Opcode <= "100011";
    s_FunctCode <= "XXXXXX";
    wait for cCLK_PER;

    -- sw
    s_Opcode <= "101011";
    s_FunctCode <= "XXXXXX";
    wait for cCLK_PER;

    -- lui
    s_Opcode <= "001111";
    s_FunctCode <= "XXXXXX";
    wait for cCLK_PER;

    -- slt
    s_Opcode <= "000000";
    s_FunctCode <= "101010";
    wait for cCLK_PER;

    -- slti
    s_Opcode <= "001010";
    s_FunctCode <= "XXXXXX";
    wait for cCLK_PER;

    -- sltiu
    s_Opcode <= "001011";
    s_FunctCode <= "XXXXXX";
    wait for cCLK_PER;

    -- sltu
    s_Opcode <= "000000";
    s_FunctCode <= "101011";
    wait for cCLK_PER;

    -- sll
    s_Opcode <= "000000";
    s_FunctCode <= "000000";
    wait for cCLK_PER;

    -- srl
    s_Opcode <= "000000";
    s_FunctCode <= "000010";
    wait for cCLK_PER;

    -- sra
    s_Opcode <= "000000";
    s_FunctCode <= "000011";
    wait for cCLK_PER;

    -- sllv
    s_Opcode <= "000000";
    s_FunctCode <= "000100";
    wait for cCLK_PER;

    -- srlv
    s_Opcode <= "000000";
    s_FunctCode <= "000110";
    wait for cCLK_PER;

    -- srav
    s_Opcode <= "000000";
    s_FunctCode <= "000111";
    wait for cCLK_PER;

    -- beq
    s_Opcode <= "000100";
    s_FunctCode <= "XXXXXX";
    wait for cCLK_PER;

    -- bne
    s_Opcode <= "000101";
    s_FunctCode <= "XXXXXX";
    wait for cCLK_PER;

    -- j
    s_Opcode <= "000010";
    s_FunctCode <= "XXXXXX";
    wait for cCLK_PER;

    -- jal
    s_Opcode <= "000011";
    s_FunctCode <= "XXXXXX";
    wait for cCLK_PER;

    -- jr
    s_Opcode <= "000000";
    s_FunctCode <= "001000";
    wait for cCLK_PER;

    wait;
  end process;
  
end behavior;
