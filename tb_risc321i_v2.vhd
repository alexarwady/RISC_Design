
-- Testbench for the RISC321i datapth.
--
-- Copyright (C) Mazen A. R. Saghir
-- Department of Electrical and Computer Engineering
-- American University of Beirut
--
-- May 12, 2018


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_risc321i is
end tb_risc321i;

architecture driver of tb_risc321i is

  component risc321i
    port (
      i_clk : in std_logic;
      i_reset : in std_logic;
      i_instr : in std_logic_vector (31 downto 0);
      o_pc : out std_logic_vector (31 downto 0)
    );
  end component;

  signal tb_clk : std_logic := '1';
  signal tb_reset : std_logic := '0';
  signal tb_instr : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal tb_pc : std_logic_vector (31 downto 0);

begin

  UUT : risc321i port map (i_clk => tb_clk, i_reset => tb_reset, i_instr => tb_instr, o_pc => tb_pc);

  clock: process
  begin
    tb_clk <= not tb_clk;
    wait for 5 ns;
  end process;

  tb_reset <= '1' after 2 ns, '0' after 3 ns;

  -- The following sequence of instructions tests each of
  -- the processor's 21 instructions. The results of most
  -- instructions are stored in $pc using the jalr instruction,
  -- and the expected $pc values are provided in the comments.
  -- Otherwise the $pc value should be simply incremented by 4.

  -- Test 1: 	jalr $zero,$zero,100 => $pc = 0x00000064

  tb_instr <= 	"00000110010000000000000001100111" after 11 ns,

  -- Test 2:	addi $t0,$zero,-17
  --			jalr $zero,$t0,0 => $pc = 0xFFFFFFEE

  			"11111110111100000000001010010011" after 21 ns,
  			"00000000000000101000000001100111" after 31 ns, 

  -- Test 3:	addi $t1,$zero,6
  --			add  $t0,$t0,$t1
  --			jalr $zero,$t0,0 => $pc = 0xFFFFFFF4

			"00000000011000000000001100010011" after 41 ns,
			"00000000011000101000001010110011" after 51 ns,
			"00000000000000101000000001100111" after 61 ns,

  -- Test 4:	addi $t0,$zero,-17
  --			sub  $t0,$t0,$t1
  --			jalr $zero,$t0,0 => $pc = 0xFFFFFFE8

			"11111110111100000000001010010011" after 71 ns,
			"01000000011000101000001010110011" after 81 ns,
			"00000000000000101000000001100111" after 91 ns,

  -- Test 5:	addi $t0,$zero,-17
  --			sll  $t0,$t0,$t1
  --			jalr $zero,$t0,0 => $pc = 0xFFFFFBC0

			"11111110111100000000001010010011" after 101 ns,
			"00000000011000101001001010110011" after 111 ns,
			"00000000000000101000000001100111" after 121 ns,

  -- Test 6:	addi $t0,$zero,-17
  --			slt  $t0,$t0,$t1
  --			slli	$t0,$t0,1
  --			jalr $zero,$t0,0 => $pc = 0x00000002

			"11111110111100000000001010010011" after 131 ns,
			"00000000011000101010001010110011" after 141 ns,
			"00000000000100101001001010010011" after 151 ns,
			"00000000000000101000000001100111" after 161 ns,

  -- Test 7: 	addi $t0,$zero,-17
  -- 			xor  $t0,$t0,$t1
  --			jalr $zero,$t0,0 => $pc = 0xFFFFFFE8

			"11111110111100000000001010010011" after 171 ns,
			"00000000011000101100001010110011" after 181 ns,
			"00000000000000101000000001100111" after 191 ns,

  -- Test 8:	addi $t0,$zero,-17
  --			srl $t0,$t0,$t1
  -- 			jalr $zero,$t0,0 => $pc = 0x03FFFFFE

			"11111110111100000000001010010011" after 201 ns, 
			"00000000011000101101001010110011" after 211 ns, 
			"00000000000000101000000001100111" after 221 ns,

  -- Test 9:	addi $t0,$zero,-17
  --			or $t0,$t0,$t1
  --			jalr $zero,$t0,0 => $pc = 0xFFFFFFEE

			"11111110111100000000001010010011" after 231 ns,
			"00000000011000101110001010110011" after 241 ns,
			"00000000000000101000000001100111" after 251 ns,

  -- Test 10: 	addi $t0,$zero,-17
  --			and $t0,$t0,$t1
  --			jalr $zero,$t0,0 => $pc = 0x00000006

			"11111110111100000000001010010011" after 261 ns,
			"00000000011000101111001010110011" after 271 ns,
			"00000000000000101000000001100111" after 281 ns,

  -- Test 11:	addi $t0,$zero,-17
  --			sw $t0,0($t1)

			"11111110111100000000001010010011" after 291 ns,
			"00000000010100110010000000100011" after 301 ns,

  -- Test 12:	lw $t1,0($t1)
  --			jalr $zero,$t1,0 => $pc = 0xFFFFFFEE

			"00000000000000110010001100000011" after 311 ns,
			"00000000000000110000000001100111" after 321 ns,

  -- Test 13:	slli $t0,$t0,4
  --			jalr $zero,$t0,0 => $pc = 0xFFFFFEF0

  			"00000000010000101001001010010011" after 331 ns,
			"00000000000000101000000001100111" after 341 ns,

  -- Test 14:	addi $t0,$zero,-17
  --			slti $t0,$t0,-20
  --			jalr $zero,$t0,0 => $pc = 0x00000000

			"11111110111100000000001010010011" after 351 ns, 			
			"11111110110000101010001010010011" after 361 ns,
			"00000000000000101000000001100111" after 371 ns,

  -- Test 15:	addi $t0,$zero,-17
  --			xori $t0,$t0,6
  --			jalr $zero,$t0,0 => $pc = 0xFFFFFFE8

			"11111110111100000000001010010011" after 381 ns,
			"00000000011000101100001010010011" after 391 ns,
			"00000000000000101000000001100111" after 401 ns,

  -- Test 16:	addi $t0,$zero,-17
  -- 			srli $t0,$t0,6
  --			jalr $zero,$t0,0 => $pc = 0x03FFFFFE	

			"11111110111100000000001010010011" after 411 ns,
			"00000000011000101101001010010011" after 421 ns,
			"00000000000000101000000001100111" after 431 ns, 

  -- Test 17:	addi $t0,$zero,-17
  --			ori $t0,$t0,6
  --			jalr $zero,$t0,0 => $pc = 0xFFFFFFEE	

			"11111110111100000000001010010011" after 441 ns,
			"00000000011000101110001010010011" after 451 ns,
			"00000000000000101000000001100111" after 461 ns,

  -- Test 18:	addi $t0,$zero,-17
  --			andi $t0,$t0,6
  --			jalr $zero,$t0,0 => $pc = 0x00000006

			"11111110111100000000001010010011" after 471 ns,
			"00000000011000101111001010010011" after 481 ns,
			"00000000000000101000000001100111" after 491 ns,

  -- Test 19:	addi $t0,$zero,-17
  --			addi $t1,$zero,-17
  --			beq  $t0,$t1,100 => $pc = 0x000000D6 (taken)

			"11111110111100000000001010010011" after 501 ns,
			"11111110111100000000001100010011" after 511 ns,
			"00001100011000101000010001100011" after 521 ns,

  -- Test 20:	addi $t1,$zero,6	
  --			beq  $t0,$t1,100 => $pc = 0x000000DE (not taken)

			"00000000011000000000001100010011" after 531 ns,
			"00001100011000101000010001100011" after 541 ns,

  -- Test 21:	blt  $t0,$t1,100 => $pc = 0x000001A6 (taken)

			"00001100011000101100010001100011" after 551 ns,

  -- Test 22:	addi $t1,$zero,-17
  --			blt  $t0,$t1,100 => $pc = 0x000001AE (not taken)

			"11111110111100000000001100010011" after 561 ns,
			"00001100011000101100010001100011" after 571 ns,

  -- Test 23:	jal $zero,100 => $pc = 0x00000276

			"00001100100000000000000001101111" after 581 ns;

end driver;
