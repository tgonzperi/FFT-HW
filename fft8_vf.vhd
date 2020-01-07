----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2019 04:45:57 PM
-- Design Name: 
-- Module Name: fft8_vf - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM_stage is
    Port (  clk,rst : in STD_LOGIC;
            fin_stage : out std_logic;
            addbutMSB : out STD_LOGIC_VECTOR (3 downto 0);
            stage : in std_logic_vector (1 downto 0);
            start_stage : in std_logic;
            
     --memory control.
           en_read : out std_logic;
           add_out : out STD_LOGIC_VECTOR (5 downto 0);
     --op unit control.
           fin : in std_logic;      
           ld_a_r,ld_a_i,ld_b_r,ld_b_i : out std_logic;
           num_but_out : out std_logic_vector(1 downto 0);
           start : out std_logic
           
             
           
   );        
end FSM_stage;

architecture Behavioral of FSM_stage is

type T_state is (RSTs,M1,M2,M3,M4,But,M1_aux,M2_aux,M3_aux,M4_aux);  -- List of states
  signal SR_presentState : T_state;     -- Register for the present state
  signal SC_FuturState   : T_state;     --signal for the futur state
  signal num_but : signed (1 downto 0);
  signal stage_but : signed (3 downto 0);
  signal stage_aux : signed (1 downto 0); 
  signal num_but_aux : signed (1 downto 0);
   
    
begin
 
  stage_but <= signed(stage) & num_but;
  num_but_out <= std_logic_vector(num_but);
  
  BUTNumUpd: process(clk,rst,SR_presentstate) is
  begin  
    if rst ='1' or SR_PresentState=RSTs then
	 num_but <= "00";
	 elsif(rising_edge(Clk))then
	 num_but <= num_but_aux;
	 end if;
  end process;
       
StateUpd: process(clk,rst) is
  begin  
    if rst ='1' then
	 SR_presentState <= RSTs;
	 elsif(rising_edge(Clk))then
	 SR_presentState <= SC_FuturState;
	 end if;
  end process;
  
 
  
State: process (SR_presentState,num_but,start_stage,fin,stage_but) is

  begin  -- process
        
       en_read<= '0';
       ld_a_r<= '0';
       ld_a_i<='0';
       ld_b_r<= '0';
       ld_b_i<='0';
       start<='0';
       fin_stage<='0';
       addbutMSB<="0000";
       add_out<=std_logic_vector(to_unsigned(40,6));
       
    case SR_presentState is
      when RSTs =>
            num_but_aux<= "00";
            if start_stage = '1' then
            SC_FuturState <= M1;
            else 
            SC_FuturState <= RsTs;
            end if;

      
      when M1 =>
      --DEJA PRONTO EL ADD PARA EL LD EN M1         
            case stage_but is 
                when "0000" => add_out <= std_logic_vector(to_unsigned(0,6));
                when "0001" => add_out <= std_logic_vector(to_unsigned(4,6));            
                when "0010" => add_out <= std_logic_vector(to_unsigned(2,6));
                when "0011" => add_out <= std_logic_vector(to_unsigned(6,6));
                when "0100" => add_out <= std_logic_vector(to_unsigned(16,6));
                when "0101" => add_out <= std_logic_vector(to_unsigned(18,6));            
                when "0110" => add_out <= std_logic_vector(to_unsigned(24,6));
                when "0111" => add_out <= std_logic_vector(to_unsigned(26,6));
                when "1000" => add_out <= std_logic_vector(to_unsigned(0,6));
                when "1001" => add_out <= std_logic_vector(to_unsigned(4,6));            
                when "1010" => add_out <= std_logic_vector(to_unsigned(2,6));
                when "1011" => add_out <= std_logic_vector(to_unsigned(6,6)); 
                when others => add_out<=std_logic_vector(to_unsigned(40,6));      
             end case;  
                  
            SC_FuturState <= M1_aux;
            
     when M1_aux =>
          ld_a_r<='1';
          SC_FuturState <= M2;     
            
            
      when M2 =>
      --ADD M2
            case stage_but is 
                when "0000" => add_out <= std_logic_vector(to_unsigned(1,6));
                when "0001" => add_out <= std_logic_vector(to_unsigned(5,6));            
                when "0010" => add_out <= std_logic_vector(to_unsigned(3,6));
                when "0011" => add_out <= std_logic_vector(to_unsigned(7,6));
                when "0100" => add_out <= std_logic_vector(to_unsigned(17,6));
                when "0101" => add_out <= std_logic_vector(to_unsigned(19,6));            
                when "0110" => add_out <= std_logic_vector(to_unsigned(25,6));
                when "0111" => add_out <= std_logic_vector(to_unsigned(27,6));
                when "1000" => add_out <= std_logic_vector(to_unsigned(1,6));
                when "1001" => add_out <= std_logic_vector(to_unsigned(5,6));            
                when "1010" => add_out <= std_logic_vector(to_unsigned(3,6));
                when "1011" => add_out <= std_logic_vector(to_unsigned(7,6));
                when others => add_out<=  std_logic_vector(to_unsigned(40,6));  
             end case; 
          
            SC_FuturState <= M2_aux;
          
     when M2_aux =>
          ld_a_i<='1';
          SC_FuturState <= M3;   
       
                    
      when M3 =>
      --ADD M3
            case stage_but is 
                when "0000" => add_out <= std_logic_vector(to_unsigned(8,6));
                when "0001" => add_out <= std_logic_vector(to_unsigned(12,6));            
                when "0010" => add_out <= std_logic_vector(to_unsigned(10,6));
                when "0011" => add_out <= std_logic_vector(to_unsigned(14,6));
                when "0100" => add_out <= std_logic_vector(to_unsigned(20,6));
                when "0101" => add_out <= std_logic_vector(to_unsigned(22,6));            
                when "0110" => add_out <= std_logic_vector(to_unsigned(28,6));
                when "0111" => add_out <= std_logic_vector(to_unsigned(30,6));
                when "1000" => add_out <= std_logic_vector(to_unsigned(8,6));
                when "1001" => add_out <= std_logic_vector(to_unsigned(12,6));            
                when "1010" => add_out <= std_logic_vector(to_unsigned(10,6));
                when "1011" => add_out <= std_logic_vector(to_unsigned(14,6));
                when others => add_out<=std_logic_vector(to_unsigned(40,6));
            end case;                  
            SC_FuturState <= M3_aux;
            
        when M3_aux =>
          ld_b_r<='1';
          SC_FuturState <= M4;
            
       when M4 =>
            --ADD M4   
            case stage_but is 
                when "0000" => add_out <= std_logic_vector(to_unsigned(9,6));
                when "0001" => add_out <= std_logic_vector(to_unsigned(13,6));            
                when "0010" => add_out <= std_logic_vector(to_unsigned(11,6));
                when "0011" => add_out <= std_logic_vector(to_unsigned(15,6));
                when "0100" => add_out <= std_logic_vector(to_unsigned(21,6));
                when "0101" => add_out <= std_logic_vector(to_unsigned(23,6));            
                when "0110" => add_out <= std_logic_vector(to_unsigned(29,6));
                when "0111" => add_out <= std_logic_vector(to_unsigned(31,6));
                when "1000" => add_out <= std_logic_vector(to_unsigned(9,6));
                when "1001" => add_out <= std_logic_vector(to_unsigned(13,6));            
                when "1010" => add_out <= std_logic_vector(to_unsigned(11,6));
                when "1011" => add_out <= std_logic_vector(to_unsigned(15,6));
                when others => add_out<= std_logic_vector(to_unsigned(40,6));
                end case;            
     
            SC_FuturState <= M4_aux;
       
        when M4_aux =>
          ld_b_i<='1';
          SC_FuturState <= BUT;    
                                
       when BUT =>
        case stage_but is 
                when "0000" => addbutMSB <= "0100";--16
                when "0001" => addbutMSB <= "0101";--20                
                when "0010" => addbutMSB <= "0110";--24
                when "0011" => addbutMSB <= "0111";--28
                when "0100" => addbutMSB <= "0000";--0
                when "0101" => addbutMSB <= "0001";--4           
                when "0110" => addbutMSB <= "0010";--8
                when "0111" => addbutMSB <= "0011";--12
              -- manejo de addres de los registros de salidad. 
                when "1000" => addbutMSB <= "0000"; --R0
                when "1001" => addbutMSB <= "0001"; --R4         
                when "1010" => addbutMSB <= "0010"; --R8
                when "1011" => addbutMSB <= "0011";--R12
                when others => addbutMSB<="0000";
        end case;  
        start<='1';
        if fin='1' then 
           if num_but = "00" then
                num_but_aux <= "01";
                SC_FuturState<=M1;
           elsif num_but = "01" then
                num_but_aux <= "10";
                SC_FuturState<=M1;
           elsif num_but = "10" then
                num_but_aux <= "11";
                SC_FuturState<=M1;  
           else
                SC_FuturState<=rsts; 
                fin_stage<='1';     
        end if;   
        else 
        SC_FuturState<=BUT;
        end if;                       
    end case;
  end process;  


end Behavioral;
