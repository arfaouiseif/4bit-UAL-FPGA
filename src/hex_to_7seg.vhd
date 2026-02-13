----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2026 22:34:05
-- Design Name: 
-- Module Name: hex_to_7seg - Behavioral
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
--     a
--   -----
-- f|     |b
--   --g--
-- e|     |c
--   -----
--     d
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

entity hex_to_7seg is
    Port ( 
        hex_in : in STD_LOGIC_VECTOR (3 downto 0);
        seg_out : out STD_LOGIC_VECTOR (6 downto 0)  -- abcdefg
    );
end hex_to_7seg;

architecture Behavioral of hex_to_7seg is
begin
    process(hex_in)
    begin
        case hex_in is
            when "0000" => seg_out <= "0000001";  -- 0
            when "0001" => seg_out <= "1001111";  -- 1
            when "0010" => seg_out <= "0010010";  -- 2
            when "0011" => seg_out <= "0000110";  -- 3
            when "0100" => seg_out <= "1001100";  -- 4
            when "0101" => seg_out <= "0100100";  -- 5
            when "0110" => seg_out <= "0100000";  -- 6
            when "0111" => seg_out <= "0001111";  -- 7
            when "1000" => seg_out <= "0000000";  -- 8
            when "1001" => seg_out <= "0000100";  -- 9
            when "1010" => seg_out <= "0001000";  -- A
            when "1011" => seg_out <= "1100000";  -- b
            when "1100" => seg_out <= "0110001";  -- C
            when "1101" => seg_out <= "1000010";  -- d
            when "1110" => seg_out <= "0110000";  -- E
            when "1111" => seg_out <= "0111000";  -- F
            when others => seg_out <= "1111111";  -- Éteint
        end case;
    end process;
end Behavioral;
