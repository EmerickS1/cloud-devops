# cloud-devops

# Projet Ops

Le projet **Ops** servira uniquement à construire et gérer l'infrastructure applicative. Ce projet comprendra plusieurs pipelines Cloud Build qui effectueront les tâches suivantes :

### 1. **Pipeline de Build du Binaire Applicatif**
Cette pipeline sera responsable de la construction automatique du binaire de l'application et de son stockage dans l'**Artefact Registry**.

Les étapes de cette pipeline incluront :
- **Scan de sécurité pour vérifier l'absence de secrets leaks** (ex. tokens, passwords) dans le code source.
- **Scan de sécurité pour vérifier la présence de vulnérabilités** dans l'application (par exemple, dépendances vulnérables).
- **Build du binaire** à partir du code Go.
- **Push du binaire dans l'Artefact Registry** sous une registry dédiée pour Go.

### 2. **Pipeline de Construction de l'Image Système**
Cette pipeline sera responsable de la construction de l'image système qui sera déployée plus tard dans l'infrastructure.

L'image construite devra inclure :
- **L'application** sous forme de binaire, qui doit être configurée pour être exécutée en tant que service **Systemd**.
- **L'OpsAgent** (utilisé pour la gestion de l'agent sur les instances).
- **Les pré-requis nécessaires au bon fonctionnement de Packer** (par exemple, configuration, plugins nécessaires).

### 3. **Pipeline pour Créer un Bucket GCS**
Le pipeline devra créer un **Bucket GCS non public** pour héberger les **Terraform states**. Ce bucket ne sera pas public afin de garantir la sécurité des données sensibles.


# Projet App

Le projet **App** hébergera l'ensemble des services nécessaires au bon fonctionnement de l'application. Voici l'infrastructure à déployer dans ce projet :

### 1. **VPC (Virtual Private Cloud)**
- **Création d'un VPC** pour isoler les ressources et gérer la connectivité réseau.

### 2. **Sous-réseaux**
- **Un sous-réseau dans la région Paris (europe-west9)** pour déployer les instances.
- **Un sous-réseau de type Load Balancer Only** pour les besoins du Load Balancer.

### 3. **Bucket GCS Public**
- **Création d'un Bucket GCS public** pour héberger les fichiers statiques de l'application (HTML, CSS, JS) ainsi que les images de l'application.

### 4. **Managed Instance Group (MIG)**
- **MIG** utilisant l'image précédemment créée dans le projet **Ops** pour déployer les instances.
- Cette image contiendra l'application sous forme de binaire et sera configurée pour démarrer automatiquement en tant que service **Systemd**.

### 5. **Load Balancer Régional**
- **Création d'un Load Balancer régional** afin d'exposer l'application.
- Ce Load Balancer sera déployé dans le sous-réseau dédié à cet effet (Load Balancer Only).

### 6. **Zone DNS**
- **Création d'une zone DNS** pour permettre l'accès à l'application via un nom de domaine.

### 7. **Dashboard Cloud Monitoring**
- **Création d'un dashboard Cloud Monitoring** pour afficher les informations suivantes :
  - **Le trafic venant du Load Balancer**.
  - **Les métriques CPU / RAM** des instances dans le MIG.
 
# Stucture du projet
```
.
├── Projet-APP/
│   └── main.tf/
│
├── app.tar.gz           
│           
└── Projet-OPS/
    ├── src                 #app.tar decompressé
    ├── cloudbuild.yaml
    ├── main.tf
    ├── packerfile.pkr.hcl
    ├── playbook.yml          
    └── variables.tf          
```









