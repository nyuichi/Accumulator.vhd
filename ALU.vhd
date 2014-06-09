library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.types.all;

entity ALU is
  port (clk : in std_logic;
        opcode : in alu_op_t;
        arg1 : in int8_t;
        arg2 : in int8_t;
        retv : out int8_t);
end ALU;

architecture rtl of ALU is
begin
  process(clk)
  begin
    if rising_edge(clk) then
      case opcode is
        when "00" =>
          retv <= arg1 + arg2;
        when "01" =>
          retv <= arg1 - arg2;
        when "10" =>
          retv <= arg1 and arg2;
        when "11" =>
          retv <= arg1 or arg2;
        when others =>
          retv <= "11111111";
      end case;
    end if;
  end process;

end rtl;
