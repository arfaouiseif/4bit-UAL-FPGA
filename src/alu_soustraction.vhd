----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2026 21:23:50
-- Design Name: 
-- Module Name: alu_soustraction - Behavioral
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

entity alu_soustraction is
    Port ( 
        A : in STD_LOGIC_VECTOR (3 downto 0);
        B : in STD_LOGIC_VECTOR (3 downto 0);
        result : out STD_LOGIC_VECTOR (3 downto 0);
        carry : out STD_LOGIC;  -- Emprunt (borrow)
        zero : out STD_LOGIC;
        sign : out STD_LOGIC
    );
end alu_soustraction;

architecture Behavioral of alu_soustraction is
    signal temp_result : STD_LOGIC_VECTOR(4 downto 0);
begin
    process(A, B)
    begin
        -- Soustraction: A - B = A + (complément à 2 de B)
        temp_result <= std_logic_vector(unsigned('0' & A) - unsigned('0' & B));
        
        -- Résultat sur 4 bits
        result <= temp_result(3 downto 0);
        
        -- Flag Carry (Borrow): '1' si A < B
        carry <= temp_result(4);
        
        -- Flag Zero
        if temp_result(3 downto 0) = "0000" then
            zero <= '1';
        else
            zero <= '0';
        end if;
        
        -- Flag Sign
        sign <= temp_result(3);
    end process;
end Behavioral;