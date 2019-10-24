library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instr_decoder is
  port (
    i_instr : in std_logic_vector (31 downto 0);
    o_reg_dst : out std_logic;
    o_jump : out std_logic;
    o_branch : out std_logic;
    o_mem_read : out std_logic;
    o_mem_to_reg : out std_logic;
    o_alu_op : out std_logic_vector (1 downto 0);
    o_alu_imm : out std_logic_vector (1 downto 0);
    o_mem_write : out std_logic;
    o_alu_src : out std_logic;
    o_reg_write : out std_logic
  );
end instr_decoder;

architecture rtl of instr_decoder is
signal opcode : std_logic_vector (6 downto 0);
begin
opcode<=i_instr(6 downto 0);
mycase: process(opcode, i_instr)
begin
case opcode is
when "0110011" => --0x33
    o_reg_dst <= '1';
    o_jump <= '0';
    o_branch <= '0';
    o_mem_read <= '0';
    o_mem_to_reg <= '0';
    o_alu_op <= "10";
    o_alu_imm <= "00";
    o_mem_write <= '0';
    o_alu_src <= '0';
    o_reg_write <= '1';

when "0000011" => --0x03
    o_reg_dst <= '1';
    o_jump <= '0';
    o_branch <= '0';
    o_mem_read <= '1';
    o_mem_to_reg <= '1';
    o_alu_op <= "11";
    o_alu_imm <= "00";
    o_mem_write <= '0';
    o_alu_src <= '1';
    o_reg_write <= '1';

when "0010011" => --0x13
    o_reg_dst <= '1';
    o_jump <= '0';
    o_branch <= '0';
    o_mem_read <= '0';
    o_mem_to_reg <= '0';
    o_alu_op <= "00";
    o_alu_imm <= "00";
    o_mem_write <= '0';
    o_alu_src <= '1';
    o_reg_write <= '1';

when "0100011" => --0x23
    o_reg_dst <= '0';
    o_jump <= '0';
    o_branch <= '0';
    o_mem_read <= '0';
    o_mem_to_reg <= '0';
    o_alu_op <= "11";
    o_alu_imm <= "01";
    o_mem_write <= '1';
    o_alu_src <= '1';
    o_reg_write <= '0';

when "1100011" => --0x63
    o_reg_dst <= '0';
    o_jump <= '0';
    o_branch <= '1';
    o_mem_read <= '0';
    o_mem_to_reg <= '0';
    o_alu_op <= "01";
    o_alu_imm <= "10";
    o_mem_write <= '0';
    o_alu_src <= '0';
    o_reg_write <= '0';

when "1101111" => --0x6F
    o_reg_dst <= '0';
    o_jump <= '1';
    o_branch <= '0';
    o_mem_read <= '0';
    o_mem_to_reg <= '0';
    o_alu_op <= "00";
    o_alu_imm <= "11";
    o_mem_write <= '0';
    o_alu_src <= '1';
    if (i_instr(19 downto 15) = "00000") then
    o_reg_write <= '0';
    else o_reg_write <= '1';
    end if;

when "1100111" => --0x67
    o_reg_dst <= '0';
    o_jump <= '1';
    o_branch <= '0';
    o_mem_read <= '0';
    o_mem_to_reg <= '0';
    o_alu_op <= "00";
    o_alu_imm <= "00";
    o_mem_write <= '0';
    o_alu_src <= '1';
    if (i_instr(11 downto 7) = "00000") then
    o_reg_write <= '0';
    else o_reg_write <= '1';
    end if;

when others => 
    o_reg_dst <= '0';
    o_jump <= '0';  
    o_branch <= '0';
    o_mem_read <= '0';
    o_mem_to_reg <= '0';
    o_alu_op <= "00";
    o_alu_imm <= "00";
    o_mem_write <= '0';
    o_alu_src <= '0';
    o_reg_write <= '0';
end case;
end process;


end rtl;


