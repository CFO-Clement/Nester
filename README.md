# Le Nester (Serveur)

**Objectif** : Fournir une interface web pour superviser les harvesters (clients) et réaliser de la télémaintenance.

## Fonctionnalités
Le Nester exploite plusieurs services pour effectuer ses différentes tâches. Il utilise Grafana pour offrir des tableaux de bord des différents harvesters, Flask pour fournir une interface web, et NoVNC pour intégrer un client VNC dans Flask, facilitant ainsi la télémaintenance.

### Supervision avec Grafana
Les harvesters utilisent Prometheus pour collecter des données via un node_exporter, les écrire et les agréger dans une base de données TimescaleDB hébergée sur la machine SGDB.

Le Nester gère Grafana, permettant la connexion à cette base de données pour proposer des tableaux de bord des harvesters.
```plaintext
grafana_ansible/
│
├── playbook.yml                   # Playbook Ansible
└── install_grafana.sh             # Script d'installation
```

#### `grafana_ansible/playbook.yml`
Ce playbook installe Grafana et lance le service.

#### `install_grafana.sh`
Script qui installe Ansible si nécessaire, puis exécute le playbook.

### Interface web avec Flask
Cette partie hérite directement de la MSPR1. Le projet Seahawks_Nester consiste en un serveur reverse TCP qui reçoit des connexions des harvesters et offre un contrôle sur ceux-ci.
```plaintext
nester_ansible/
│
├── files/
│   ├── app/
│       ├── config.env          # Variables d'environnement
│       ├── DockerFile          # Dockerfile du projet Seahawks Nester
│       ├── install.sh          # Script d'installation du Nester (configuration des vars, docker build...)
│       ├── requirements.txt    # Dépendances Python
│       ├── start.sh            # Script de lancement du projet
│       ├── update.sh           # Script de mise à jour du projet
│       ├── src/                # Application Flask 
│   └── nester.service          # Daemon pour lancer Nester
├── playbook.yml                # Playbook Ansible
└── install_nester.sh           # Script d'installation
```

#### `nester_ansible/files/nester.service`
Daemon qui lance, après le démarrage du réseau, le script `start.sh` dans `/opt/nester` avec les paramètres Docker.

#### `nester_ansible/playbook.yml`
Ce playbook installe les dépendances, copie le projet Seahawks Nester dans `/opt/nester`, construit l'image, crée le daemon et lance le service.

#### `install_nester.sh`
Script qui installe Ansible si nécessaire, puis lance le playbook.

### Télémaintenance avec NoVNC
Un client NoVNC permet à l'interface du Nester d'ouvrir un popup avec un accès à distance à un harvester directement dans le navigateur.

```plaintext
novnc_ansible/
│
├── files/
│   └── novnc.service            # Daemon pour NoVNC
├── playbook.yml                 # Playbook Ansible
└── install_prometheus.sh        # Script d'installation
```

#### `novnc_ansible/files/novnc.service`
Daemon qui s'exécute après le démarrage du réseau et lance le binaire `/opt/noVNC/utils/novnc_proxy`.

#### `grafana_ansible/playbook.yml`
Ce playbook installe les dépendances, clone le git de NoVNC, le déplace dans `/opt/noVNC`, crée et lance le daemon.

### `install_prometheus.sh`
Script qui installe Ansible si nécessaire, puis exécute le playbook.

## Résumé des Services et Ports

- **Grafana** : Port 3000
- **NoVNC** : Port 6080 pour le client VNC 
- **Nester**: Port 8080 pour l'interface web et 5000 pour le reverse TCP