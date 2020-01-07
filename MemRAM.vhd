library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MemRAM is
  generic(
    w : natural
  );
  port(
    adr        : in std_logic_vector(5 downto 0);
    DataIn     : in std_logic_vector(31 downto 0);
    WE         : in std_logic;
    clk, reset : in std_logic;

    DataOut : out std_logic_vector(31 downto 0)

  );

end MemRAM;

architecture archReg of MemRAM is
  type ram is array(63 downto 0) of std_logic_vector(31 downto 0);

    signal ram1 : ram := (others => (others => '0'));
    --Reading signal
    signal IR_out : std_logic_vector(31 downto 0) := (others => 'Z');
begin

  process(clk,reset)
    begin
      if(reset = '1')then
        ram1 <= (others => (others => '0'));
      elsif RISING_EDGE(clk) then
        if(WE = '1') then
          ram1(to_integer(unsigned(adr))) <= DataIn;
        else
          DataOut <= ram1(to_integer(unsigned(adr)));
        end if;
      end if;
    end process;
end architecture;
