library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity RSSI_p4 is
  generic (
  kInSize : positive := 8
  );
  port (
  aReset  : in std_logic;
  clk     : in std_logic;

  d_in_I0  : std_logic_vector(kInSize-1 downto 0);
  d_in_I1  : std_logic_vector(kInSize-1 downto 0);
  d_in_I2  : std_logic_vector(kInSize-1 downto 0);
  d_in_I3  : std_logic_vector(kInSize-1 downto 0);
  d_in_Q0  : std_logic_vector(kInSize-1 downto 0);
  d_in_Q1  : std_logic_vector(kInSize-1 downto 0);
  d_in_Q2  : std_logic_vector(kInSize-1 downto 0);
  d_in_Q3  : std_logic_vector(kInSize-1 downto 0);
  val_in  : std_logic;



  );
end entity;

architecture arch of RSSI_p4 is

begin

end architecture;
