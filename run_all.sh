#!/bin/bash

echo "Début de l'exécution des scripts."

chmod +x install_graphana.sh
chmod +x install_novnc.sh
chmod +x install_nester.sh


echo "Exécution de install_graphana.sh"
./install_graphana.sh

echo "Exécution de install_novnc.sh"
./install_novnc.sh

echo "Exécution de install_nester.sh"
./install_nester.sh

echo "Tous les scripts ont été exécutés."
