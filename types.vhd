library IEEE;
use IEEE.std_logic_1164.all;

package types is
  subtype code_t is std_logic_vector(7 downto 0);

  subtype op_t is std_logic_vector(2 downto 0);
  subtype oprand_t is std_logic_vector(4 downto 0);

  -- XXX YYYYY       OPCODES
  -- === =====
  -- 000 NNNNN       addi
  -- 001 NNNNN       subi
  -- 010 NNNNN       andi
  -- 011 NNNNN       ori
  -- 100 _____       write
  -- 101 _____       (reserved)
  -- 110 _____       (reserved)
  -- 111 _____       nop

  subtype alu_op_t is std_logic_vector(1 downto 0);
  subtype int8_t is std_logic_vector(7 downto 0);

  type data_t is array(0 to 7) of code_t;

end;
