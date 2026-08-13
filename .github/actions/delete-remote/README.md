#### English version
[Afficher la version française](#version-française)

---
# Overview
This action can empty directories (with the option to delete them as well) :
- no need of a remote server *Shell*
- using *SFTP* within the *GitHub Actions* runner

#### How-to
- the workflow's *job* needs *SFTP* so, for example, it starts with a `runs-on` *Linux* :
```yml
jobs:
  sftp-deploy:
    runs-on: ubuntu-latest
```
- [Prepare environment variables](#prepare-environment-variables)
- [OPTIONAL : Prepare directories list](#optional--prepare-directories-list)
- [Add the action to your workflow](#add-the-action-to-your-workflow)

---
#### Prepare environment variables
To prevent sensitive information from being exposed in plain text in the workflow and its logs, store it as secrets in a *GitHub Actions* environment within your repository :
  - go to *Settings > Secrets and variables > Actions >* select the *Secrets* tab

For *SFTP* connections with *SSH* authentification and find folders path, you'll need :
  - `SSH_USER` : your *FTP* login on the server, ex : `SSH_USER=MyAccount`
  - `SSH_SERVER` : the *FTP* server host, ex : `SSH_SERVER=ftp.mysite.com`
  - `DEPLOY_PATH` : the absolute path where the app lives on the server, ex : `DEPLOY_PATH=/home/mysite/www/myapp`
To check the server and avoid *MITM* attacks, you'll also need :
  - `SSH_PRIVATE_KEY` : private SSH key (the public one must be on the server in `.ssh/authorized_keys`)
  - `SSH_KNOWN_HOSTS` : result of `ssh-keyscan` with the server

---
#### OPTIONAL : Prepare directories list
To make the workflow faster and more efficient, it is recommended to create and populate a list of directories to empty/delete. This allows the action to be called only once and process all directories in a single operation.<br>
The list must be declared and populated before the action is called.

The example also makes use of:
- conditions to determine which directories should be deleted, such as:<br>
  `if: steps.changes.outputs.reinit != 'true' && steps.changes.outputs.backend == 'true'`<br>
  (see the action [.github/actions/detect-changes](https://github.com/Theufyr/actions-library/tree/main/.github/actions/detect-changes), which provides this functionality)
- the absolute path of the app directory on the server, stored as a secret in a *GitHub Actions* environment within your repository:<br>
  `${{ secrets.DEPLOY_PATH }}`

The list is a text variable containing:
- the full path of each directory (including the application path in which it is located)
- a space between each directory path
- directory names that do not contain spaces nor special characters

Example :
```yml
# .github/workflows/your-worflow.yml
      - name: List of folders to delete
        run: |
          echo "DIRS_TO_DELETE=" >> "$GITHUB_ENV"

      # Frontend directories :
      # - assets/
      # - images/
      - name: Mark frontend for deletion
        if: steps.changes.outputs.reinit != 'true' && steps.changes.outputs.frontend == 'true'
        run: |
          echo "DIRS_TO_DELETE=${DIRS_TO_DELETE:-} ${{ secrets.DEPLOY_PATH }}/assets ${{ secrets.DEPLOY_PATH }}/images" >> "$GITHUB_ENV"

      # Backend directories :
      # - api/
      # - public/
      - name: Mark backend for deletion
        if: steps.changes.outputs.reinit != 'true' && steps.changes.outputs.backend == 'true'
        run: |
          echo "DIRS_TO_DELETE=${DIRS_TO_DELETE:-} ${{ secrets.DEPLOY_PATH }}/api ${{ secrets.DEPLOY_PATH }}/public" >> "$GITHUB_ENV"
```

---
# Add the action to your workflow
Paste this code block in a _job_ after the steps listing the directories to empty/delete :
```yml
# .github/workflows/your-worflow.yml
      # step to prepare server check and avoid MITM attacks
      - name: Configure SSH key
        env:
          SSH_PRIVATE_KEY: ${{ secrets.SSH_PRIVATE_KEY }}
          SSH_KNOWN_HOSTS: ${{ secrets.SSH_KNOWN_HOSTS }}
        run: |
          mkdir -p ~/.ssh
          echo "$SSH_PRIVATE_KEY" > ~/.ssh/deploy_key
          chmod 600 ~/.ssh/deploy_key
          echo "$SSH_KNOWN_HOSTS" >> ~/.ssh/known_hosts
      
      - name: Delete folders
        # DIRS_TO_DELETE is a workflow variable defined earlier
        # to store the absolute paths of all directories to empty/delete
        if: env.DIRS_TO_DELETE != ''
        uses: Theufyr/actions-library/.github/actions/delete-remote@delete-remote/latest
        with:
          # SSH connection infos
          host: ${{ secrets.SSH_USER }}@${{ secrets.SSH_SERVER }}
          # path to the public SSH key on server
          key: ~/.ssh/deploy_key
          dirs: ${{ env.DIRS_TO_DELETE }}
          # keep_root: 'true' : empties the directories without deleting them
          # keep_root: 'false' : empties and deletes the directories
          keep_root: 'false'
          # choose the language for logs :
          # - 'en' : english (default)
          # - 'fr' : french
          lang: 'fr'

      # Example without a list of directories
      # all the app contents is deleted, only its directory is kept
      # using a condition output provided by another action: [reinit] from `.github/actions/detect-changes`
      - name: Wipe app folder on reinit
        if: steps.changes.outputs.reinit == 'true'
        uses: Theufyr/actions-library/.github/actions/delete-remote@delete-remote/latest
        with:
          host: ${{ secrets.SSH_USER }}@${{ secrets.SSH_SERVER }}
          key: ~/.ssh/deploy_key
          dirs: ${{ secrets.DEPLOY_PATH }}
          keep_root: 'true'
          lang: 'fr'
```
<br>
<br>
<br>
<br>
<br>

---
---
#### Version française
[See english version](#english-version)

---
# Présentation
Cette action permet de vider des dossiers (et en option de les supprimer ensuite) :
- sans besoin d'un *Shell* côté serveur
- en utilisant *SFTP* dans le *runner* de *GitHub Actions*

### Marche à suivre
- le *job* de votre workflow doit disposer de *SFTP* et doit donc, par exemple, commencer avec un `runs-on` *Linux* :
```yml
jobs:
  sftp-deploy:
    runs-on: ubuntu-latest
```
- [Préparer les variables d'environnement](#préparer-les-variables-denvironnement)
- [Préparer la clef SSH](#préparer-la-clef-ssh)
- [FACULTATIF : Préparer la liste des dossiers à effacer](#facultatif--préparer-la-liste-des-dossiers-à-effacer)
- [Ajouter l'action à votre workflow](#ajouter-laction-à-votre-workflow)

---
#### Préparer les variables d'environnement
Afin d'éviter de faire apparaître des infos sensibles en clair dans le workflow et ses logs, sauvegardez-les dans les secrets d'un environnement *GitHub Actions* sur votre dépôt :
  - dans *Settings > Secrets and variables > Actions >* onglet *Secrets*

Pour l'authentification *SSH* au serveur et trouver les chemins des dossiers, il faudra :
  - `SSH_USER` : votre identifiant *FTP* sur le serveur, ex : `SSH_USER=MonCompte`
  - `SSH_SERVER` : le host *FTP* du serveur, ex : `SSH_SERVER=ftp.monsite.com`
  - `DEPLOY_PATH` : le chemin absolu où se trouve l'app sur le serveur, ex : `DEPLOY_PATH=/home/monsite/www/monapp`
Pour verifier que GitHub se connecte bien au vrai serveur et éviter les attaques *MITM*, il faudra :
  - `SSH_PRIVATE_KEY` : clé SSH privée  (la clé publique doit être stockée sur le serveyr dans `.ssh/authorized_keys`)
  - `SSH_KNOWN_HOSTS` : résultat d'un `ssh-keyscan` sur le serveur


---
#### FACULTATIF : Préparer la liste des dossiers à effacer
Pour rendre le workflow plus rapide et léger, il vaut mieux créer et remplir au préalable une liste des dossiers à vider/effacer. Ainsi l'action n'est appelée qu'une fois et efface tous les dossiers en une seule opération.<br>
La liste doit être déclarée puis remplie avant l'appel de l'action.

Dans l'exemple on utilise accessoirement :
- des conditions pour savoir quels dossier effacer comme :<br>
  `if: steps.changes.outputs.reinit != 'true' && steps.changes.outputs.backend == 'true'`<br>
  (voir l'action [.github/actions/detect-changes](https://github.com/Theufyr/actions-library/tree/main/.github/actions/detect-changes) qui propose cette gestion)
- le chemin absolu du dossier de l'app sur le serveur, stocké dans un secret de l'enviromment *GitHub Actions* de votre dépôt :<br>
  `${{ secrets.DEPLOY_PATH }}`

La liste est une variable texte dans laquelle sont sauvegardés :
- les chemins de chaque dossier (comprenant le chemin de l'app dans laquelle il se trouve)
- un espace entre chaque chemin de dossier
- des noms de dossier qui n'ont pas d'espace ni de caractères spéciaux

Exemple :
```yml
# .github/workflows/votre-worflow.yml
      - name: List of folders to delete
        run: |
          echo "DIRS_TO_DELETE=" >> "$GITHUB_ENV"

      # Frontend directories :
      # - assets/
      # - images/
      - name: Mark frontend for deletion
        if: steps.changes.outputs.reinit != 'true' && steps.changes.outputs.frontend == 'true'
        run: |
          echo "DIRS_TO_DELETE=${DIRS_TO_DELETE:-} ${{ secrets.DEPLOY_PATH }}/assets ${{ secrets.DEPLOY_PATH }}/images" >> "$GITHUB_ENV"

      # Backend directories :
      # - api/
      # - public/
      - name: Mark backend for deletion
        if: steps.changes.outputs.reinit != 'true' && steps.changes.outputs.backend == 'true'
        run: |
          echo "DIRS_TO_DELETE=${DIRS_TO_DELETE:-} ${{ secrets.DEPLOY_PATH }}/api ${{ secrets.DEPLOY_PATH }}/public" >> "$GITHUB_ENV"
```

---
# Ajouter l'action à votre workflow
Copier/Coller ce bloc de code dans le  _job_ après avoir défini la liste des dossiers à vider/effacer :
```yml
# .github/workflows/votre-worflow.yml
      # step qui prépare la vérification du serveur pour éviter les attaques MITM
      - name: Configure SSH key
        env:
          SSH_PRIVATE_KEY: ${{ secrets.SSH_PRIVATE_KEY }}
          SSH_KNOWN_HOSTS: ${{ secrets.SSH_KNOWN_HOSTS }}
        run: |
          mkdir -p ~/.ssh
          echo "$SSH_PRIVATE_KEY" > ~/.ssh/deploy_key
          chmod 600 ~/.ssh/deploy_key
          echo "$SSH_KNOWN_HOSTS" >> ~/.ssh/known_hosts
      
      - name: Delete folders
        # DIRS_TO_DELETE est une variable créée au préalable dans le workflow
        # pour lister les chemins absolus de chaque dossier à vider/effacer
        if: env.DIRS_TO_DELETE != ''
        uses: Theufyr/actions-library/.github/actions/delete-remote@delete-remote/latest
        with:
          # infos de connexion SSH
          host: ${{ secrets.SSH_USER }}@${{ secrets.SSH_SERVER }}
          # chemin du dossier où se trouve la clé publique SSH du serveur
          key: ~/.ssh/deploy_key
          dirs: ${{ env.DIRS_TO_DELETE }}
          # keep_root: 'true' : les dossiers sont vidés mais laissés sur le serveur
          # keep_root: 'false' : les dossiers sont effacés une fois vidés
          keep_root: 'false'
          # par défaut les logs sont affichés en anglais, 'fr' pour les afficher en français
          lang: 'fr'

      # Exemple sans liste de dossiers
      # avec effactement complet du contenu du dossier de l'app
      # sans supprimer le dossier lui-même
      # en utilisant une condition issue d'une autre action : [reinit] de `.github/actions/detect-changes`
      - name: Wipe app folder on reinit
        if: steps.changes.outputs.reinit == 'true'
        uses: Theufyr/actions-library/.github/actions/delete-remote@delete-remote/latest
        with:
          host: ${{ secrets.SSH_USER }}@${{ secrets.SSH_SERVER }}
          key: ~/.ssh/deploy_key
          dirs: ${{ secrets.DEPLOY_PATH }}
          keep_root: 'true'
          lang: 'fr'
```