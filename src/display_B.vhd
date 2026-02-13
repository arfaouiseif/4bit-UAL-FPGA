----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2026 22:46:37
-- Design Name: 
-- Module Name: display_B - Behavioral
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

entity display_B is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           result : out STD_LOGIC_VECTOR (3 downto 0);
           seg_out : out STD_LOGIC_VECTOR (6 downto 0);
           carry : out STD_LOGIC;
           zero : out STD_LOGIC;
           sign : out STD_LOGIC);
end display_B;

architecture Behavioral of display_B is
    component hex_to_7seg
        Port ( 
            hex_in : in STD_LOGIC_VECTOR (3 downto 0);
            seg_out : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;
begin
    -- Instanciation du décodeur
    decoder : hex_to_7seg
        port map (
            hex_in => B,
            seg_out => seg_out
        );
    
    -- Sorties
    result <= B;
    carry <= '0';
    zero <= '1' when B = "0000" else '0';
    sign <= B(3);
    
end Behavioral;

