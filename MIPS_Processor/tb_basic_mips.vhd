library IEEE;
use IEEE.std_logic_1164.all;

entity tb_basic_mips is
  generic(gCLK_HPER   : time := 50 ns);
end tb_basic_mips;

architecture behavior of tb_basic_mips is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component basic_mips
    generic(A : integer := 10;
            D : integer := 32);
    port(i_Clk, i_regWrite, i_ALUSrc, i_rtype, i_memWrite  : in std_logic;
       i_ALUOp           : in std_logic_vector(3 downto 0);
       i_rs, i_rt, i_rd  : in std_logic_vector(4 downto 0);
       i_immediate       : in std_logic_vector(15 downto 0);
       o_Q               : out std_logic_vector(D-1 downto 0));
  end component;

  signal s_CLK, s_regWrite, s_ALUSrc, s_rtype, s_memWrite : std_logic;
  signal s_ALUOp : std_logic_vector(3 downto 0);
  signal s_rs, s_rt, s_rd : std_logic_vector(4 downto 0);
  signal s_immediate : std_logic_vector(15 downto 0);
  signal s_Q : std_logic_vector(31 downto 0);

begin

  MIPS: basic_mips 
  port map(i_Clk       => s_CLK,
           i_regWrite  => s_regWrite, 
           i_ALUSrc    => s_ALUSrc,
           i_rtype     => s_rtype,
           i_ALUOp     => s_ALUOp,
           i_memWrite  => s_memWrite,
	   i_rs        => s_rs,
	   i_rt        => s_rt,
           i_rd        => s_rd,
           i_immediate => s_immediate,
           o_Q         => s_Q);

  -- ALUOp reference:
  -- 0000 = and
  -- 0001 = or
  -- 0010 = xor
  -- 0011 = nand
  -- 0100 = nor
  -- 0101 = add
  -- 0110 = sub
  -- 0111 = slt
  -- 1000 = srl
  -- 1001 = sra
  -- 1010 = sll

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

    -- addi $8, $0, 7fff
    s_rs        <= "00000";
    s_rt        <= "XXXXX";
    s_rd        <= "01000";
    s_immediate <= x"7fff";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "0101";
    s_ALUSrc    <= '1';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    -- Test sll

    -- sll $9, $8, 16
    s_rs        <= "01000";
    s_rt        <= "XXXXX";
    s_rd        <= "01001";
    s_immediate <= x"0010";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "1010";
    s_ALUSrc    <= '1';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    -- Test overflow

    -- add $9, $9, $9
    s_rs        <= "01001";
    s_rt        <= "01001";
    s_rd        <= "01001";
    s_immediate <= x"0000";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "0101";
    s_ALUSrc    <= '0';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    -- Test basic add

    -- add $9, $8, $8
    s_rs        <= "01000";
    s_rt        <= "01000";
    s_rd        <= "01001";
    s_immediate <= x"0000";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "0101";
    s_ALUSrc    <= '0';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    -- Test basic sub

    -- sub $9, $9, $8
    s_rs        <= "01001";
    s_rt        <= "01000";
    s_rd        <= "01001";
    s_immediate <= x"0000";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "0110";
    s_ALUSrc    <= '0';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    -- Test negative overflow

    -- addi $8, $0, 8000
    s_rs        <= "00000";
    s_rt        <= "XXXXX";
    s_rd        <= "01000";
    s_immediate <= x"8000";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "0101";
    s_ALUSrc    <= '1';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    -- sll $9, $8, 16
    s_rs        <= "01000";
    s_rt        <= "XXXXX";
    s_rd        <= "01001";
    s_immediate <= x"0010";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "1010";
    s_ALUSrc    <= '1';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    -- add $9, $9, $9
    s_rs        <= "01001";
    s_rt        <= "01001";
    s_rd        <= "01001";
    s_immediate <= x"0000";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "0101";
    s_ALUSrc    <= '0';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    -- Test slt

    -- addi $8, $0, ffff
    s_rs        <= "00000";
    s_rt        <= "XXXXX";
    s_rd        <= "01000";
    s_immediate <= x"ffff";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "0101";
    s_ALUSrc    <= '1';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    -- addi $9, $0, 00FF
    s_rs        <= "00000";
    s_rt        <= "XXXXX";
    s_rd        <= "01001";
    s_immediate <= x"00FF";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "0101";
    s_ALUSrc    <= '1';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    -- slt $10, $8, $9
    s_rs        <= "01000";
    s_rt        <= "01001";
    s_rd        <= "01010";
    s_immediate <= x"0000";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "0111";
    s_ALUSrc    <= '0';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    -- slt $10, $9, $8
    s_rs        <= "01001";
    s_rt        <= "01000";
    s_rd        <= "01010";
    s_immediate <= x"0000";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "0111";
    s_ALUSrc    <= '0';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    -- slt $10, $9, $9
    s_rs        <= "01001";
    s_rt        <= "01001";
    s_rd        <= "01010";
    s_immediate <= x"0000";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "0111";
    s_ALUSrc    <= '0';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    -- Test logical ops (and, or, xor, nor, nand)

    -- addi $8, $0, 0f0f
    s_rs        <= "00000";
    s_rt        <= "XXXXX";
    s_rd        <= "01000";
    s_immediate <= x"0f0f";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "0101";
    s_ALUSrc    <= '1';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    -- addi $9, $0, 00ff
    s_rs        <= "00000";
    s_rt        <= "XXXXX";
    s_rd        <= "01001";
    s_immediate <= x"00FF";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "0101";
    s_ALUSrc    <= '1';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    -- and $10, $9, $8
    s_rs        <= "01000";
    s_rt        <= "01001";
    s_rd        <= "01010";
    s_immediate <= x"0000";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "0000";
    s_ALUSrc    <= '0';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    -- or $10, $9, $8
    s_ALUOp     <= "0001";
    wait for cCLK_PER;

    -- xor $10, $9, $8
    s_ALUOp     <= "0010";
    wait for cCLK_PER;

    -- nand $10, $9, $8
    s_ALUOp     <= "0011";
    wait for cCLK_PER;

    -- nor $10, $9, $8
    s_ALUOp     <= "0100";
    wait for cCLK_PER;

    -- Test sll (again)

    -- addi $8, $0, ffff
    s_rs        <= "00000";
    s_rt        <= "XXXXX";
    s_rd        <= "01000";
    s_immediate <= x"ffff";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "0101";
    s_ALUSrc    <= '1';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    -- sll $9, $8, 16
    s_rs        <= "01000";
    s_rt        <= "XXXXX";
    s_rd        <= "01001";
    s_immediate <= x"0010";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "1010";
    s_ALUSrc    <= '1';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    -- Test srl

    -- srl $9, $8, 16
    s_rs        <= "01000";
    s_rt        <= "XXXXX";
    s_rd        <= "01001";
    s_immediate <= x"0010";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "1000";
    s_ALUSrc    <= '1';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    -- Test sra

    -- sra $9, $8, 16
    s_rs        <= "01000";
    s_rt        <= "XXXXX";
    s_rd        <= "01001";
    s_immediate <= x"0010";
    s_rtype     <= '1';
    s_memWrite  <= '0';
    s_ALUOp     <= "1001";
    s_ALUSrc    <= '1';
    s_regWrite  <= '1';
    wait for cCLK_PER;

    wait;
  end process;
  
end behavior;
