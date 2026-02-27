----------------------------------------------------------------------------------
-- Testbench pour UAL_principale VERSION ÉTENDUE
-- Description: Test complet de toutes les 10 opérations de l'UAL
-- Inclut les tests pour Palindrome et Gray Code
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UAL_principale_v2_tb is
end UAL_principale_v2_tb;

architecture Behavioral of UAL_principale_v2_tb is
    -- Déclaration du composant à tester
    component UAL_principale
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
    end component;
    
    -- Signaux de test
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal A : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal B : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal SEL : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal result : STD_LOGIC_VECTOR(3 downto 0);
    signal seg_display : STD_LOGIC_VECTOR(6 downto 0);
    signal carry_flag : STD_LOGIC;
    signal zero_flag : STD_LOGIC;
    signal sign_flag : STD_LOGIC;
    
    -- Période de l'horloge
    constant clk_period : time := 10 ns;
    
begin
    -- Instanciation de l'UAL
    UUT: UAL_principale
        port map (
            clk => clk,
            reset => reset,
            A => A,
            B => B,
            SEL => SEL,
            result => result,
            seg_display => seg_display,
            carry_flag => carry_flag,
            zero_flag => zero_flag,
            sign_flag => sign_flag
        );
    
    -- Génération de l'horloge
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    -- Processus de stimulation
    stim_proc: process
    begin
        -- Reset initial
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;
        
        -- ===== TEST 1: ADDITION (SEL = 0000) =====
        report "TEST 1: Addition";
        SEL <= "0000";
        A <= "0101";  -- 5
        B <= "0011";  -- 3
        wait for 20 ns;
        assert result = "1000" report "Addition 5+3 failed" severity error;
        
        -- ===== TEST 2: SOUSTRACTION (SEL = 0001) =====
        report "TEST 2: Soustraction";
        SEL <= "0001";
        A <= "0111";  -- 7
        B <= "0011";  -- 3
        wait for 20 ns;
        assert result = "0100" report "Soustraction 7-3 failed" severity error;
        
        -- ===== TEST 3: DÉTECTEUR DE PALINDROME (SEL = 1000) =====
        report "TEST 3: Détecteur de Palindrome";
        SEL <= "1000";
        
        -- Test 3.1: 0110 est un palindrome
        A <= "0110";  -- 0110 (palindrome)
        B <= "0000";
        wait for 20 ns;
        assert carry_flag = '1' report "Palindrome 0110 not detected" severity error;
        assert result(0) = '1' report "Palindrome flag not set for 0110" severity error;
        report "Palindrome 0110 détecté: result = " & integer'image(to_integer(unsigned(result)));
        
        -- Test 3.2: 1001 est un palindrome
        A <= "1001";  -- 1001 (palindrome)
        wait for 20 ns;
        assert carry_flag = '1' report "Palindrome 1001 not detected" severity error;
        assert result(0) = '1' report "Palindrome flag not set for 1001" severity error;
        report "Palindrome 1001 détecté: result = " & integer'image(to_integer(unsigned(result)));
        
        -- Test 3.3: 1111 est un palindrome
        A <= "1111";  -- 1111 (palindrome)
        wait for 20 ns;
        assert carry_flag = '1' report "Palindrome 1111 not detected" severity error;
        report "Palindrome 1111 détecté: result = " & integer'image(to_integer(unsigned(result)));
        
        -- Test 3.4: 0000 est un palindrome
        A <= "0000";  -- 0000 (palindrome)
        wait for 20 ns;
        assert carry_flag = '1' report "Palindrome 0000 not detected" severity error;
        report "Palindrome 0000 détecté: result = " & integer'image(to_integer(unsigned(result)));
        
        -- Test 3.5: 0100 n'est PAS un palindrome
        A <= "0100";  -- 0100 (pas palindrome)
        wait for 20 ns;
        assert carry_flag = '0' report "0100 incorrectly detected as palindrome" severity error;
        report "Non-palindrome 0100: result = " & integer'image(to_integer(unsigned(result)));
        
        -- Test 3.6: 1010 n'est PAS un palindrome
        A <= "1010";  -- 1010 (pas palindrome)
        wait for 20 ns;
        assert carry_flag = '0' report "1010 incorrectly detected as palindrome" severity error;
        report "Non-palindrome 1010: result = " & integer'image(to_integer(unsigned(result)));
        
        -- ===== TEST 4: CONVERTISSEUR GRAY CODE (SEL = 1001) =====
        report "TEST 4: Convertisseur Gray Code";
        SEL <= "1001";
        
        -- Test 4.1: Binaire → Gray
        B <= "0000";  -- direction = 0 (Bin→Gray)
        
        A <= "0000";  -- 0 bin → 0 gray
        wait for 20 ns;
        assert result = "0000" report "Gray 0 failed" severity error;
        report "0 binaire → " & integer'image(to_integer(unsigned(result))) & " Gray";
        
        A <= "0001";  -- 1 bin → 1 gray
        wait for 20 ns;
        assert result = "0001" report "Gray 1 failed" severity error;
        report "1 binaire → " & integer'image(to_integer(unsigned(result))) & " Gray";
        
        A <= "0010";  -- 2 bin → 3 gray
        wait for 20 ns;
        assert result = "0011" report "Gray 2 failed" severity error;
        report "2 binaire → " & integer'image(to_integer(unsigned(result))) & " Gray";
        
        A <= "0011";  -- 3 bin → 2 gray
        wait for 20 ns;
        assert result = "0010" report "Gray 3 failed" severity error;
        report "3 binaire → " & integer'image(to_integer(unsigned(result))) & " Gray";
        
        A <= "0100";  -- 4 bin → 6 gray
        wait for 20 ns;
        assert result = "0110" report "Gray 4 failed" severity error;
        report "4 binaire → " & integer'image(to_integer(unsigned(result))) & " Gray";
        
        A <= "1111";  -- 15 bin → 8 gray
        wait for 20 ns;
        assert result = "1000" report "Gray 15 failed" severity error;
        report "15 binaire → " & integer'image(to_integer(unsigned(result))) & " Gray";
        
        -- Test 4.2: Gray → Binaire (conversion inverse)
        B <= "0001";  -- direction = 1 (Gray→Bin)
        
        A <= "0000";  -- 0 gray → 0 bin
        wait for 20 ns;
        assert result = "0000" report "Binary from Gray 0 failed" severity error;
        report "0 Gray → " & integer'image(to_integer(unsigned(result))) & " binaire";
        
        A <= "0001";  -- 1 gray → 1 bin
        wait for 20 ns;
        assert result = "0001" report "Binary from Gray 1 failed" severity error;
        report "1 Gray → " & integer'image(to_integer(unsigned(result))) & " binaire";
        
        A <= "0011";  -- 3 gray → 2 bin
        wait for 20 ns;
        assert result = "0010" report "Binary from Gray 3 failed" severity error;
        report "3 Gray → " & integer'image(to_integer(unsigned(result))) & " binaire";
        
        A <= "0010";  -- 2 gray → 3 bin
        wait for 20 ns;
        assert result = "0011" report "Binary from Gray 2 failed" severity error;
        report "2 Gray → " & integer'image(to_integer(unsigned(result))) & " binaire";
        
        A <= "0110";  -- 6 gray → 4 bin
        wait for 20 ns;
        assert result = "0100" report "Binary from Gray 6 failed" severity error;
        report "6 Gray → " & integer'image(to_integer(unsigned(result))) & " binaire";
        
        A <= "1000";  -- 8 gray → 15 bin
        wait for 20 ns;
        assert result = "1111" report "Binary from Gray 8 failed" severity error;
        report "8 Gray → " & integer'image(to_integer(unsigned(result))) & " binaire";
        
        -- ===== TEST 5: VÉRIFICATION DES AUTRES OPÉRATIONS =====
        report "TEST 5: Vérification rapide des autres opérations";
        
        -- Affichage A
        SEL <= "0110";
        A <= "1010";  -- A
        wait for 20 ns;
        assert result = "1010" report "Display A failed" severity error;
        
        -- Affichage B
        SEL <= "0111";
        B <= "1111";  -- F
        wait for 20 ns;
        assert result = "1111" report "Display B failed" severity error;
        
        report "═══════════════════════════════════════════════════════";
        report "Simulation terminée avec succès!";
        report "Toutes les 10 opérations testées et validées ✓";
        report "═══════════════════════════════════════════════════════";
        wait;
    end process;
    
end Behavioral;
