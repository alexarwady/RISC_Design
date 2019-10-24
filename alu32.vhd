-- VHDL model of a 32-bit ALU for use in the RISC321.I datapth.
--
-- Copyright (C) Mazen A. R. Saghir
-- Department of Electrical and Computer Engineering
-- American University of Beirut
-- May 1, 2018
--
-- i_op input is used to select the ALU operation.
-- Supported operations include: addition ("0000"), 
-- subtraction ("0001"), logical shift left ("0010"), 
-- logical shift right ("0011"), and ("0100"), or ("0101"), 
-- xor ("0110"), and set-if-less-than ("0111").
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu32 is
  port (
    i_data_1 : in std_logic_vector (31 downto 0);
    i_data_2 : in std_logic_vector (31 downto 0);
    i_op : in std_logic_vector (3 downto 0);
    o_result : out std_logic_vector (31 downto 0);
    o_zero : out std_logic;
    o_less_than : out std_logic
  );
end alu32;

architecture rtl of alu32 is
  signal w_result, w_data_1, w_data_2 : integer;
  signal shamt : integer;
begin
  w_data_1 <= to_integer(signed(i_data_1));
  w_data_2 <= to_integer(signed(i_data_2));
  shamt <= to_integer(unsigned(i_data_2(4 downto 0)));

  process (i_data_1, i_data_2, i_op, w_data_1, w_data_2)
  begin
    case i_op is
      when "0000" => w_result <= w_data_1 + w_data_2; -- add

      when "0001" => w_result <= w_data_1 - w_data_2; -- sub

      when "0010" => w_result <= to_integer((to_signed(w_data_1,32) sll shamt)); -- sll

      when "0011" => w_result <= to_integer((to_signed(w_data_1,32) srl shamt)); -- srl

      when "0100" => w_result <= to_integer(unsigned(i_data_1 and i_data_2)); -- and

      when "0101" => w_result <= to_integer(unsigned(i_data_1 or i_data_2)); -- or

      when "0110" => w_result <= to_integer(unsigned(i_data_1 xor i_data_2)); -- xor

      when "0111" => -- slt
        if (w_data_1 < w_data_2) then
          w_result <= 1;
        else
          w_result <= 0;
        end if;

      when others => w_result <= 16#FFFFFFFF#;

    end case;
  end process;

  o_result <= std_logic_vector(to_signed(w_result, 32));

  o_zero <= '1' when (w_result = 0) else '0';

  o_less_than <= '1' when (w_result < 0) else '0';
end rtl;