library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity OutRegisters is
  generic(
    w : natural
  );
  port(
    DataIn    : in std_logic_vector(w - 1 downto 0);
    clk, rst  : in std_logic;
    adr_Reg   : in std_logic_vector(5 downto 0);
    stage     : in std_logic_vector(1 downto 0);
    we        : in std_logic;

    dout0     : out std_logic_vector(2*w - 1 downto 0);
    dout1     : out std_logic_vector(2*w - 1 downto 0);
    dout2     : out std_logic_vector(2*w - 1 downto 0);
    dout3     : out std_logic_vector(2*w - 1 downto 0);
    dout4     : out std_logic_vector(2*w - 1 downto 0);
    dout5     : out std_logic_vector(2*w - 1 downto 0);
    dout6     : out std_logic_vector(2*w - 1 downto 0);
    dout7     : out std_logic_vector(2*w - 1 downto 0)
  );
end OutRegisters;

architecture arcOutRegisters of OutRegisters is

  type Reg is array(15 downto 0) of std_logic_vector(w - 1 downto 0);
  signal Registers : Reg := (others => (others => '0'));

begin
  process(clk,rst)
    begin
      if(rst = '1')then
        Registers <= (others => (others => '0'));
      elsif RISING_EDGE(clk) then
          if(stage = "10" and we='1')then
            Registers(to_integer(unsigned(adr_Reg))) <= DataIn;
          end if;
      end if;
    end process;

  dout0 <= Registers(0) & Registers(1);
  dout1 <= Registers(4) & Registers(5);
  dout2 <= Registers(8) & Registers(9);
  dout3 <= Registers(12) & Registers(13);
  dout4 <= Registers(2) & Registers(3);
  dout5 <= Registers(6) & Registers(7);
  dout6 <= Registers(10) & Registers(11);
  dout7 <= Registers(14) & Registers(15);
end architecture;
