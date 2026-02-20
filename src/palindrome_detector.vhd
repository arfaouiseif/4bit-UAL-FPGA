----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.02.2026 11:09:40
-- Design Name: 
-- Module Name: palindrome_detector - Behavioral
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


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

----------------------------------------------------------------------------------
-- Module: Détecteur de Palindrome
-- Description: Vérifie si A est un palindrome binaire
-- Un palindrome binaire se lit identiquement de gauche à droite et de droite à gauche
-- Exemples: 0110, 1001, 0000, 1111, 1001 sont des palindromes
--           0100, 1010, 0011 ne sont PAS des palindromes
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity palindrome_detector is
    Port ( 
        A : in STD_LOGIC_VECTOR (3 downto 0);
        B : in STD_LOGIC_VECTOR (3 downto 0);
        result : out STD_LOGIC_VECTOR (3 downto 0);
        carry : out STD_LOGIC;
        zero : out STD_LOGIC;
        sign : out STD_LOGIC
    );
end palindrome_detector;

architecture Behavioral of palindrome_detector is
    signal is_palindrome : STD_LOGIC;
    signal reversed_A : STD_LOGIC_VECTOR(3 downto 0);
    signal sym_pair_0_3 : STD_LOGIC;
    signal sym_pair_1_2 : STD_LOGIC;
    signal symmetry_count : STD_LOGIC_VECTOR(1 downto 0);
begin
    -- Inverser l'ordre des bits de A
    reversed_A <= A(0) & A(1) & A(2) & A(3);
    
    -- Vérifier si A est un palindrome
    is_palindrome <= '1' when A = reversed_A else '0';
    
    -- Vérifier chaque paire de bits symétriques
    sym_pair_0_3 <= '1' when A(0) = A(3) else '0';
    sym_pair_1_2 <= '1' when A(1) = A(2) else '0';
    
    -- Compter les paires symétriques (0, 1, ou 2)
    process(sym_pair_0_3, sym_pair_1_2)
    begin
        if sym_pair_0_3 = '1' and sym_pair_1_2 = '1' then
            symmetry_count <= "10";  -- 2 paires
        elsif sym_pair_0_3 = '1' or sym_pair_1_2 = '1' then
            symmetry_count <= "01";  -- 1 paire
        else
            symmetry_count <= "00";  -- 0 paire
        end if;
    end process;
    
    -- Sorties
    -- result[0] = palindrome détecté
    -- result[2:1] = nombre de paires symétriques (0-2)
    -- result[3] = '0' (réservé)
    result <= '0' & symmetry_count & is_palindrome;
    
    -- Carry: '1' si palindrome parfait
    carry <= is_palindrome;
    
    -- Zero: '1' si aucune symétrie
    zero <= '1' when symmetry_count = "00" else '0';
    
    -- Sign: '1' si symétrie partielle (au moins 1 paire)
    sign <= '1' when symmetry_count /= "00" else '0';
    
end Behavioral;