library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity risc321i is
  port (
    i_clk : in std_logic;
    i_reset : in std_logic;
    i_instr : in std_logic_vector (31 downto 0);
    o_pc : out std_logic_vector (31 downto 0)
  );
end risc321i;

architecture structural of risc321i is
  -- component and signal declarations
component alu32 is
  port (
    i_data_1 : in std_logic_vector (31 downto 0);
    i_data_2 : in std_logic_vector (31 downto 0);
    i_op : in std_logic_vector (3 downto 0);
    o_result : out std_logic_vector (31 downto 0);
    o_zero : out std_logic;
    o_less_than : out std_logic
  );
end component;

component alu_control is
  port (
    i_alu_op : in std_logic_vector (1 downto 0);
    i_func3: in std_logic_vector (2 downto 0);
    i_instr_30 : in std_logic;
    o_operation : out std_logic_vector (3 downto 0)
  );
end component;

component branch_addr_gen is
  port (
    i_pc_plus_four : in std_logic_vector (31 downto 0);
    i_immediate : in std_logic_vector (31 downto 0);
    o_branch_addr : out std_logic_vector (31 downto 0)
  );
end component;

component data_memory is
  port (
    i_clk : in std_logic;
    i_write_en : in std_logic;
    i_read_en : in std_logic;
    i_addr : in std_logic_vector (31 downto 0);
    i_write_data : in std_logic_vector (31 downto 0);
    o_read_data : out std_logic_vector (31 downto 0)
  );
end component;

component imm_gen is
  port (
    i_signal: in std_logic_vector (1 downto 0);
    i_imm : in std_logic_vector (31 downto 0);
    o_imm : out std_logic_vector (31 downto 0)
  );
end component;

component instr_decoder is
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
end component;

component pc_adder is
  port (
    i_pc : in std_logic_vector (31 downto 0);
    o_pc_plus_four : out std_logic_vector (31 downto 0)
  );
end component;

component register_file is
  port (
    i_clk : in std_logic;
    i_write_en : in std_logic;
    i_read_reg_1 : in std_logic_vector (4 downto 0);
    i_read_reg_2 : in std_logic_vector (4 downto 0);
    i_write_reg : in std_logic_vector (4 downto 0);
    i_write_data : in std_logic_vector (31 downto 0);
    o_read_data_1 : out std_logic_vector (31 downto 0);
    o_read_data_2 : out std_logic_vector (31 downto 0)
  );
end component;

component mux is
port( control : in std_logic;
input1 : in std_logic_vector (31 downto 0);
input2 : in std_logic_vector (31 downto 0);
output : out std_logic_vector(31 downto 0));
end component;

component andblock is
port( input1 : in std_logic;
input2 : in std_logic;
input3 : in std_logic;
i_instr: in std_logic_vector (31 downto 0);
output : out std_logic);
end component;

component setzero is
port (
i_inst: in std_logic_vector (31 downto 0);
i_imm: in std_logic_vector (31 downto 0);
o_imm: out std_logic_vector (31 downto 0)
);
end component;

component muxlike is
port( i_instr : in std_logic_vector (31 downto 0);
input1 : in std_logic_vector (31 downto 0);
input2 : in std_logic_vector (31 downto 0);
output : out std_logic_vector(31 downto 0));
end component;

signal instruction : std_logic_vector (31 downto 0) := (others => '0');

signal regwrite_control : std_logic := '0';
signal alusrc_control : std_logic := '0';
signal memwrite_control : std_logic := '0';
signal aluop_control : std_logic_vector (1 downto 0) := "00";
signal memtoreg_control : std_logic := '0';
signal memread_control : std_logic := '0';
signal branch_control : std_logic := '0';
signal jump_control : std_logic := '0';
signal regdst_control : std_logic := '0';
signal aluimm_control : std_logic_vector (1 downto 0) := "00";

signal i_write_data : std_logic_vector (31 downto 0) := (others => '0');
signal o_read_data_1 : std_logic_vector (31 downto 0) := (others => '0');
signal o_read_data_2 : std_logic_vector (31 downto 0) := (others => '0');

signal shift1_input : std_logic_vector (31 downto 0) := (others => '0');
signal shift1_output : std_logic_vector (31 downto 0) := (others => '0');

signal branchadder : std_logic_vector (31 downto 0);

signal pcplusfour :std_logic_vector (31 downto 0);

signal mux_read_data : std_logic_vector (31 downto 0) := (others => '0');
signal alucontrol: std_logic_vector (3 downto 0) := (others => '0');
signal aluresult : std_logic_vector (31 downto 0) := (others => '0');
signal aluresult1 : std_logic_vector (31 downto 0) := (others => '0');
signal andin1 : std_logic := '0';
signal o_less_than : std_logic := '0';

signal mem_output : std_logic_vector (31 downto 0) := (others => '0');

signal andblock_output: std_logic := '0';

signal next_address: std_logic_vector (31 downto 0) := (others => '0');
signal next_address1: std_logic_vector (31 downto 0) := (others => '0');
signal i_write_data1: std_logic_vector (31 downto 0) := (others => '0');
signal i_write_data2: std_logic_vector (31 downto 0) := (others => '0');

signal pc: std_logic_vector (31 downto 0) := (others => '0');
signal alu1: std_logic_vector (31 downto 0) := (others => '0');

begin
  -- port maps and component connections

process(i_reset, i_instr)
begin
if(i_reset'event and i_reset = '1') then
instruction <= (others => '0');
elsif (i_reset = '0') then
instruction <= i_instr;
end if;
end process;

u2: register_file port map (i_clk => i_clk,
    i_write_en => regwrite_control,
    i_read_reg_1 => instruction(19 downto 15),
    i_read_reg_2 => instruction(24 downto 20),
    i_write_reg => instruction(11 downto 7),
    i_write_data => i_write_data,
    o_read_data_1 => o_read_data_1,
    o_read_data_2 => o_read_data_2);
u3: imm_gen port map (i_signal => aluimm_control, i_imm => instruction, o_imm => shift1_input);
u5: branch_addr_gen port map (i_pc_plus_four => pc, i_immediate => shift1_input, o_branch_addr => branchadder);
u6: pc_adder port map (i_pc => pc, o_pc_plus_four => pcplusfour);
u7: instr_decoder port map (
    i_instr => instruction,
    o_reg_dst => regdst_control,
    o_jump => jump_control,
    o_branch => branch_control,
    o_mem_read => memread_control,
    o_mem_to_reg => memtoreg_control,
    o_alu_op => aluop_control,
    o_alu_imm => aluimm_control,
    o_mem_write => memwrite_control,
    o_alu_src => alusrc_control,
    o_reg_write => regwrite_control);
u8: alu32 port map (
    i_data_1 => alu1,
    i_data_2 => mux_read_data,
    i_op => alucontrol,
    o_result => aluresult,
    o_zero => andin1,
    o_less_than => o_less_than);
u9: data_memory port map (
    i_clk => i_clk,
    i_write_en => memwrite_control,
    i_read_en => memread_control,
    i_addr => aluresult1,
    i_write_data => o_read_data_2,
    o_read_data => mem_output);
u10: alu_control port map (
    i_alu_op => aluop_control,
    i_func3 => instruction(14 downto 12),
    i_instr_30 => instruction(30),
    o_operation => alucontrol);
u11: mux port map (
    control => alusrc_control,
    input1 => o_read_data_2,
    input2 => shift1_input,
    output => mux_read_data);
u12: mux port map (
    control => memtoreg_control,
    input1 => aluresult1,
    input2 => mem_output,
    output => i_write_data1); --recheck
u13: andblock port map (input1 => andin1, input2 => branch_control, input3 => o_less_than, i_instr => instruction, output => andblock_output);
u14: mux port map (
    control => andblock_output,
    input1 => pcplusfour,
    input2 => branchadder,
    output => next_address);
u15: mux port map (
    control => jump_control,
    input1 => aluresult1,
    input2 => pcplusfour,
    output => i_write_data2);
u16: mux port map (
    control => regdst_control,
    input1 => i_write_data2, --from former mux
    input2 => i_write_data1, --from memory
    output => i_write_data);
u17: mux port map (
    control => jump_control,
    input1 => next_address,
    input2 => aluresult1,
    output => next_address1);
u18: setzero port map (i_inst => instruction, i_imm =>aluresult, o_imm =>aluresult1);
u19: muxlike port map (i_instr => instruction, input1 => o_read_data_1, input2 => pc, output => alu1);

o_pc <= next_address1;

process(pc, next_address1, i_clk)
begin
if(i_clk'event and i_clk = '0') then
pc <= next_address1;
end if;
end process;

end structural;