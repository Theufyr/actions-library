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

### Telegram notifications `.github/actions/telegram-notify` :
- This action sends you a _Telegram_ notification at the end of a _GitHub Actions_ workflow to know if it was a success or a failure.
- Latest version : `v1` or `latest`
- Release notes :
    - v1 :
        - message :<br>
        "workflow: { workflow name } - status: { success or failure } on { GitHub repo } { date & time UTC }"
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

### Notifications Telegram `.github/actions/telegram-notify` :
- Cette action envoie une notification _Telegram_ à la fin d'un workflow _GitHub Actions_ pour savoir s'il a réussi ou échoué.
- Dernière version : `v1` ou `latest`
- Notes de version :
    - v1 :
        - message :<br>
        "workflow: { nom du workflow } - status: { succès ou échec } on { repo GitHub } { date & heure UTC }"