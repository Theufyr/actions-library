#### English version
[Afficher la version française](#version-française)

---
# Reusable GitHub Actions & Workflows library
## Actions
To know how to add the actions you want in your workflows, follow the instructions of the README.md file in their folder.
First, check if *GitHub* allows external *Actions* for your Repo's workflows :<br>
    go to : *Settings* > *Actions* > *General* > *Actions permissions*
	- check "*Allow all actions and reusable workflows*" (checked by default)
	- or add the external Repo `Theufyr/actions-library/*` to the *Allow* list

---
### Telegram notifications
`.github/actions/telegram-notify`<br>
This action sends you a _Telegram_ notification at the end of a _GitHub Actions_ workflow to know if it was a success or a failure.

- Latest version : `v1` or `latest`
- Release notes :
    - v1 :
        - message :<br>
        "workflow: { workflow name } - status: { success or failure } on { GitHub repo } { date & time UTC }"

---
### Detect changes from last push
`.github/actions/detect-changes`<br>
This action notifies your workflow of any changes in `frontend` or `backend` folders since the last commit on the distant branch (the last push/merge/etc.). The workflow will know what to update and will avoid useless *build* or *FTP* operations.

You can also use some tags with this action, in your commit's comment, to notify the workflow to force updates even if no change has been detected. The action returns `true`/`false` for `frontend`, `backend` and `reinit`. You can use these variables to trigger other steps than updates in your workfkow (tests for exemple).

- Latest version : `v1` or `latest`
- Release notes :
    - v1 :
        - notifies changes in the frontend and/or backend folders or if a tag was written in the commit
        - excludes the *GitHub* default value "0000000000000000000000000000000000000000" for missing event<br>
            (if no branch exists yet or commit, etc.)
        - checks if a tag `[frontend]`, `[backend]` or `[reinit]` is in the commit's comment (case-insensitive)
            - [frontend] : to ask for an update of the frontend
            - [backend] : to ask for an update of the backend
            - [reinit] : to ask for an update of the complete app
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
# Librairie d'Actions et Workflows GitHub
## Actions
Pour savoir comment ajouter une action à vos workflows, lisez le fichier README.md de leur dossier.
Au préalable, vérifier que *GitHub* accepte l'utilisation d'*Actions* externes sur votre Repo :<br>
    dans : *Settings* > *Actions* > *General* > *Actions permissions*
	- il faut activer "*Allow all actions and reusable workflows*" (coché par défaut)
	- ou ajouter spécifiquement le Repo externe `Theufyr/actions-library/*` à la liste *Allow*

---
### Notifications Telegram
`.github/actions/telegram-notify`<br>
Cette action envoie une notification _Telegram_ à la fin d'un workflow _GitHub Actions_ pour savoir s'il a réussi ou échoué.

- Dernière version : `v1` ou `latest`
- Notes de version :
    - v1 :
        - message :<br>
        "workflow: { nom du workflow } - status: { succès ou échec } on { repo GitHub } { date & heure UTC }"

---
### Detection des changements depuis le dernier push
`.github/actions/detect-changes`<br>
Cette action permet de prévenir le workflow si le contenu des dossiers `frontend` ou `backend` ont été modifiés depuis le dernier commit de la branche distante (donc le dernier push/merge/etc) pour qu'il sache automatiquement quoi mettre à jour et éviter, par exemple, un *build* ou des opérations *FTP* inutiles.

Elle permet aussi avec un simple tag ajouté dans le commentaire d'un commit, de signaler au workflow (même si aucun changement n'a été détecté), qu'on désire réinitialiser tout ou partie de l'app sur l'hébergeur.

L'action retourne au worklow des valeurs `true`/`false` pour `frontend`, `backend` et `reinit`, qui peuvent être utilisées pour déclencher autre chose que des mises à jour dans le worflow (des tests par exemple).

- Dernière version : `v1` ou `latest`
- Notes de version :
    - v1 :
        - signale si le frontend et/ou le backend ont été modifiés ou si un tag a été appelé dans le commentaire du commit
        - exclue la valeur "0000000000000000000000000000000000000000" que *GitHub* utilise pour signaler un évènement absent<br>
            (si pas encore de branche existante, de commit, etc)
        - reconnaît dans le commentaire d'un commit, les tags `[frontend]`, `[backend]` et `[reinit]` (insensible à la casse)
            - [frontend] : réinitialise le frontend
            - [backend] : réinitialise le backend
            - [reinit] : réinitialise toute l'app