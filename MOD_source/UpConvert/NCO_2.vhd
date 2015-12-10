library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity NCO_2 is
generic (    
      kNCOSize  :  positive := 16;
      kFreSize  :  positive := 11
       );

port(
     Clk                : in std_logic;
     aReset             : in std_logic;
     DataValid          : in std_logic;
     InitialPhase       : in unsigned(kFreSize-1 downto 0);
     InPhase            : in unsigned(kFreSize-1 downto 0);
     I_fac              : out std_logic_vector(kNCOSize-1 downto 0);
     Q_fac              : out std_logic_vector(kNCOSize-1 downto 0);
     DataRdy            : out std_logic
     );
end NCO_2;


architecture rtl of NCO_2 is

constant inRomSize  : positive :=11;
constant kAccSize   : positive :=11;
signal NcoAccum     : unsigned (kAccSize-1 downto 0);
signal PhaseFinal   : std_logic_vector ( inRomSize-1 downto 0 );
signal SinPhase,CosPhase       : std_logic_vector ( kNCOSize-1  downto 0 );



component CosData 
     port(
          address       : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
          clock         : IN STD_LOGIC ;
          q             : OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
end component;

component SinData 
     port(
          address       : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
          clock         : IN STD_LOGIC ;
          q             : OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
end component;


begin


Cosin:CosData
port map (
          address => PhaseFinal,
          clock     => Clk,
          q       => CosPhase
         );

Sine:Sindata
port map (
          address =>PhaseFinal,
          clock     =>Clk,
          q       =>SinPhase
         );
         
Process (aReset,clk)
        variable vInPhase : unsigned(kAccSize-1 downto 0);
 begin
      if (aReset = '1') then
         NcoAccum <= InitialPhase;--(others =>'0');--(kInSize-1 downto 12 => '1', others=>'0');
         PhaseFinal <= (others=>'0');
        elsif (clk'event and clk ='1') then
          if (DataValid = '1') then
            vInPhase := InPhase;
            NcoAccum<=NcoAccum+vInPhase;     
            PhaseFinal  <= std_logic_vector(NcoAccum);  
            I_fac<=CosPhase;    --(SinPhase(10 downto 0))&("00000");
            Q_fac<=SinPhase;    --(CosPhase(10 downto 0))&("00000");
    
          end if;
      end if;
end process;

  process(aReset, Clk)
  begin
    if aReset='1' then
      DataRdy <= '0';
    elsif rising_edge(Clk) then
      DataRdy <= DataValid;
    end if;
  end process;

end rtl;
            
            

                        
                        
                        
            
