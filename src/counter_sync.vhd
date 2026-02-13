----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2026 22:27:54
-- Design Name: 
-- Module Name: counter_sync - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter_sync is
    Port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        A : in STD_LOGIC_VECTOR (3 downto 0);  -- Valeur de départ
        B : in STD_LOGIC_VECTOR (3 downto 0);  -- Contrôle
        result : out STD_LOGIC_VECTOR (3 downto 0);
        carry : out STD_LOGIC;
        zero : out STD_LOGIC;
        sign : out STD_LOGIC
    );
end counter_sync;

architecture Behavioral of counter_sync is
    signal count : unsigned(3 downto 0);
    signal direction : STD_LOGIC;  -- B(0): 0=up, 1=down
    signal enable : STD_LOGIC;     -- B(1): 1=enable, 0=pause
    signal overflow : STD_LOGIC;
begin
    direction <= B(0);
    enable <= B(1);
    
    process(clk, reset)
    begin
        if reset = '1' then
            count <= unsigned(A);  -- Initialisation avec A
            overflow <= '0';
        elsif rising_edge(clk) then
            if enable = '1' then
                overflow <= '0';
                if direction = '0' then
                    -- Comptage croissant
                    if count = "1111" then
                        count <= "0000";
                        overflow <= '1';
                    else
                        count <= count + 1;
                    end if;
                else
                    -- Comptage décroissant
                    if count = "0000" then
                        count <= "1111";
                        overflow <= '1';
                    else
                        count <= count - 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    -- Sorties
    result <= std_logic_vector(count);
    carry <= overflow;  -- Débordement/sous-débordement
    zero <= '1' when count = "0000" else '0';
    sign <= count(3);
    
end Behavioral;
