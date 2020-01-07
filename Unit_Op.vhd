----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2019 05:53:12 PM
-- Design Name: 
-- Module Name: Unit_Op - Behavioral
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
use ieee.numeric_std.all;
use ieee.math_real.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Unit_Op is
    generic( w: integer
    );
  Port ( 
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
end Unit_Op;

architecture Behavioral of Unit_Op is

  component BUT_Unit is
    generic(
      w : natural
    );
    port(
      clk, rst           : in std_logic;
      adr_MSBs           : in std_logic_vector(3 downto 0);
      start              : in std_logic;
      a_r, a_i           : in std_logic_vector(w - 1 downto 0);
      b_r, b_i           : in std_logic_vector(w - 1 downto 0);
      weight_r, weight_i : in std_logic_vector(w downto 0);

      out0               : out std_logic_vector(w downto 0);
      fulladr            : out std_logic_vector(5 downto 0);
      fin                : out std_logic;
      WE                 : out std_logic
      );
  end component;    
      
constant w0_r : std_logic_vector(w downto 0) := std_logic_vector(to_signed(integer(round(1.0*real(2**(w-1)))),w+1));
constant w0_i : std_logic_vector(w downto 0) := std_logic_vector(to_signed(integer(round(0.0*real(2**(w-1)))),w+1));      
constant w1_r : std_logic_vector(w downto 0) := std_logic_vector(to_signed(integer(round(0.7071067812*real(2**(w-1)))),w+1)); 
constant w1_i : std_logic_vector(w downto 0) := std_logic_vector(to_signed(integer(round(-0.7071067812*real(2**(w-1)))),w+1));
constant w2_r : std_logic_vector(w downto 0) := std_logic_vector(to_signed(integer(round(0.0*real(2**(w-1)))),w+1));
constant w2_i : std_logic_vector(w downto 0) := std_logic_vector(to_signed(integer(round(-1.0*real(2**(w-1)))),w+1));
constant w3_r : std_logic_vector(w downto 0) := std_logic_vector(to_signed(integer(round(-0.7071067812*real(2**(w-1)))),w+1)); 
constant w3_i : std_logic_vector(w downto 0) := std_logic_vector(to_signed(integer(round(-0.7071067812*real(2**(w-1)))),w+1));        
      
  signal a_r,a_i,b_r,b_i : std_logic_vector ( w-1 downto 0);
  signal aux : std_logic_vector (w-1 downto 0);
  signal w_r,w_i : std_logic_vector(w downto 0); 

begin

  BUT : BUT_Unit
  generic map(
        w=> w
    )
  port map(
    clk => clk,
    rst => rst,
    adr_MSBs => addbutMSB,
    start => start,
    a_r => a_r,
    a_i => a_i,
    b_r => b_r,
    b_i => b_i,
    weight_i => w_i,
    weight_r => w_r,
    out0 => out0,
    fulladr => fulladr,
    fin => fin,
    WE => WE
  );
  
  
process (clk,rst,stage,data_in)
begin
    if stage ="00" then 
     aux<= std_logic_vector(resize(signed(Data_In(w-3 downto 0)),w));
     elsif stage= "01" then
     aux<= std_logic_vector(resize(signed(Data_In(w-2 downto 0)),w));
     else 
     aux <= std_logic_vector(resize(signed(Data_In(w-1 downto 0)),w));
     end if;
      
      if(rst = '1')then
        a_r <= (others => '0');
        a_i <= (others => '0');
        b_r <= (others => '0');
        b_i <= (others => '0');
      elsif RISING_EDGE(clk) then
        if(ld_a_r = '1') then
           a_r<= aux;
        end if;  
       if(ld_a_i = '1') then
          a_i <= aux;
        end if;  
       if(ld_b_r = '1') then
          b_r <= aux;
        end if;  
       if(ld_b_i = '1') then
          b_i <= aux;
        end if; 
      end if;
end process;

  w_r <= w0_r when (stage= "00") or (stage="01" and num_but = "00") or (stage="01" and num_but="10") or( stage="10" and num_but="00") else
         w1_r when (stage="10" and num_but="01") else
         w2_r when (stage="10" and num_but="10") or (stage="01" and num_but = "01") or (stage="01" and num_but="11") else 
         w3_r;
  w_i <= w0_i when (stage= "00") or (stage="01" and num_but = "00") or (stage="01" and num_but="10") or( stage="10" and num_but="00") else
         w1_i when (stage="10" and num_but="01") else
         w2_i when (stage="10" and num_but="10") or (stage="01" and num_but = "01") or (stage="01" and num_but="11") else 
         w3_i;         

end Behavioral;
