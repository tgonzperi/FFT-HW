library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BUT is
  generic(
    w : natural
  );
  port(

  --Values in/out for fft
    a_r, a_i : in std_logic_vector(w - 1 downto 0);
    b_r, b_i : in std_logic_vector(w - 1 downto 0);
    weight_r, weight_i : in std_logic_vector(w downto 0);
    out0 : out std_logic_vector(w downto 0);

  -- Control signals fron FSM
    selADDSUB : in std_logic_vector(1 downto 0);
    sel_w : in std_logic
  );
end BUT;


architecture archBUT of BUT is
signal s_a_r, s_a_i : signed(w-1 downto 0);  -- on w bits
  signal s_b_r, s_b_i       : signed(w-1 downto 0);  -- on w bits
  signal w1, w2 : signed(w downto 0);    -- on w+1 bits to be
                                                         -- able to code 1.0 and
                                                         -- so that the
                                                         -- rightmost bit of the
                                                         -- first operand can mitigate the
                                                         -- leftmost bit of the
                                                         -- multiplication result.
   signal r_mult1 ,r_mult2 : signed(w+1 downto 0);

  function round_signed (
    constant output_size : natural;
    input                : signed)
    return signed is
    variable result : signed(output_size -1 downto 0);
  begin
    if input(input'length-output_size-1) = '1' then
      result := input(input'length-1 downto input'length-output_size) + 1;
    else
      result := input(input'length-1 downto input'length-output_size);
    end if;
    --VHDL 2008:
    --result := input(input'length-1 downto input'length-output_size) + 1 when input(input'length-output_size-1)='1' else input(input'length-1 downto input'length-output_size);
    return result;
  end round_signed;

begin
  s_b_r <= signed(b_r);
  s_b_i <= signed(b_i);
  s_a_r <= signed(a_r);
  s_a_i <= signed(a_i);

  w1<= signed(weight_r) when (sel_w = '0') else
       signed(weight_i);
  w2<= signed(weight_r) when (sel_w = '1') else
       signed(weight_i);

--    a<= signed(a_r) when (sel_a = '0') else
--         signed(a_i);

  r_mult1 <= round_signed(w+2,s_b_r*w1);
  r_mult2 <= round_signed(w+2,s_b_i*w2);

  out0 <= std_logic_vector(resize(s_a_r, w+1) + (resize(r_mult1, w+1) - resize(r_mult2, w+1))) when (selADDSUB= "00") else
          std_logic_vector(resize(s_a_i, w+1) + (resize(r_mult1, w+1) + resize(r_mult2, w+1))) when (selADDSUB= "01") else
          std_logic_vector(resize(s_a_r, w+1) - (resize(r_mult1, w+1) - resize(r_mult2, w+1))) when (selADDSUB= "10") else
          std_logic_vector(resize(s_a_i, w+1) - (resize(r_mult1, w+1) + resize(r_mult2, w+1)));
--case selADDSUB is
--    when "00" => out0 <= std_logic_vector(resize(s_a_r, w+1) + (resize(round_signed(w+2, s_b_r * s_weight_r), w+1) - resize(round_signed(w+2, s_b_i * s_weight_i), w+1))) when (selADDSUB= "00") else
--    when "01" => out0 <= std_logic_vector(resize(s_a_i, w+1) + (resize(round_signed(w+2, s_b_r * s_weight_i), w+1) + resize(round_signed(w+2, s_b_i * s_weight_r), w+1)))
--    when "10" => out0 <= std_logic_vector(resize(s_a_r, w+1) - (resize(round_signed(w+2, s_b_r * s_weight_r), w+1) - resize(round_signed(w+2, s_b_i * s_weight_i), w+1)))
--    when "11" => out0 <= std_logic_vector(resize(s_a_i, w+1) - (resize(round_signed(w+2, s_b_r * s_weight_i), w+1) + resize(round_signed(w+2, s_b_i * s_weight_r), w+1)))
end architecture archBUT;
