library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.config_pkg.all;  -- ?????

entity tb_priority_encoder is
end tb_priority_encoder;

architecture Behavioral of tb_priority_encoder is
    signal DIN  : std_logic_vector(WIDTH-1 downto 0);
    signal DZ   : std_logic;
    signal DOUT : std_logic_vector(7 downto 0);
    
    component priority_encoder is
        port (
            DIN  : in  std_logic_vector(WIDTH-1 downto 0);
            DZ   : out std_logic;
            DOUT : out std_logic_vector(7 downto 0)
        );
    end component;
begin
    uut: priority_encoder
        port map (
            DIN  => DIN,
            DZ   => DZ,
            DOUT => DOUT
        );
    
    process
    begin
        -- ????1: DIN?0
        DIN <= (others => '0');
        wait for 10 ns;  -- ????
        
        -- ????
        assert (DZ = '1') report "Test Case 1 Failed: DZ should be 1" severity error;
        assert (DOUT = x"00") report "Test Case 1 Failed: DOUT should be 0" severity error;
        
        -- ????2: DIN???1????7?
        DIN <= (others => '0');
        DIN(7) <= '1';
        wait for 10 ns;  -- ????
        
        -- ????
        assert (DZ = '0') report "Test Case 2 Failed: DZ should be 0" severity error;
        assert (DOUT = x"07") report "Test Case 2 Failed: DOUT should be 7" severity error;
        
        -- ????3: DIN???1????100?
        DIN <= (others => '0');
        DIN(100) <= '1';
        wait for 10 ns;  -- ????
        
        -- ????
        assert (DZ = '0') report "Test Case 3 Failed: DZ should be 0" severity error;
        assert (DOUT = x"64") report "Test Case 3 Failed: DOUT should be 100" severity error;
        
        -- ????
        wait;
    end process;
end Behavioral;

