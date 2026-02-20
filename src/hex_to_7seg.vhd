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
        seg_out : out STD_LOGIC_VECTOR (6 downto 0)  -- segments: (6=>a,5=>b,4=>c,3=>d,2=>e,1=>f,0=>g)
    );
end hex_to_7seg;

architecture Behavioral of hex_to_7seg is
begin
    process(hex_in)
    begin
        case hex_in is
            when "0000" => seg_out <= "1000000";  -- 0 (tous segments allumés sauf g)
            when "0001" => seg_out <= "1111001";  -- 1 (segments b et c allumés)
            when "0010" => seg_out <= "0100100";  -- 2
            when "0011" => seg_out <= "0110000";  -- 3
            when "0100" => seg_out <= "0011001";  -- 4
            when "0101" => seg_out <= "0010010";  -- 5
            when "0110" => seg_out <= "0000010";  -- 6
            when "0111" => seg_out <= "1111000";  -- 7
            when "1000" => seg_out <= "0000000";  -- 8 (tous segments allumés)
            when "1001" => seg_out <= "0010000";  -- 9
            when "1010" => seg_out <= "0001000";  -- A
            when "1011" => seg_out <= "0000011";  -- b
            when "1100" => seg_out <= "1000110";  -- C
            when "1101" => seg_out <= "0100001";  -- d
            when "1110" => seg_out <= "0000110";  -- E
            when "1111" => seg_out <= "0001110";  -- F
            when others => seg_out <= "1111111";  -- Tous éteints
        end case;
    end process;
end Behavioral;