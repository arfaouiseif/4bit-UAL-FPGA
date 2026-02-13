----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2026 21:22:23
-- Design Name: 
-- Module Name: alu_addition - Behavioral
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

entity alu_addition is
    Port ( 
        A : in STD_LOGIC_VECTOR (3 downto 0);
        B : in STD_LOGIC_VECTOR (3 downto 0);
        result : out STD_LOGIC_VECTOR (3 downto 0);
        carry : out STD_LOGIC;
        zero : out STD_LOGIC;
        sign : out STD_LOGIC
    );
end alu_addition;

architecture Behavioral of alu_addition is
    signal temp_result : STD_LOGIC_VECTOR(4 downto 0);
begin
    process(A, B)
    begin
        -- Addition avec extension à 5 bits pour capturer le carry
        temp_result <= std_logic_vector(unsigned('0' & A) + unsigned('0' & B));
        
        -- Résultat sur 4 bits
        result <= temp_result(3 downto 0);
        
        -- Flag Carry : bit de poids fort
        carry <= temp_result(4);
        
        -- Flag Zero : tous les bits à 0
        if temp_result(3 downto 0) = "0000" then
            zero <= '1';
        else
            zero <= '0';
        end if;
        
        -- Flag Sign : bit de signe (MSB)
        sign <= temp_result(3);
    end process;
end Behavioral;