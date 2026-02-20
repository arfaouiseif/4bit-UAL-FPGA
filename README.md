# UAL 4 bits - Unité Arithmétique et Logique
## Architecture VHDL Modulaire pour FPGA

---

## 📋 Table des Matières
1. [Description](#description)
2. [Architecture](#architecture)
3. [Liste des fichiers](#liste-des-fichiers)
4. [Opérations disponibles](#opérations-disponibles)
5. [Signaux d'entrée/sortie](#signaux-dentrée-sortie)
6. [Guide d'utilisation](#guide-dutilisation)
7. [Implémentation sur FPGA](#implémentation-sur-fpga)
8. [Tests et Simulation](#tests-et-simulation)

---

## Description

Cette UAL (Unité Arithmétique et Logique) est conçue pour des cartes FPGA et implémente 8 opérations différentes sur des nombres 4 bits. L'architecture est entièrement modulaire avec des composants séparés pour chaque opération.

### Caractéristiques principales :
- ✅ **Architecture modulaire** : chaque opération dans son propre fichier
- ✅ **8 opérations complètes** sélectionnables via SEL[3:0]
- ✅ **Flags d'état** : Carry, Zero, Sign
- ✅ **Afficheur 7 segments** intégré
- ✅ **Code propre et testé** prêt pour implémentation

---

## Architecture

```
UAL_principale (Top Module)
├── alu_addition          (SEL = 0000)
├── alu_soustraction      (SEL = 0001)
├── fsm_mealy_simple      (SEL = 0010)
├── fsm_mealy_dual        (SEL = 0011)
├── shift_register        (SEL = 0100)
├── counter_sync          (SEL = 0101)
├── display_A             (SEL = 0110)
├── display_B             (SEL = 0111)
└── hex_to_7seg          (Décodeur partagé)
```

---

## Liste des Fichiers

### Fichiers Design Sources

| Fichier | Description |
|---------|-------------|
| `UAL_principale.vhd` | **Module principal** intégrant tous les composants |
| `alu_addition.vhd` | Addition binaire avec flags |
| `alu_soustraction.vhd` | Soustraction binaire avec gestion du signe |
| `fsm_mealy_simple.vhd` | FSM Mealy - Détecteur de séquence "1011" |
| `fsm_mealy_dual.vhd` | FSM Mealy - Détection simultanée sur A et B |
| `shift_register.vhd` | Registre à décalage 4 bits (logique/circulaire) |
| `counter_sync.vhd` | Compteur synchrone configurable |
| `display_A.vhd` | Affichage 7 segments de A |
| `display_B.vhd` | Affichage 7 segments de B |
| `hex_to_7seg.vhd` | Décodeur hexadécimal → 7 segments |

### Fichiers de Test et Contraintes

| Fichier | Description |
|---------|-------------|
| `UAL_principale_tb.vhd` | Testbench complet pour simulation |
| `UAL_contraintes.xdc` | Contraintes pour Basys3/Nexys (exemple) |

---

## Opérations Disponibles

### SEL = 0000 : Addition
- **Fonction** : `result = A + B`
- **Flags** : 
  - `carry` = '1' si débordement (A+B > 15)
  - `zero` = '1' si résultat = 0
  - `sign` = bit de poids fort du résultat
- **Affichage** : Résultat sur afficheur 7 segments

**Exemple** :
```
A = 0101 (5), B = 0011 (3)
→ result = 1000 (8), carry = 0, zero = 0, sign = 1
```

---

### SEL = 0001 : Soustraction
- **Fonction** : `result = A - B`
- **Flags** :
  - `carry` = '1' si A < B (emprunt)
  - `zero` = '1' si A = B
  - `sign` = '1' si résultat négatif
- **Affichage** : Résultat sur afficheur 7 segments

**Exemple** :
```
A = 0011 (3), B = 0111 (7)
→ result = 1100 (-4 en complément à 2), carry = 1, sign = 1
```

---

### SEL = 0010 : FSM Mealy - Détecteur de séquence
- **Fonction** : Détecte la séquence binaire "1011" sur l'entrée A[0]
- **Type** : Machine de Mealy (sortie dépend de l'état ET de l'entrée)
- **Résultat** : `result[0]` = '1' quand séquence détectée
- **Nécessite** : Signal d'horloge

**États** :
```
S0 → S1 (si '1') → S2 (si '0') → S3 (si '1') → détection (si '1')
```

---

### SEL = 0011 : FSM Mealy - Détection simultanée
- **Fonction** : Détecte "0110" sur A[0] ET "0110" sur B[0] simultanément
- **Résultat** : 
  - `result[1]` = détection sur A
  - `result[0]` = détection sur B
  - `carry` = '1' si les deux séquences détectées en même temps

---

### SEL = 0100 : Registre à décalage
- **Fonction** : Décalage de la valeur A selon la configuration B
- **Contrôle via B** :
  - `B[0]` = direction (0 = gauche, 1 = droite)
  - `B[1]` = mode (0 = logique, 1 = circulaire)
- **Carry** : Bit qui sort lors du décalage
- **Nécessite** : Horloge et reset pour initialiser avec A

**Modes** :
```
B = 00 : Décalage gauche logique (insertion de '0')
B = 01 : Décalage gauche circulaire (MSB → LSB)
B = 10 : Décalage droite logique (insertion de '0')
B = 11 : Décalage droite circulaire (LSB → MSB)
```

---

### SEL = 0101 : Compteur synchrone
- **Fonction** : Compteur 4 bits initialisé avec A, contrôlé par B
- **Contrôle via B** :
  - `B[0]` = direction (0 = croissant, 1 = décroissant)
  - `B[1]` = enable (1 = actif, 0 = pause)
- **Carry** : '1' lors de débordement (15→0) ou sous-débordement (0→15)
- **Nécessite** : Horloge et reset

**Exemple** :
```
A = 0101 (initialise à 5), B = 0010 (enable=1, up)
→ Chaque cycle d'horloge : 5 → 6 → 7 → 8...
```

---

### SEL = 0110 : Affichage de A
- **Fonction** : Affiche la valeur hexadécimale de A sur l'afficheur 7 segments
- **Résultat** : `result = A`
- **Sortie 7seg** : Code cathode commune pour afficher 0-F

---

### SEL = 0111 : Affichage de B
- **Fonction** : Affiche la valeur hexadécimale de B sur l'afficheur 7 segments
- **Résultat** : `result = B`
- **Sortie 7seg** : Code cathode commune pour afficher 0-F

---

## Signaux d'Entrée/Sortie

### Entrées

| Signal | Type | Description |
|--------|------|-------------|
| `clk` | STD_LOGIC | Horloge système (requis pour SEL 0010-0101) |
| `reset` | STD_LOGIC | Reset asynchrone actif haut |
| `A[3:0]` | STD_LOGIC_VECTOR | Opérande A (4 bits) |
| `B[3:0]` | STD_LOGIC_VECTOR | Opérande B (4 bits) |
| `SEL[3:0]` | STD_LOGIC_VECTOR | Sélecteur d'opération (0000-0111) |

### Sorties

| Signal | Type | Description |
|--------|------|-------------|
| `result[3:0]` | STD_LOGIC_VECTOR | Résultat de l'opération |
| `seg_display[6:0]` | STD_LOGIC_VECTOR | Code 7 segments (a-b-c-d-e-f-g) |
| `carry_flag` | STD_LOGIC | Flag de retenue/débordement |
| `zero_flag` | STD_LOGIC | Flag résultat nul |
| `sign_flag` | STD_LOGIC | Flag de signe |

---

## Guide d'Utilisation

### 1. Opérations Combinatoires (Addition, Soustraction, Affichage)

Ces opérations ne nécessitent **pas d'horloge**, le résultat est immédiat :

```vhdl
-- Exemple d'addition : 5 + 3
SEL <= "0000";
A <= "0101";  -- 5
B <= "0011";  -- 3
-- result = "1000" (8) immédiatement
```

### 2. Opérations Séquentielles (FSM, Shift, Counter)

Ces opérations nécessitent une **horloge** et un **reset** :

```vhdl
-- Exemple de compteur
reset <= '1';  -- Reset pour initialiser
wait for 20 ns;
reset <= '0';

SEL <= "0101";  -- Mode compteur
A <= "0000";    -- Départ à 0
B <= "0010";    -- Enable=1, Up=0

-- À chaque front montant de clk : 0 → 1 → 2 → 3...
```

### 3. Utilisation de l'afficheur 7 segments

Le signal `seg_display[6:0]` représente les segments **a-b-c-d-e-f-g** en code cathode commune (actif à '0') :

```
    a
  -----
f|     |b
  --g--
e|     |c
  -----
    d
```

Pour afficher sur votre FPGA :
- Connectez `seg_display` aux cathodes de l'afficheur
- Activez l'anode correspondante (voir fichier de contraintes)

---

## Implémentation sur FPGA

### Étape 1 : Importer les fichiers

Dans Vivado/Quartus :
1. Créez un nouveau projet
2. Ajoutez **tous les fichiers .vhd** comme Design Sources
3. Définissez `UAL_principale.vhd` comme **Top Module**

### Étape 2 : Adapter les contraintes

Le fichier `UAL_contraintes.xdc` est un exemple pour **Basys3/Nexys A7**. Vous devez l'adapter selon votre carte :

1. Identifiez les pins de votre carte (datasheet)
2. Modifiez les `PACKAGE_PIN` selon votre matériel
3. Ajustez la fréquence d'horloge si nécessaire

**Carte Basys3** : 12 switches, 16 LEDs, 4 afficheurs 7seg
**Carte Nexys A7** : 16 switches, 16 LEDs, 8 afficheurs 7seg

### Étape 3 : Synthèse et Implémentation

1. Run Synthesis
2. Run Implementation
3. Generate Bitstream
4. Program Device

### Mappage des contrôles suggéré

| Contrôle | Suggestion |
|----------|-----------|
| A[3:0] | Switches 0-3 |
| B[3:0] | Switches 4-7 |
| SEL[3:0] | Switches 8-11 |
| reset | Bouton central |
| result[3:0] | LEDs 0-3 |
| carry_flag | LED 13 (rouge) |
| zero_flag | LED 14 (jaune) |
| sign_flag | LED 15 (vert) |
| seg_display | Premier afficheur 7seg |

---

## Tests et Simulation

### Lancer la simulation

Le testbench `UAL_principale_tb.vhd` teste toutes les opérations :

1. Dans Vivado : Add Sources → Add or create simulation sources
2. Ajoutez `UAL_principale_tb.vhd`
3. Run Simulation → Run Behavioral Simulation
4. Observez les signaux dans la fenêtre de forme d'onde

### Tests couverts

✅ Addition : 5+3, 15+1 (avec carry), 0+0 (zero flag)
✅ Soustraction : 7-3, 3-7 (signe négatif)
✅ Registre à décalage : gauche logique, droite circulaire
✅ Compteur : croissant, décroissant
✅ Affichage A et B
✅ FSM Mealy simple et double

### Temps de simulation

La simulation complète s'exécute sur ~1 µs et affiche des rapports à chaque test.

---

## Notes Importantes

### ⚠️ Afficheur 7 segments
- Le code fourni génère un signal pour **cathode commune** (actif à '0')
- Si votre carte utilise **anode commune**, inversez `seg_display` dans les contraintes
- Pour afficher sur plusieurs afficheurs, ajoutez un multiplexeur temporel

### ⚠️ Horloge
- Opérations 0000, 0001, 0110, 0111 : **sans horloge**
- Opérations 0010, 0011, 0100, 0101 : **avec horloge obligatoire**

### ⚠️ Reset
- Toujours faire un reset initial pour les opérations séquentielles
- Reset asynchrone actif haut ('1' = reset)

---

## Exemples Pratiques

### Exemple 1 : Calculatrice simple
```
SEL = 0000 (addition)
A = 1001 (9)
B = 0110 (6)
→ result = 1111 (15), afficheur montre "F"
```

### Exemple 2 : Compteur 0 à 15 en boucle
```
SEL = 0101
A = 0000 (départ)
B = 0010 (enable + up)
reset → clk → clk → clk...
→ 0, 1, 2, 3... 15, 0, 1...
```

### Exemple 3 : Détection de motif
```
SEL = 0010 (FSM simple)
reset actif
Envoyer bits sur A[0] via horloge :
1 → 0 → 1 → 1
→ result[0] = '1' (séquence détectée!)
```

---

## Support et Modifications

### Personnalisation

Vous pouvez facilement :
- Ajouter de nouvelles opérations (SEL 1000-1111 disponibles)
- Modifier les séquences détectées dans les FSM
- Changer le nombre de bits (modifier les vecteurs 3 downto 0)
- Adapter le décodeur 7seg pour anode commune

### Debugging

Si une opération ne fonctionne pas :
1. Vérifiez que SEL correspond bien à l'opération souhaitée
2. Pour les opérations séquentielles, vérifiez l'horloge et le reset
3. Utilisez le testbench pour isoler le problème
4. Vérifiez les contraintes de pins

---

## Auteur et Licence

Architecture VHDL modulaire pour UAL 4 bits
Conçu pour l'enseignement et l'apprentissage du VHDL sur FPGA

📧 Pour toute question ou amélioration, n'hésitez pas !

---

**Bonne programmation FPGA ! 🚀**
