library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity COM is
  generic(
    w : natural
  );
  port(
    clk, rst           : in std_logic;
    din0_r, din0_i     : in std_logic_vector(w - 1 downto 0);
    din1_r, din1_i     : in std_logic_vector(w - 1 downto 0);
    din2_r, din2_i     : in std_logic_vector(w - 1 downto 0);
    din3_r, din3_i     : in std_logic_vector(w - 1 downto 0);
    din4_r, din4_i     : in std_logic_vector(w - 1 downto 0);
    din5_r, din5_i     : in std_logic_vector(w - 1 downto 0);
    din6_r, din6_i     : in std_logic_vector(w - 1 downto 0);
    din7_r, din7_i     : in std_logic_vector(w - 1 downto 0);

    Load               : in std_logic;

    adr_1sge           : out std_logic_vector(5 downto 0);
    Data2Mem           : out std_logic_vector(31 downto 0);
    EndComm            : out std_logic
  );

end COM;

architecture archCOM of COM is

  signal adr_aux      : integer;
  signal MemData_aux  : std_logic_vector(w - 1 downto 0);

begin

  cont : process(clk, rst)
    begin
      if(rst = '1') then
        adr_aux <= 0;
      elsif RISING_EDGE(clk) then
        if adr_aux = 15 or Load = '0' then
          adr_aux <= 0;
        else
          adr_aux <= adr_aux + 1;
        end if;
      end if;
  end process;

  adr_1sge <= std_logic_vector(to_unsigned(adr_aux,6));


  with adr_aux select
     MemData_aux <= din0_r  when 0,
                    din0_i  when 1,
                    din1_r  when 2,
                    din1_i  when 3,
                    din2_r  when 4,
                    din2_i  when 5,
                    din3_r  when 6,
                    din3_i  when 7,
                    din4_r  when 8,
                    din4_i  when 9,
                    din5_r  when 10,
                    din5_i  when 11,
                    din6_r  when 12,
                    din6_i  when 13,
                    din7_r  when 14,
                    din7_i  when 15,
                    (others => '0') when others;

  EndComm <= '1' when adr_aux = 15 else
            '0';
  Data2Mem <= std_logic_vector(resize(signed(MemData_aux),32));
end architecture;
