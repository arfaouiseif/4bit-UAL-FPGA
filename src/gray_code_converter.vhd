----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.02.2026 11:11:17
-- Design Name: 
-- Module Name: gray_code_converter - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

----------------------------------------------------------------------------------
-- Module: Convertisseur Gray Code
-- Description: Convertit entre binaire et code Gray
-- Le code Gray est un code binaire où deux valeurs successives 
-- ne diffèrent que d'un seul bit
-- 
-- B[0] = 0 : Binaire ? Gray
-- B[0] = 1 : Gray ? Binaire
--
-- Exemples:
-- Binaire ? Gray:
--   0000 ? 0000
--   0001 ? 0001
--   0010 ? 0011
--   0011 ? 0010
--   0100 ? 0110
--   ...
--   1111 ? 1000
--
-- Utilisé dans: encodeurs rotatifs, communication, réduction d'erreurs
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gray_code_converter is
    Port ( 
        A : in STD_LOGIC_VECTOR (3 downto 0);
        B : in STD_LOGIC_VECTOR (3 downto 0);
        result : out STD_LOGIC_VECTOR (3 downto 0);
        carry : out STD_LOGIC;
        zero : out STD_LOGIC;
        sign : out STD_LOGIC
    );
end gray_code_converter;

architecture Behavioral of gray_code_converter is
    signal binary_to_gray : STD_LOGIC_VECTOR(3 downto 0);
    signal gray_to_binary : STD_LOGIC_VECTOR(3 downto 0);
    signal direction : STD_LOGIC;
    signal output : STD_LOGIC_VECTOR(3 downto 0);
    signal bit_transitions : integer range 0 to 4;
begin
    direction <= B(0);  -- 0 = Bin?Gray, 1 = Gray?Bin
    
    -- ========== BINAIRE vers GRAY ==========
    -- Formule: Gray[i] = Binary[i] XOR Binary[i+1]
    -- Le MSB reste identique
    binary_to_gray(3) <= A(3);
    binary_to_gray(2) <= A(3) xor A(2);
    binary_to_gray(1) <= A(2) xor A(1);
    binary_to_gray(0) <= A(1) xor A(0);
    
    -- ========== GRAY vers BINAIRE ==========
    -- Formule: Binary[i] = XOR de tous les bits Gray de i jusqu'au MSB
    gray_to_binary(3) <= A(3);
    gray_to_binary(2) <= A(3) xor A(2);
    gray_to_binary(1) <= A(3) xor A(2) xor A(1);
    gray_to_binary(0) <= A(3) xor A(2) xor A(1) xor A(0);
    
    -- Multiplexeur selon la direction
    process(direction, binary_to_gray, gray_to_binary)
    begin
        if direction = '0' then
            output <= binary_to_gray;
        else
            output <= gray_to_binary;
        end if;
    end process;
    
    -- Compter les transitions (bits qui diffèrent entre entrée et sortie)
    process(A, output)
        variable trans_count : integer range 0 to 4;
    begin
        trans_count := 0;
        for i in 0 to 3 loop
            if A(i) /= output(i) then
                trans_count := trans_count + 1;
            end if;
        end loop;
        bit_transitions <= trans_count;
    end process;
    
    -- Sorties
    result <= output;
    
    -- Carry: '1' si au moins une transition (entrée ? sortie)
    carry <= '1' when bit_transitions > 0 else '0';
    
    -- Zero: '1' si résultat = 0000
    zero <= '1' when output = "0000" else '0';
    
    -- Sign: MSB du résultat
    sign <= output(3);
    
end Behavioral;