----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2026 21:37:34
-- Design Name: 
-- Module Name: fsm_mealy_dual - Behavioral
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

entity fsm_mealy_dual is
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
end fsm_mealy_dual;

architecture Behavioral of fsm_mealy_dual is
    type state_type is (S0, S1, S2, S3);
    signal state_A, next_state_A : state_type;
    signal state_B, next_state_B : state_type;
    signal input_A, input_B : STD_LOGIC;
    signal detect_A, detect_B, both_detected : STD_LOGIC;
begin
    -- Utilisation du LSB comme entrée série
    input_A <= A(0);
    input_B <= B(0);
    
    -- Registres d'état
    process(clk, reset)
    begin
        if reset = '1' then
            state_A <= S0;
            state_B <= S0;
        elsif rising_edge(clk) then
            state_A <= next_state_A;
            state_B <= next_state_B;
        end if;
    end process;
    
    -- FSM pour A (détecte "0110")
    process(state_A, input_A)
    begin
        detect_A <= '0';
        case state_A is
            when S0 =>
                if input_A = '0' then next_state_A <= S1;
                else next_state_A <= S0; end if;
            when S1 =>
                if input_A = '1' then next_state_A <= S2;
                else next_state_A <= S1; end if;
            when S2 =>
                if input_A = '1' then next_state_A <= S3;
                else next_state_A <= S0; end if;
            when S3 =>
                if input_A = '0' then
                    detect_A <= '1';
                    next_state_A <= S1;
                else
                    next_state_A <= S2;
                end if;
        end case;
    end process;
    
    -- FSM pour B (détecte "0110")
    process(state_B, input_B)
    begin
        detect_B <= '0';
        case state_B is
            when S0 =>
                if input_B = '0' then next_state_B <= S1;
                else next_state_B <= S0; end if;
            when S1 =>
                if input_B = '1' then next_state_B <= S2;
                else next_state_B <= S1; end if;
            when S2 =>
                if input_B = '1' then next_state_B <= S3;
                else next_state_B <= S0; end if;
            when S3 =>
                if input_B = '0' then
                    detect_B <= '1';
                    next_state_B <= S1;
                else
                    next_state_B <= S0;
                end if;
        end case;
    end process;
    
    -- Détection simultanée
    both_detected <= detect_A and detect_B;
    
    -- Sorties
    result <= "00" & detect_A & detect_B;
    carry <= both_detected;
    zero <= not (detect_A or detect_B);
    sign <= detect_A;
    
end Behavioral;
