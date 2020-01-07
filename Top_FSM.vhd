library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TOP_FSM is
  generic(
    w : natural
  );
  port(

    clk, rst           : in std_logic;
    din_rts, dout_cts  : in std_logic;
    end_stage          : in std_logic;
    endComm            : in std_logic;

    din_cts, dout_rts  : out std_logic;
    start_fft          : out std_logic;
    WE_TopFSM          : out std_logic;
    stage              : out std_logic_vector(1 downto 0);
    Load               : out std_logic


  );
end TOP_FSM;


architecture archTOP_FSM of TOP_FSM is

  type FSM_STATE is (Init, Input2Mem, Stage1, Stage2, Stage3, WaitState);
  signal  current_state, next_state : FSM_STATE;



begin

updateState: process(clk,rst)
  begin
    if(rst = '1')then
      current_state <= Init;
    elsif RISING_EDGE(clk) then
      current_state <= next_state;
    end if;
  end process;


StateCalcul: process(current_state,end_stage,din_rts,endComm,dout_cts)
  begin
    din_cts <= '0';
    start_fft <= '0';
    dout_rts <= '0';
    WE_TopFSM <=  '0';
    Load <= '0';
    stage <= "00";

    case current_state is
      when Init =>
        if (din_rts = '1') then
          next_state <= Input2Mem;
          WE_TopFSM <=  '1';
        else
          next_state <= Init;
        end if;

      when Input2Mem =>
        if endComm = '1' then
          next_state <= Stage1;
          din_cts <= '1';
        else 
           next_state <= Input2Mem; 
        end if;
        stage <= "11";
        WE_TopFSM <=  '1';
        Load <= '1';
      when Stage1 =>
        if(end_stage = '1') then
          next_state <= Stage2;
        else
          next_state <= Stage1;
        end if;
        stage <=  "00";
        start_fft <= '1';

      when Stage2 =>
        if(end_stage = '1')then
          next_state <= Stage3;
          else 
          next_state<= Stage2;
        end if;
        stage <=  "01";
        start_fft<= '1';

      when Stage3 =>
        if(end_stage = '1')then
          next_state <= WaitState;
          dout_rts <= '1';
          else 
          next_state<=Stage3;
        end if;
        stage <=  "10";
        start_fft<= '1';

      when WaitState =>
        dout_rts <= '1';
        if(dout_cts = '1')then
          next_state <= Init;
        else 
          next_state<= WaitState;  
        end if;
    end case;
--      case adr_aux is
--    when 0  => MemData_aux <= din0_r;
--    when 1  => MemData_aux <= din0_i;
--    when 2  => MemData_aux <= din1_r;
--    when 3  => MemData_aux <= din1_i;
--    when 4  => MemData_aux <= din2_r;
--    when 5  => MemData_aux <= din2_i;
--    when 6  => MemData_aux <= din3_r;
--    when 7  => MemData_aux <= din3_i;
--    when 8  => MemData_aux <= din4_r;
--    when 9  => MemData_aux <= din4_i;
--    when 10 => MemData_aux <= din5_r;
--    when 11 => MemData_aux <= din5_i;
--    when 12 => MemData_aux <= din6_r;
--    when 13 => MemData_aux <= din6_i;
--    when 14 => MemData_aux <= din7_r;
--    when 15 => MemData_aux <= din7_i;
--    when others => MemData_aux<= din0_r;
--  end case;
  end process;
end architecture;
