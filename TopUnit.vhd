library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TopUnit is
  generic(
  w : natural :=12
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
end TopUnit;

architecture archTopUnit of TopUnit is
component TOP_FSM is
  generic(
    w : natural 
  );
  port(
    clk, rst           : in std_logic;
    din_rts, dout_cts  : in std_logic;
    end_stage          : in std_logic;
    endComm            : in std_logic;
    
    Load               : out std_logic;
    din_cts, dout_rts  : out std_logic;
    start_fft          : out std_logic;
    WE_TopFSM          : out std_logic;

    stage              : out std_logic_vector(1 downto 0)
  );

end component;

component MemRAM is
    generic(
       w : natural
     );
  port(
    adr        : in std_logic_vector(5 downto 0);
    DataIn     : in std_logic_vector(31 downto 0);
    WE         : in std_logic;
    clk, reset : in std_logic;

    DataOut    : out std_logic_vector(31 downto 0)

  );
end component;

component FFT8_UNIT is
 generic( w : natural);
  port(
    clk, rst        : in  std_logic;
    Data_In          : in  std_logic_vector(31 downto 0);
    stage           : in  std_logic_vector(1 downto 0);
    start_stage     : in std_logic;

    WE              : out std_logic;
    add_out         : out std_logic_vector(5 downto 0);
    fulladr         : out std_logic_vector(5 downto 0);
    fin_stage       : out std_logic;
    out0            : out std_logic_vector(w downto 0)
  );
end component;

component OutRegisters is
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
end component;

component COM is
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
end component;
  signal  s_stage                       : std_logic_vector(1 downto 0);
  signal  s_end_stage                   : std_logic;
  signal  s_DataIn                      : std_logic_vector(31 downto 0);
  signal  s_DataInreg                   : std_logic_vector(w-1 downto 0);
  signal  s_DataOut                     : std_logic_vector(31 downto 0);
  signal  s_WE, s_WE_Unit, s_WE_TopFSM  : std_logic;
  signal  s_Data2Mem                     : std_logic_vector(31 downto 0);
  signal  s_adr, s_adr_1sge, s_add_out  : std_logic_vector(5 downto 0);
  signal  s_fulladr                     : std_logic_vector(5 downto 0);
  signal  s_adr_Reg                     : std_logic_vector(5 downto 0);
  signal s_start_stage                  : std_logic;
  signal S_out0                         : std_logic_vector(w+2 downto 0);
  signal s_Load, s_endComm              : std_logic;

  signal s_din0_r, s_din0_i             : std_logic_vector(w - 1 downto 0);
  signal s_din1_r, s_din1_i             : std_logic_vector(w - 1 downto 0);
  signal s_din2_r, s_din2_i             : std_logic_vector(w - 1 downto 0);
  signal s_din3_r, s_din3_i             : std_logic_vector(w - 1 downto 0);
  signal s_din4_r, s_din4_i             : std_logic_vector(w - 1 downto 0);
  signal s_din5_r, s_din5_i             : std_logic_vector(w - 1 downto 0);
  signal s_din6_r, s_din6_i             : std_logic_vector(w - 1 downto 0);
  signal s_din7_r, s_din7_i             : std_logic_vector(w - 1 downto 0);
begin

TopFSM_Inst : TOP_FSM
    generic map(
        w=> w
    )
  port map(
  clk       => clk,
  rst       => rst,
  din_rts   => din_rts,
  dout_cts  => dout_cts,
  end_stage => s_end_stage,


  Load => s_Load,
  endComm => s_endComm,
  

  din_cts   => din_cts,
  dout_rts  => dout_rts,
  start_fft => s_start_stage,
  
  WE_TopFSM => s_WE_TopFSM,
  stage     => s_stage
  );

RAM_Inst : MemRAM
generic map(
        w=> w
    )
port map(
  adr     => s_adr,
  DataIn  => s_DataIn,
  WE      => s_WE,
  clk     => clk,
  reset   => rst,

  DataOut => s_DataOut
);

FFT8 : FFT8_UNIT
generic map(
        w=> (w+2)
    )
port map(
  clk     => clk,
  rst     => rst,
  Data_In  => s_DataOut,
  stage   => s_stage,
  start_stage=> s_start_stage,

  WE        => s_WE_Unit,
  add_out   => s_add_out,
  fulladr   => s_fulladr,
  fin_stage => s_end_stage,
  out0      => s_out0
  );
  
OutRegisters_Inst : OutRegisters
generic map(
        w=> w
    )
  port map(
  DataIn => s_DataInReg,
  clk => clk,
  rst => rst,
  adr_Reg => s_fulladr,
  stage => s_stage,
  we => s_WE_Unit,


  dout0 => dout0,
  dout1 => dout1,
  dout2 => dout2,
  dout3 => dout3,
  dout4 => dout4,
  dout5 => dout5,
  dout6 => dout6,
  dout7 => dout7
  );
  
  COM_Inst : COM
  generic map(
  w => w
  )
  port map(
  clk => clk,
  rst => rst,
  adr_1sge  => s_adr_1sge,
  Data2Mem => s_Data2Mem,
  Load  => s_Load,
  endComm   => s_endComm,
  din0_r => s_din0_r,
  din0_i => s_din0_i,
  din1_r => s_din1_r,
  din1_i => s_din1_i,
  din2_r => s_din2_r,
  din2_i => s_din2_i,
  din3_r => s_din3_r,
  din3_i => s_din3_i,
  din4_r => s_din4_r,
  din4_i => s_din4_i,
  din5_r => s_din5_r,
  din5_i => s_din5_i,
  din6_r => s_din6_r,
  din6_i => s_din6_i,
  din7_r => s_din7_r,
  din7_i => s_din7_i
  );

  s_DataInReg<=s_out0(w-1 downto 0);  

  s_DataIn <= std_logic_vector(resize(signed(s_Data2Mem),32))   when  (s_stage = "11") else
              std_logic_vector(resize(signed(s_out0),32))          when  (s_stage = "00" or s_stage = "01") else
              (others => '0') ;

  s_WE     <= '0'  when (s_stage = "10") else
              (s_WE_Unit or s_WE_TopFSM);


  s_adr    <= s_adr_1sge      when  (s_stage = "11") else
              s_add_out       when  ((s_stage = "00" or s_stage = "01" or s_stage = "10") and (s_WE = '0')) else
              s_fulladr       when  ((s_stage = "00" or s_stage = "01" or s_stage = "10") and (s_WE = '1')) else 
              (others=> '0');

  s_adr_Reg  <= s_fulladr(5 downto 0);

  s_din0_r <= din0(2*w-1 downto w);
  s_din0_i <= din0(w-1 downto 0);
  s_din1_r <= din1(2*w-1 downto w);
  s_din1_i <= din1(w-1 downto 0);
  s_din2_r <= din2(2*w-1 downto w);
  s_din2_i <= din2(w-1 downto 0);
  s_din3_r <= din3(2*w-1 downto w);
  s_din3_i <= din3(w-1 downto 0);
  s_din4_r <= din4(2*w-1 downto w);
  s_din4_i <= din4(w-1 downto 0);
  s_din5_r <= din5(2*w-1 downto w);
  s_din5_i <= din5(w-1 downto 0);
  s_din6_r <= din6(2*w-1 downto w);
  s_din6_i <= din6(w-1 downto 0);
  s_din7_r <= din7(2*w-1 downto w);
  s_din7_i <= din7(w-1 downto 0);  
  
  
 -- Si quisiera hacer shift
 
--  s_din0_r <= std_logic_vector(shift_left(signed(din0(2*w-1 downto w)),(w-18)));
--  s_din0_i <= std_logic_vector(shift_left(signed(din0(w-1 downto 0)),(w-18)));
--  s_din1_r <= std_logic_vector(shift_left(signed(din1(2*w-1 downto w)),(w-18)));
--  s_din1_i <= std_logic_vector(shift_left(signed(din1(w-1 downto 0)),(w-18)));
--  s_din2_r <= std_logic_vector(shift_left(signed(din2(2*w-1 downto w)),(w-18)));
--  s_din2_i <= std_logic_vector(shift_left(signed(din2(w-1 downto 0)),(w-18)));
--  s_din3_r <= std_logic_vector(shift_left(signed(din3(2*w-1 downto w)),(w-18)));
--  s_din3_i <= std_logic_vector(shift_left(signed(din3(w-1 downto 0)),(w-18)));
--  s_din4_r <= std_logic_vector(shift_left(signed(din4(2*w-1 downto w)),(w-18)));
--  s_din4_i <= std_logic_vector(shift_left(signed(din4(w-1 downto 0)),(w-18)));
--  s_din5_r <= std_logic_vector(shift_left(signed(din5(2*w-1 downto w)),(w-18)));
--  s_din5_i <= std_logic_vector(shift_left(signed(din5(w-1 downto 0)),(w-18)));
--  s_din6_r <= std_logic_vector(shift_left(signed(din6(2*w-1 downto w)),(w-18)));
--  s_din6_i <= std_logic_vector(shift_left(signed(din6(w-1 downto 0)),(w-18)));
--  s_din7_r <= std_logic_vector(shift_left(signed(din7(2*w-1 downto w)),(w-18)));
--  s_din7_i <= std_logic_vector(shift_left(signed(din7(w-1 downto 0)),(w-18)));
end architecture;
