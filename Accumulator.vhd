library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.types.all;

entity Accumulator is
  port (clk : in std_logic;
        RxD : in std_logic;
        TxD : out std_logic);
end Accumulator;

architecture rtl of Accumulator is
  constant data : data_t := (
    b"111_00000",                       -- nop
    b"010_00000",                       -- and 0 : zero clear
    b"000_00011",                       -- add 3
    b"001_00010",                       -- sub 2
    b"011_00110",                       -- or 6
    b"010_00011",                       -- and 3
    b"111_00000",                       -- nop
    b"100_00000");                      -- write. expects acc equals 3

  component ALU
    port (clk : in std_logic;
          opcode : in alu_op_t;
          arg1 : in int8_t;
          arg2 : in int8_t;
          retv : out int8_t);
  end component;

  component UART
    port(CLK : in std_logic;
         RxD : in std_logic;
         TxD : out std_logic;
         DOUT : out std_logic_vector(7 downto 0);
         DIN : in std_logic_vector(7 downto 0);
         Tx_GO : in std_logic;
         Rx_BUSY : out std_logic;
         Tx_BUSY : out std_logic);
  end component;

  signal pc : std_logic_vector(2 downto 0) := (others => '0');

  signal alu_op : alu_op_t := (others => '0');
  signal alu_arg2 : int8_t := (others => '0');

  signal acc : int8_t := (others => '0');

  -- IO
  signal dout : std_logic_vector(7 downto 0);
  signal tx_go : std_logic;
  signal tx_busy : std_logic;

begin
  alu0 : ALU
    port map (clk => clk,
              opcode => alu_op,
              arg1 => acc,
              arg2 => alu_arg2,
              retv => acc);

  uart0 : UART
    port map (clk => clk,
              RxD => RxD,
              TxD => TxD,
              DIN => DOUT,
              Tx_GO => Tx_GO,
              Tx_BUSY => Tx_BUSY);

  process(clk)
    variable icode : code_t;
    variable op : op_t;
    variable oprand : oprand_t;
  begin
    if rising_edge(clk) then
      icode := data(conv_integer(pc));
      op := icode(7 downto 5);
      oprand := icode(4 downto 0);

      case op is
        when "000" | "001" | "010" | "011" =>
          alu_op <= op(1 downto 0);
          alu_arg2 <= "000" & oprand;
        when "100" =>
          if tx_busy = '0' and tx_go = '0' then
            dout <= acc + x"30";
            tx_go <= '1';
          else
            tx_go <= '0';
          end if;
        when others =>
          -- nop
      end case;

      pc <= pc + 1;

    end if;
  end process;

end rtl;
