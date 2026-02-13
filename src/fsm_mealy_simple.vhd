----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2026 21:31:44
-- Design Name: 
-- Module Name: fsm_mealy_simple - Behavioral
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

entity fsm_mealy_simple is
    Port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        A : in STD_LOGIC_VECTOR (3 downto 0);
        result : out STD_LOGIC_VECTOR (3 downto 0);
        carry : out STD_LOGIC;
        zero : out STD_LOGIC;
        sign : out STD_LOGIC
    );
end fsm_mealy_simple;

architecture Behavioral of fsm_mealy_simple is
    type state_type is (S0, S1, S2, S3, S_DETECT);
    signal current_state, next_state : state_type;
    signal input_bit : STD_LOGIC;
    signal sequence_detected : STD_LOGIC;
begin
    -- detection de 1011
    -- On utilise le LSB de A comme entrée série
    input_bit <= A(0);
    
    -- Registre d'état
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= S0;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
    
    -- Logique de transition (Mealy: dépend de l'état ET de l'entrée)
    process(current_state, input_bit)
    begin
        sequence_detected <= '0';
        
        case current_state is
            when S0 =>
                if input_bit = '1' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;
                
            when S1 =>
                if input_bit = '0' then
                    next_state <= S2;
                else
                    next_state <= S1;
                end if;
                
            when S2 =>
                if input_bit = '1' then
                    next_state <= S3;
                else
                    next_state <= S0;
                end if;
                
            when S3 =>
                if input_bit = '1' then
                    sequence_detected <= '1';  -- Sortie Mealy
                    next_state <= S1;
                else
                    next_state <= S2;
                end if;
                
            when others =>
                next_state <= S0;
        end case;
    end process;
    
    -- Sorties
    result <= "000" & sequence_detected;
    carry <= '0';
    zero <= not sequence_detected;
    sign <= '0';
    
end Behavioral;