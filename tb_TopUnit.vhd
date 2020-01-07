library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_TopUnit is

end tb_TopUnit;

architecture arch of tb_TopUnit is
component TopUnit is
generic(
  w : natural := 28
);
port(
clk, rst             : in std_logic;

din0      : in std_logic_vector(2*w - 1 downto 0);
din1      : in std_logic_vector(2*w - 1 downto 0);
din2      : in std_logic_vector(2*w - 1 downto 0);
din3      : in std_logic_vector(2*w - 1 downto 0);
din4      : in std_logic_vector(2*w - 1 downto 0);
din5      : in std_logic_vector(2*w - 1 downto 0);
din6      : in std_logic_vector(2*w - 1 downto 0);
din7      : in std_logic_vector(2*w - 1 downto 0);
din_rts, dout_cts    : in std_logic;

dout0     : out std_logic_vector(2*w - 1 downto 0);
dout1     : out std_logic_vector(2*w - 1 downto 0);
dout2     : out std_logic_vector(2*w - 1 downto 0);
dout3     : out std_logic_vector(2*w - 1 downto 0);
dout4     : out std_logic_vector(2*w - 1 downto 0);
dout5     : out std_logic_vector(2*w - 1 downto 0);
dout6     : out std_logic_vector(2*w - 1 downto 0);
dout7     : out std_logic_vector(2*w - 1 downto 0);
din_cts, dout_rts    : out std_logic
);
end component;


signal clk : std_logic := '0';
signal rst : std_logic;
signal din_rts :std_logic;
signal dout_cts : std_logic := '0';
signal end_stage : std_logic;
constant w : integer :=28;
signal  din0_r, din0_i,dout0_aux, dout0_aux2     :  std_logic_vector(w - 1 downto 0);
signal  din1_r, din1_i     :  std_logic_vector(w - 1 downto 0);
signal  din2_r, din2_i     :  std_logic_vector(w - 1 downto 0);
signal  din3_r, din3_i     :  std_logic_vector(w - 1 downto 0);
signal  din4_r, din4_i     :  std_logic_vector(w - 1 downto 0);
signal  din5_r, din5_i     :  std_logic_vector(w - 1 downto 0);
signal  din6_r, din6_i     :  std_logic_vector(w - 1 downto 0);
signal  din7_r, din7_i     :  std_logic_vector(w - 1 downto 0);

signal  din0, dout0             :  std_logic_vector(2*w - 1 downto 0);
signal  din1, dout1               :  std_logic_vector(2*w - 1 downto 0);
signal  din2, dout2               :  std_logic_vector(2*w - 1 downto 0);
signal  din3, dout3               :  std_logic_vector(2*w - 1 downto 0);
signal  din4, dout4               :  std_logic_vector(2*w - 1 downto 0);
signal  din5, dout5               :  std_logic_vector(2*w - 1 downto 0);
signal  din6, dout6               :  std_logic_vector(2*w - 1 downto 0);
signal  din7, dout7               :  std_logic_vector(2*w - 1 downto 0);

signal  MemData            :  std_logic_vector(31 downto 0);

signal  din_cts : std_logic;
signal  dout_rts  :  std_logic;
signal  start_fft          :  std_logic;
signal  WE_TopFSM          :  std_logic;
signal  adr_1sge           :  std_logic_vector(3 downto 0);
signal  stage              :  std_logic_vector(1 downto 0);

signal cont                :  integer := 0;
signal dout0_s : real;
signal dout1_s : real;
signal dout2_s : real;
signal dout3_s : real;
signal dout4_s : real;
signal dout5_s : real;
signal dout6_s : real;
signal dout7_s : real;



begin

TopUnit_Inst : TopUnit
  port map(
  clk       => clk,
  rst       => rst,
  din_rts   => din_rts,
  dout_cts  => dout_cts,
  din0 => din0,
  din1 => din1,
  din2 => din2,
  din3 => din3,
  din4 => din4,
  din5 => din5,
  din6 => din6,
  din7 => din7,
  dout0 => dout0,
  dout1 => dout1,
  dout2 => dout2,
  dout3 => dout3,
  dout4 => dout4,
  dout5 => dout5,
  dout6 => dout6,
  dout7 => dout7,
  
  din_cts => din_cts,
  dout_rts => dout_rts
    );

  clk      <= not clk after 7 ns;
  rst      <= '0', '1'  after 13 ns, '0' after 31 ns;

  din0 <= din0_r & din0_i;
  din1 <= din1_r & din1_i;
  din2 <= din2_r & din2_i;
  din3 <= din3_r & din3_i;
  din4 <= din4_r & din4_i;
  din5 <= din5_r & din5_i;
  din6 <= din6_r & din6_i;
  din7 <= din7_r & din7_i;

  din_rts <= '1';
  testentry : process(din_cts)
begin
    if FALLING_EDGE(din_cts) then
        if(cont = 3) then
            cont <= 0;
         else
            cont <= cont + 1;
         end if;
     end if;
end process;


dout_cts <= not dout_cts after 1us;
process(cont)
    begin
    case cont is
      when 0 =>
        din0_r <= std_logic_vector(to_signed(2011,w));
        din1_r <= std_logic_vector(to_signed(2011,w));
        din2_r <= std_logic_vector(to_signed(2011,w));
        din3_r <= std_logic_vector(to_signed(2011,w));
        din4_r <= std_logic_vector(to_signed(2011,w));
        din5_r <= std_logic_vector(to_signed(2011,w));
        din6_r <= std_logic_vector(to_signed(2011,w));
        din7_r <= std_logic_vector(to_signed(2011,w));

        din0_i <= std_logic_vector(to_signed(2011,w));
        din1_i <= std_logic_vector(to_signed(2011,w));
        din2_i <= std_logic_vector(to_signed(2011,w));
        din3_i <= std_logic_vector(to_signed(2011,w));
        din4_i <= std_logic_vector(to_signed(2011,w));
        din5_i <= std_logic_vector(to_signed(2011,w));
        din6_i <= std_logic_vector(to_signed(2011,w));
        din7_i <= std_logic_vector(to_signed(2011,w));

      when 1 =>
        din0_r <= std_logic_vector(to_signed(1,w));
        din1_r <= std_logic_vector(to_signed(0,w));
        din2_r <= std_logic_vector(to_signed(0,w));
        din3_r <= std_logic_vector(to_signed(0,w));
        din4_r <= std_logic_vector(to_signed(0,w));
        din5_r <= std_logic_vector(to_signed(0,w));
        din6_r <= std_logic_vector(to_signed(0,w));
        din7_r <= std_logic_vector(to_signed(0,w));

        din0_i <= std_logic_vector(to_signed(1,w));
        din1_i <= std_logic_vector(to_signed(0,w));
        din2_i <= std_logic_vector(to_signed(0,w));
        din3_i <= std_logic_vector(to_signed(0,w));
        din4_i <= std_logic_vector(to_signed(0,w));
        din5_i <= std_logic_vector(to_signed(0,w));
        din6_i <= std_logic_vector(to_signed(0,w));
        din7_i <= std_logic_vector(to_signed(0,w));

      when 2 =>
        din0_r <= std_logic_vector(to_signed(0,w));
        din1_r <= std_logic_vector(to_signed(120,w));
        din2_r <= std_logic_vector(to_signed(234,w));
        din3_r <= std_logic_vector(to_signed(120,w));
        din4_r <= std_logic_vector(to_signed(0,w));
        din5_r <= std_logic_vector(to_signed(-120,w));
        din6_r <= std_logic_vector(to_signed(-234,w));
        din7_r <= std_logic_vector(to_signed(-120,w));

        din0_i <= std_logic_vector(to_signed(456,w));
        din1_i <= std_logic_vector(to_signed(234,w));
        din2_i <= std_logic_vector(to_signed(120,w));
        din3_i <= std_logic_vector(to_signed(0,w));
        din4_i <= std_logic_vector(to_signed(-120,w));
        din5_i <= std_logic_vector(to_signed(-234,w));
        din6_i <= std_logic_vector(to_signed(-456,w));
        din7_i <= std_logic_vector(to_signed(-768,w));

      when others =>
        din0_r <= std_logic_vector(to_signed(123,w));
        din1_r <= std_logic_vector(to_signed(34,w));
        din2_r <= std_logic_vector(to_signed(-23,w));
        din3_r <= std_logic_vector(to_signed(12,w));
        din4_r <= std_logic_vector(to_signed(45,w));
        din5_r <= std_logic_vector(to_signed(0,w));
        din6_r <= std_logic_vector(to_signed(67,w));
        din7_r <= std_logic_vector(to_signed(134,w));

        din0_i <= std_logic_vector(to_signed(29,w));
        din1_i <= std_logic_vector(to_signed(34,w));
        din2_i <= std_logic_vector(to_signed(85,w));
        din3_i <= std_logic_vector(to_signed(206,w));
        din4_i <= std_logic_vector(to_signed(336,w));
        din5_i <= std_logic_vector(to_signed(593,w));
        din6_i <= std_logic_vector(to_signed(823,w));
        din7_i <= std_logic_vector(to_signed(422,w));
            
      end case;

    end process;
  --  constant w0_r : std_logic_vector(w downto 0) := std_logic_vector(to_signed(integer(round(1.0*real(2**24))),26));
    dout0_s<= real(to_integer(signed(dout0(w-1 downto 0))))/real(2**(w-18));
    dout1_s<= real(to_integer(signed(dout1(w-1 downto 0))))/real(2**(w-18));
    dout2_s<= real(to_integer(signed(dout2(w-1 downto 0))))/real(2**(w-18));
    dout3_s<= real(to_integer(signed(dout3(w-1 downto 0))))/real(2**(w-18));
    dout4_s<= real(to_integer(signed(dout4(w-1 downto 0))))/real(2**(w-18));
    dout5_s<= real(to_integer(signed(dout5(w-1 downto 0))))/real(2**(w-18));
    dout6_s<= real(to_integer(signed(dout6(w-1 downto 0))))/real(2**(w-18));
    dout7_s<= real(to_integer(signed(dout7(w-1 downto 0))))/real(2**(w-18));
    
    

end architecture;
