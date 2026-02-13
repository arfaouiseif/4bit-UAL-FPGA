----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2026 22:19:37
-- Design Name: 
-- Module Name: shift_register - Behavioral
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

entity shift_register is
    Port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        A : in STD_LOGIC_VECTOR (3 downto 0);
        B : in STD_LOGIC_VECTOR (3 downto 0);
        result : out STD_LOGIC_VECTOR (3 downto 0);
        carry : out STD_LOGIC;
        zero : out STD_LOGIC;
        sign : out STD_LOGIC
    );
end shift_register;

architecture Behavioral of shift_register is
    signal reg : STD_LOGIC_VECTOR(3 downto 0);
    signal direction : STD_LOGIC;  -- B(0): 0=left, 1=right
    signal mode : STD_LOGIC;       -- B(1): 0=logical, 1=circular
begin
    direction <= B(0);
    mode <= B(1);
    
    process(clk, reset)
    begin
        if reset = '1' then
            reg <= A;
        elsif rising_edge(clk) then
            if direction = '0' then
                -- Décalage à gauche
                if mode = '1' then
                    -- Circulaire: MSB va en LSB
                    reg <= reg(2 downto 0) & reg(3);
                else
                    -- Logique: insertion de '0'
                    reg <= reg(2 downto 0) & '0';
                end if;
            else
                -- Décalage à droite
                if mode = '1' then
                    -- Circulaire: LSB va en MSB
                    reg <= reg(0) & reg(3 downto 1);
                else
                    -- Logique: insertion de '0'
                    reg <= '0' & reg(3 downto 1);
                end if;
            end if;
        end if;
    end process;
    
    -- Sorties
    result <= reg;
    
    -- Carry: bit qui sort lors du décalage
    --carry <= reg(3) when direction = '0' else reg(0);
    carry <= '0';
    -- Zero flag
    zero <= '1' when reg = "0000" else '0';
    
    -- Sign flag
    sign <='0';
    
end Behavioral;