####################################################################################
## Fichier de contraintes XDC pour UAL - Basys3 / Nexys A7 (exemple)
## À adapter selon votre carte FPGA spécifique
####################################################################################

## Horloge système (100 MHz pour Basys3)
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Reset (bouton central sur Basys3)
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports reset]

## Entrée A (4 switches)
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports {A[0]}]
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports {A[1]}]
set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports {A[2]}]
set_property -dict { PACKAGE_PIN W17   IOSTANDARD LVCMOS33 } [get_ports {A[3]}]

## Entrée B (4 switches)
set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33 } [get_ports {B[0]}]
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports {B[1]}]
set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports {B[2]}]
set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports {B[3]}]

## Sélecteur d'opération SEL (4 switches)
set_property -dict { PACKAGE_PIN V2    IOSTANDARD LVCMOS33 } [get_ports {SEL[0]}]
set_property -dict { PACKAGE_PIN T3    IOSTANDARD LVCMOS33 } [get_ports {SEL[1]}]
set_property -dict { PACKAGE_PIN T2    IOSTANDARD LVCMOS33 } [get_ports {SEL[2]}]
set_property -dict { PACKAGE_PIN R3    IOSTANDARD LVCMOS33 } [get_ports {SEL[3]}]

## Sortie résultat (4 LEDs)
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports {result[0]}]
set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports {result[1]}]
set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports {result[2]}]
set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports {result[3]}]

## Flags (3 LEDs)
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports carry_flag]
set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports zero_flag]
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports sign_flag]

## Afficheur 7 segments - Cathodes (segments a-g)
set_property -dict { PACKAGE_PIN W7    IOSTANDARD LVCMOS33 } [get_ports {seg_display[0]}]
set_property -dict { PACKAGE_PIN W6    IOSTANDARD LVCMOS33 } [get_ports {seg_display[1]}]
set_property -dict { PACKAGE_PIN U8    IOSTANDARD LVCMOS33 } [get_ports {seg_display[2]}]
set_property -dict { PACKAGE_PIN V8    IOSTANDARD LVCMOS33 } [get_ports {seg_display[3]}]
set_property -dict { PACKAGE_PIN U5    IOSTANDARD LVCMOS33 } [get_ports {seg_display[4]}]
set_property -dict { PACKAGE_PIN V5    IOSTANDARD LVCMOS33 } [get_ports {seg_display[5]}]
set_property -dict { PACKAGE_PIN U7    IOSTANDARD LVCMOS33 } [get_ports {seg_display[6]}]

## Si vous utilisez plusieurs afficheurs, ajoutez les anodes ici
## Exemple pour activer le premier afficheur (à adapter)
# set_property -dict { PACKAGE_PIN U2    IOSTANDARD LVCMOS33 } [get_ports {an[0]}]
# set_property -dict { PACKAGE_PIN U4    IOSTANDARD LVCMOS33 } [get_ports {an[1]}]
# set_property -dict { PACKAGE_PIN V4    IOSTANDARD LVCMOS33 } [get_ports {an[2]}]
# set_property -dict { PACKAGE_PIN W4    IOSTANDARD LVCMOS33 } [get_ports {an[3]}]

####################################################################################
## Configuration options
####################################################################################
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
