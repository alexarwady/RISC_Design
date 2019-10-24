library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_control is
  port (
    i_alu_op : in std_logic_vector (1 downto 0);
    i_func3: in std_logic_vector (2 downto 0);
    i_instr_30 : in std_logic;
    o_operation : out std_logic_vector (3 downto 0)
  );
end alu_control;

architecture rtl of alu_control is
begin
process (i_alu_op, i_func3, i_instr_30)
begin
case i_alu_op is
when "10" =>
	case i_func3 is
	when "000" =>
		if(i_instr_30 = '0') then o_operation <= "0000";
		elsif(i_instr_30 = '1') then o_operation <= "0001";
		end if;
	when "001" =>
		if(i_instr_30 = '0') then o_operation <= "0010";
		end if;
	when "010" =>
		if(i_instr_30 = '0') then o_operation <= "0111";
		end if;
	when "100" =>
		if(i_instr_30 = '0') then o_operation <= "0110";
		end if;
	when "101" =>
		if(i_instr_30 = '0') then o_operation <= "0011";
		end if;
	when "110" =>
		if(i_instr_30 = '0') then o_operation <= "0101";
		end if;
	when "111" =>
		if(i_instr_30 = '0') then o_operation <= "0100";
		end if;
	when others => o_operation <= "0000";
	end case;

when "00" =>
	case i_func3 is
	when "000" => o_operation <= "0000";
	when "001" =>
		if(i_instr_30 = '0') then o_operation <= "0010";
		end if;
	when "010" => o_operation <= "0111";
	when "100" => o_operation <= "0110";
	when "101" =>
		if(i_instr_30 = '0') then o_operation <= "0011";
		end if;
	when "110" => o_operation <= "0101";
	when "111" => o_operation <= "0100";
	when others => o_operation <= "0000";
	end case;

when "01" =>
	case i_func3 is
	when "000" => o_operation <= "0001";
	when "100" => o_operation <= "0001";
	when others => o_operation <= "0000";
	end case;

when "11" =>
	case i_func3 is
	when "010" => o_operation <= "0000";
	when others => o_operation <= "0000";
	end case;

when others => o_operation <= "0000";
end case;
end process;
end rtl;
