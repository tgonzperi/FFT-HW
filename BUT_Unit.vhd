library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity BUT_Unit is
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
end BUT_Unit;

-------------------------------------------------------------------------------

architecture archBUT_Unit of  BUT_Unit is

  signal s_selW       : std_logic;
  signal s_selADDSUB  : std_logic_vector(1 downto 0);


  component BUT is
    generic(
      w : natural
    );
    port(
    --Values in/out for fft
      a_r, a_i           : in std_logic_vector(w - 1 downto 0);
      b_r, b_i           : in std_logic_vector(w - 1 downto 0);
      weight_r, weight_i : in std_logic_vector(w downto 0);
      out0               : out std_logic_vector(w downto 0);

    -- Control signals fron FSM
      sel_w               : in std_logic;
      selADDSUB           : in std_logic_vector(1 downto 0)
    );
  end component;

  component FSM_But is
    port(
      clk, rst  : in std_logic;
      adr_MSBs  : in std_logic_vector(3 downto 0);
      start     : in std_logic;

      selADDSUB : out std_logic_vector(1 downto 0);
      selW      : out std_logic;
      fin       : out std_logic;
      fulladr   : out std_logic_vector(5 downto 0);
      WE        : out std_logic
      );
  end component;

begin


  inst_BUT : BUT
  generic map ( w=>w
  )
    port map(
      a_r =>  a_r,
      a_i =>  a_i,
      b_r =>  b_r,
      b_i =>  b_i,
      weight_r  =>  weight_r,
      weight_i  =>  weight_i,

      out0  =>  out0,

      sel_w     => s_selW,
      selADDSUB => s_selADDSUB
    );

  inst_FSM : FSM_But
    port map(
      clk      =>  clk,
      rst      =>  rst,
      adr_MSBs =>  adr_MSBs,
      start    =>  start,
      fulladr  =>  fulladr,

      fin  =>  fin,
      WE   =>  WE,

      selW      => s_selW,
      selADDSUB => s_selADDSUB
    );

end architecture;
