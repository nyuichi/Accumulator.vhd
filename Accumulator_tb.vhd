library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.types.all;

entity Accumulator_tb is
end Accumulator_tb;

architecture structural of Accumulator_tb is
  constant CP : time := 15 ns;

  signal clk : std_logic;
  signal txd : std_logic;
  signal rxd : std_logic;

  component Accumulator
    port (clk : in std_logic;
          RxD : in std_logic;
          TxD : out std_logic);
  end component;

begin
  acc : Accumulator
    port map(clk => clk, txd => txd, rxd => rxd);

  process
  begin
    clk <= '0';
    wait for CP / 2;
    clk <= '1';
    wait for CP / 2;
  end process;

end structural;
