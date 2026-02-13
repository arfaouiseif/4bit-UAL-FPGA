----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2026 22:48:23
-- Design Name: 
-- Module Name: UAL_principale - Behavioral
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

entity UAL_principale is
    Port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        A : in STD_LOGIC_VECTOR (3 downto 0);
        B : in STD_LOGIC_VECTOR (3 downto 0);
        SEL : in STD_LOGIC_VECTOR (3 downto 0);
        result : out STD_LOGIC_VECTOR (3 downto 0);
        seg_display : out STD_LOGIC_VECTOR (6 downto 0);
        carry_flag : out STD_LOGIC;
        zero_flag : out STD_LOGIC;
        sign_flag : out STD_LOGIC
    );
end UAL_principale;

architecture Structural of UAL_principale is
    
    -- Déclaration des composants
    component alu_addition
        Port ( 
            A : in STD_LOGIC_VECTOR (3 downto 0);
            B : in STD_LOGIC_VECTOR (3 downto 0);
            result : out STD_LOGIC_VECTOR (3 downto 0);
            carry : out STD_LOGIC;
            zero : out STD_LOGIC;
            sign : out STD_LOGIC
        );
    end component;
    
    component alu_soustraction
        Port ( 
            A : in STD_LOGIC_VECTOR (3 downto 0);
            B : in STD_LOGIC_VECTOR (3 downto 0);
            result : out STD_LOGIC_VECTOR (3 downto 0);
            carry : out STD_LOGIC;
            zero : out STD_LOGIC;
            sign : out STD_LOGIC
        );
    end component;
    
    component fsm_mealy_simple
        Port ( 
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            A : in STD_LOGIC_VECTOR (3 downto 0);
            result : out STD_LOGIC_VECTOR (3 downto 0);
            carry : out STD_LOGIC;
            zero : out STD_LOGIC;
            sign : out STD_LOGIC
        );
    end component;
    
    component fsm_mealy_dual
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
    end component;
    
    component shift_register
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
    end component;
    
    component counter_sync
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
    end component;
    
    component display_A
        Port ( 
            A : in STD_LOGIC_VECTOR (3 downto 0);
            B : in STD_LOGIC_VECTOR (3 downto 0);
            result : out STD_LOGIC_VECTOR (3 downto 0);
            seg_out : out STD_LOGIC_VECTOR (6 downto 0);
            carry : out STD_LOGIC;
            zero : out STD_LOGIC;
            sign : out STD_LOGIC
        );
    end component;
    
    component display_B
        Port ( 
            A : in STD_LOGIC_VECTOR (3 downto 0);
            B : in STD_LOGIC_VECTOR (3 downto 0);
            result : out STD_LOGIC_VECTOR (3 downto 0);
            seg_out : out STD_LOGIC_VECTOR (6 downto 0);
            carry : out STD_LOGIC;
            zero : out STD_LOGIC;
            sign : out STD_LOGIC
        );
    end component;
    
    component hex_to_7seg
        Port ( 
            hex_in : in STD_LOGIC_VECTOR (3 downto 0);
            seg_out : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;
    
    -- Signaux internes pour chaque opération
    signal res_add, res_sub, res_fsm1, res_fsm2 : STD_LOGIC_VECTOR(3 downto 0);
    signal res_shift, res_count, res_dispA, res_dispB : STD_LOGIC_VECTOR(3 downto 0);
    
    signal carry_add, carry_sub, carry_fsm1, carry_fsm2 : STD_LOGIC;
    signal carry_shift, carry_count, carry_dispA, carry_dispB : STD_LOGIC;
    
    signal zero_add, zero_sub, zero_fsm1, zero_fsm2 : STD_LOGIC;
    signal zero_shift, zero_count, zero_dispA, zero_dispB : STD_LOGIC;
    
    signal sign_add, sign_sub, sign_fsm1, sign_fsm2 : STD_LOGIC;
    signal sign_shift, sign_count, sign_dispA, sign_dispB : STD_LOGIC;
    
    signal seg_dispA, seg_dispB : STD_LOGIC_VECTOR(6 downto 0);
    signal seg_result : STD_LOGIC_VECTOR(6 downto 0);
    
    signal internal_result : STD_LOGIC_VECTOR(3 downto 0);
    
begin
    
    -- Instanciation des composants
    
    -- Addition (SEL = 0000)
    ADD_UNIT: alu_addition
        port map (
            A => A,
            B => B,
            result => res_add,
            carry => carry_add,
            zero => zero_add,
            sign => sign_add
        );
    
    -- Soustraction (SEL = 0001)
    SUB_UNIT: alu_soustraction
        port map (
            A => A,
            B => B,
            result => res_sub,
            carry => carry_sub,
            zero => zero_sub,
            sign => sign_sub
        );
    
    -- FSM Mealy Simple (SEL = 0010)
    FSM1_UNIT: fsm_mealy_simple
        port map (
            clk => clk,
            reset => reset,
            A => A,
            result => res_fsm1,
            carry => carry_fsm1,
            zero => zero_fsm1,
            sign => sign_fsm1
        );
    
    -- FSM Mealy Dual (SEL = 0011)
    FSM2_UNIT: fsm_mealy_dual
        port map (
            clk => clk,
            reset => reset,
            A => A,
            B => B,
            result => res_fsm2,
            carry => carry_fsm2,
            zero => zero_fsm2,
            sign => sign_fsm2
        );
    
    -- Registre à décalage (SEL = 0100)
    SHIFT_UNIT: shift_register
        port map (
            clk => clk,
            reset => reset,
            A => A,
            B => B,
            result => res_shift,
            carry => carry_shift,
            zero => zero_shift,
            sign => sign_shift
        );
    
    -- Compteur (SEL = 0101)
    COUNT_UNIT: counter_sync
        port map (
            clk => clk,
            reset => reset,
            A => A,
            B => B,
            result => res_count,
            carry => carry_count,
            zero => zero_count,
            sign => sign_count
        );
    
    -- Affichage A (SEL = 0110)
    DISP_A_UNIT: display_A
        port map (
            A => A,
            B => B,
            result => res_dispA,
            seg_out => seg_dispA,
            carry => carry_dispA,
            zero => zero_dispA,
            sign => sign_dispA
        );
    
    -- Affichage B (SEL = 0111)
    DISP_B_UNIT: display_B
        port map (
            A => A,
            B => B,
            result => res_dispB,
            seg_out => seg_dispB,
            carry => carry_dispB,
            zero => zero_dispB,
            sign => sign_dispB
        );
    
    -- Décodeur 7 segments pour le résultat
    RESULT_DECODER: hex_to_7seg
        port map (
            hex_in => internal_result,
            seg_out => seg_result
        );
    
    -- Multiplexeur pour sélectionner l'opération
    process(SEL, res_add, res_sub, res_fsm1, res_fsm2, res_shift, res_count, res_dispA, res_dispB,
            carry_add, carry_sub, carry_fsm1, carry_fsm2, carry_shift, carry_count, carry_dispA, carry_dispB,
            zero_add, zero_sub, zero_fsm1, zero_fsm2, zero_shift, zero_count, zero_dispA, zero_dispB,
            sign_add, sign_sub, sign_fsm1, sign_fsm2, sign_shift, sign_count, sign_dispA, sign_dispB,
            seg_result, seg_dispA, seg_dispB)
    begin
        case SEL is
            when "0000" =>  -- Addition
                internal_result <= res_add;
                carry_flag <= carry_add;
                zero_flag <= zero_add;
                sign_flag <= sign_add;
                seg_display <= seg_result;
                
            when "0001" =>  -- Soustraction
                internal_result <= res_sub;
                carry_flag <= carry_sub;
                zero_flag <= zero_sub;
                sign_flag <= sign_sub;
                seg_display <= seg_result;
                
            when "0010" =>  -- FSM Mealy simple
                internal_result <= res_fsm1;
                carry_flag <= carry_fsm1;
                zero_flag <= zero_fsm1;
                sign_flag <= sign_fsm1;
                seg_display <= seg_result;
                
            when "0011" =>  -- FSM Mealy dual
                internal_result <= res_fsm2;
                carry_flag <= carry_fsm2;
                zero_flag <= zero_fsm2;
                sign_flag <= sign_fsm2;
                seg_display <= seg_result;
                
            when "0100" =>  -- Registre à décalage
                internal_result <= res_shift;
                carry_flag <= carry_shift;
                zero_flag <= zero_shift;
                sign_flag <= sign_shift;
                seg_display <= seg_result;
                
            when "0101" =>  -- Compteur
                internal_result <= res_count;
                carry_flag <= carry_count;
                zero_flag <= zero_count;
                sign_flag <= sign_count;
                seg_display <= seg_result;
                
            when "0110" =>  -- Affichage A
                internal_result <= res_dispA;
                carry_flag <= carry_dispA;
                zero_flag <= zero_dispA;
                sign_flag <= sign_dispA;
                seg_display <= seg_dispA;
                
            when "0111" =>  -- Affichage B
                internal_result <= res_dispB;
                carry_flag <= carry_dispB;
                zero_flag <= zero_dispB;
                sign_flag <= sign_dispB;
                seg_display <= seg_dispB;
                
            when others =>  -- Par défaut
                internal_result <= "0000";
                carry_flag <= '0';
                zero_flag <= '1';
                sign_flag <= '0';
                seg_display <= "1111111";  -- Éteint
        end case;
    end process;
    
    result <= internal_result;
    
end Structural;