----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2019 04:50:06 PM
-- Design Name: 
-- Module Name: FFT8_UNIT - Behavioral
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
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FFT8_UNIT is
     generic( w : natural );
  Port ( 
            clk, rst : in std_logic;
            fin_stage : out std_logic;
            data_in : in std_logic_vector(31 downto 0);
            stage : in std_logic_vector(1 downto 0);
            start_stage: in std_logic;
            out0 : out std_logic_vector(w downto 0);
            we : out std_logic;
            fulladr   : out std_logic_vector(5 downto 0);
           add_out : out STD_LOGIC_VECTOR (5 downto 0)
              );
end FFT8_UNIT;

architecture Behavioral of FFT8_UNIT is

component Unit_Op is 
    generic( w: natural
    );
    port(  
            clk, rst : in std_logic;
            addbutMSB : in std_logic_vector(3 downto 0);
            data_in : in std_logic_vector(31 downto 0);
            stage : in std_logic_vector(1 downto 0);
            num_but : in std_logic_vector(1 downto 0);
            ld_a_r,ld_a_i,ld_b_r,ld_b_i : in std_logic;
            start : in std_logic;
            fin : out std_logic;
            WE : out std_logic;
            out0      : out std_logic_vector(w downto 0);
            fulladr   : out std_logic_vector(5 downto 0) 
    );
  end component;
  
component FSM_stage is
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
end component;
    
    signal aux_addbutMSB : std_logic_vector(3 downto 0);
    signal aux_ld_a_r : std_logic;
    signal aux_ld_a_i : std_logic;
    signal aux_ld_b_r : std_logic;
    signal aux_ld_b_i : std_logic;
    signal aux_num_but_out : std_logic_vector(1 downto 0);
    signal aux_start : std_logic;
    signal aux_fin : std_logic;
    signal aux_we :std_logic;
    signal aux_en_read : std_logic;   
begin

Op : Unit_Op
    generic map(
        w=> w
    )
    port map(
    clk => clk,
    rst => rst,
    stage => stage,
    addbutMSB => aux_addbutMSB,
    num_but => aux_num_but_out,
    ld_a_r => aux_ld_a_r,
    ld_a_i => aux_ld_a_i,
    ld_b_r => aux_ld_b_r,
    ld_b_i => aux_ld_b_i,
    start => aux_start,
    fin=>aux_fin,
    out0=>out0,
    we=>aux_we,
    fulladr=>fulladr,
    data_in => data_in
    );
 FSM : FSM_stage 
    port map(
    
    clk=> clk,
    rst=> rst,
    stage=>stage,
    start_stage=>start_stage,
    en_read =>aux_en_read,
    add_out =>add_out,
    addbutMSB => aux_addbutMSB,
    num_but_out => aux_num_but_out,
    ld_a_r => aux_ld_a_r,
    ld_a_i => aux_ld_a_i,
    ld_b_r => aux_ld_b_r,
    ld_b_i => aux_ld_b_i,
    start => aux_start,
    fin=>aux_fin
    );
    
 fin_stage<= aux_num_but_out(1) and aux_num_but_out(0) and aux_fin;
    WE<= aux_we or aux_en_read;
    
end Behavioral;
