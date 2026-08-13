#### English version
[Afficher la version française](#version-française)

---
# Overview
This action sends you a _Telegram_ notification at the end of a _GitHub Actions_ workflow to know if it was a success or a failure.

#### How-to
- save the keys `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID` in the secrets of your repository's *GitHub Actions* environment
    - [Create a personal bot](#create-a-personal-bot)
    - [Launch a chat with your bot](#launch-a-chat-with-your-bot)
    - [Get the ID for a private personal Chat](#for-a-private-personal-chat)
    - [Get the ID for a channel Chat](#for-a-channel-chat)
- use the *Action* in your repository's workflow
    - [Add the action to your workflow](#add-the-action-to-your-workflow)

---
# Prepare Telegram
### Create a personal bot
1. open Telegram and find *@BotFather*
    - type in the search bar : `BotFather`
    - ⚠️ check the bleu certified badge : this is the official account
    - select the bot and click *Start*
1. send `/newbot`
2. choose a name
    - ex : `Deploy Notifier`
3. choose a unique username with `bot` at the end
    - ex : `my_bot`
4. *@BotFather* response will give a personal *token API* like this :
    - `123456789:AAEuRWDTFD2UQ7agBtFSuhJf2-NmvHN3OPc`
5. enter this value in the secret `TELEGRAM_BOT_TOKEN` you have to create in your repository's *GitHub Actions* environment :
    - go to *Settings > Secrets and variables > Actions >* select the *Secrets* tab

⚠️ *CAUTION :*
The bot token gives a total control over your bot.
If there is a leak :
- revoke the token right away with *@BotFather* :
    - `/mybots` > select your bot > `Bot Settings` > `Revoke current token`
    - create a new token
    - change it in the secret `TELEGRAM_BOT_TOKEN`

---
### Launch a chat with your bot
A bot can send a private message to any user but only if the user started a chat first with the bot (that's an anti-spam security from *Telegram* : a bot can't chat with a user who never spoke with it)
1. search for your bot username (ex: `@my_bot`)
2. click *Start* (or send `/start`)

Without this step, the *API* will refuse to send any message because a bot doesn't have the rights to initiate a chat.

---
### Get the ID
#### For a private personal Chat
- if it isn't done already :
	1. search the username of your bot (ex: `@my_bot`)
	2. click *Start* (or send `/start`)
- go to this URL in a browser, replace `<TOKEN>` by your bot token :
```
   https://api.telegram.org/bot<TOKEN>/getUpdates
```
- you'll get a JSON response with the personal Chat ID like `"chat":{"id": 123456789, ...}`
- enter this value in the secret `TELEGRAM_CHAT_ID` you have to create in your repository's *GitHub Actions* environment :
    - go to *Settings > Secrets and variables > Actions >* select the *Secrets* tab

#### For a channel Chat
- if it isn't done already, create your channel
    - in Telegram : new channel, choose *private* or *public* (it doesn't matter for the API bot)
- add your bot as channel admin
    1. open channel parameters > *Administrators* > *Get personal Chat ID*
    2. search for your bot username (ex: `@my_bot`)
    3. give it at least *Publish messages* rights (other rights are needed for simple notifications)
    - ⚠️ No need to send the command `/start` : the admin rights are enough to let the bot post.
- get the channel Chat ID
    1. post a message in the channel as a human admin
    2. go to this URL in a browser, replace `<TOKEN>` by your bot token :
    ```
    https://api.telegram.org/bot<TOKEN>/getUpdates
    ```
    3. search `"channel_post"` in the JSON response : it will contain`"chat":{"id": -1001234567890, "title": "Nom du canal", ...}`
    - if there isn't any response, send another message in the channel and check again the `getUpdates` URL (because it doesn't keep updates)
    - a channel (or group) ID is always negative and often starts with `-100` for channels/supergroups (ex: `-1001234567890`)
- enter this value in the secret `TELEGRAM_CHAT_ID` you have to create in your repository's *GitHub Actions* environment :
    - got to *Settings > Secrets and variables > Actions >* select the *Secrets* tab

---
# Add the action to your workflow
Paste this code block as the last step of a job you need to check :
```yml
# .github/workflows/your-worflow.yml
      - name: Notify Telegram
        if: always()
        env:
          TELEGRAM_BOT_TOKEN: ${{ secrets.TELEGRAM_BOT_TOKEN }}
          TELEGRAM_CHAT_ID: ${{ secrets.TELEGRAM_CHAT_ID }}
          JOB_STATUS: ${{ job.status }}
        # If you need another version, replace `latest` for another version, ex: `v1`
        uses: Theufyr/actions-library/.github/actions/telegram-notify@telegram-notify/latest
        with:
          bot_token: $TELEGRAM_BOT_TOKEN
          chat_id: $TELEGRAM_CHAT_ID
          status: $JOB_STATUS
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
Cette action envoie une notification _Telegram_ à la fin d'un workflow _GitHub Actions_ pour savoir s'il a réussi ou échoué.

### Marche à suivre
- enregistrer les clefs `TELEGRAM_BOT_TOKEN` et `TELEGRAM_CHAT_ID` dans les secrets de l'environnement *GitHub Actions* sur votre dépôt qui va utiliser l'*Action*
    - [Créer le bot perso](#créer-le-bot-perso)
    - [Démarrer une conversation avec le bot perso](#démarrer-une-conversation-avec-le-bot-perso)
    - [Récupérer l'ID d'un Chat personnel](#dans-le-cas-dun-chat-personnel)
    - [Récupérer l'ID d'un canal](#dans-le-cas-dun-canal)
- appeler l'*Action* dans le workflow de votre dépôt
    - [Ajouter l'action à votre workflow](#ajouter-laction-à-votre-workflow)

---
# Preparer Telegram
### Créer le bot perso
1. ouvrir Telegram et trouver *@BotFather*
   - taper dans la barre de recherche : `BotFather`
   - ⚠️ vérifier le badge de certification bleu : c'est le compte officiel
   - sélectionner le bot et cliquer sur *Démarrer*
2. envoyer `/newbot`
3. donner un nom d'affichage
    - par exemple : `Deploy Notifier`
4. donner un username unique se terminant par `bot`
    - par exemple : `mon_bot`
5. *@BotFather* répond avec un *token API* personnalisé, sous cette forme : `123456789:AAEuRWDTFD2UQ7agBtFSuhJf2-NmvHN3OPc`
6. donner cette valeur au secret `TELEGRAM_BOT_TOKEN` qu'il faut créer dans l'environnement *GitHub Actions* du dépôt qui va utiliser l'*Action* :
    - dans *Settings > Secrets and variables > Actions >* onglet *Secrets*

⚠️ *ATTENTION :*
Le token du bot donne un contrôle total sur ce bot (envoi de messages en son nom).
Si jamais il fuite :
- révoquer token immédiatement via *@BotFather* :
	- `/mybots` > sélectionne le bot perso > `Bot Settings` > `Revoke current token`
	- regénérer un nouveau token
	- aller le changer dans le secret `TELEGRAM_BOT_TOKEN`

---
### Démarrer une conversation avec le bot perso
Un bot peut envoyer un message privé à n'importe quel utilisateur, à condition que cet utilisateur ait initié la conversation en premier (contrainte anti-spam de *Telegram*, le bot ne peut pas écrire à quelqu'un qui ne lui a jamais parlé)
1. chercher le username du bot perso (ex: `@mon_bot`)
2. cliquer *Démarrer* (ou envoyer `/start`)

Sans cette étape, l'*API* refusera d'envoyer un message car le bot n'a pas le droit d'initier le contact.

---
### Récupérer l'ID
#### Dans le cas d'un Chat personnel
- si ce n'est pas déjà fait :
	1. chercher le username du bot perso (ex: `@mon_bot`)
	2. cliquer *Démarrer* (ou envoyer `/start`)
- aller sur cette URL dans un navigateur, en remplaçant `<TOKEN>` par le celui du bot perso :
```
   https://api.telegram.org/bot<TOKEN>/getUpdates
```
- une réponse JSON s'affiche contenant le Chat ID personnel, ex: `"chat":{"id": 123456789, ...}`
- donner cette valeur au secret `TELEGRAM_CHAT_ID` qu'il faut créer dans l'environnement *GitHub Actions* du dépôt qui va utiliser l'*Action* :
    - dans *Settings > Secrets and variables > Actions >* onglet *Secrets*

#### Dans le cas d'un canal
- créer le canal (si ce n'est pas déjà fait)
    - dans Telegram : nouveau canal, choisir *privé* ou *public* selon la préférence (les deux fonctionnent identiquement pour l'API bot)
- ajouter le bot perso comme administrateur du canal
	1. ouvrir les paramètres du canal > *Administrateurs* > *Récupérer le Chat ID personnel*
	2. chercher le username du bot perso (ex: `@mon_bot`)
	3. lui donner au minimum le droit *Publier des messages* (les autres droits ne sont pas nécessaires pour un simple envoi de notifications)
    - ⚠️ Contrairement à un chat privé, il n'y a pas besoin de `/start` car le fait d'être ajouté comme admin suffit à autoriser le bot à publier.
- récupérer le Chat ID du canal
	1. poster un message dans le canal quel qu'il soit en tant qu'admin humain
	2. aller sur cette URL dans un navigateur, en remplaçant `<TOKEN>` par le celui du bot perso :
	```
	https://api.telegram.org/bot<TOKEN>/getUpdates
	```
	3. chercher dans la réponse JSON un bloc `"channel_post"` contenant `"chat":{"id": -1001234567890, "title": "Nom du canal", ...}`
    - si aucune réponse n'est renvoyée, reposter un message sur le canal avant d'interroger à nouveau `getUpdates` qui ne renvoie que les mises à jour récentes non encore consommées
    - l'ID d'un canal (ou groupe) est toujours négatif, et souvent préfixé par `-100` pour les canaux/supergroupes (ex: `-1001234567890`), contrairement à l'ID positif d'un chat privé individuel
- donner cette valeur au secret `TELEGRAM_CHAT_ID` qu'il faut créer dans l'environnement *GitHub Actions* du dépôt qui va utiliser l'*Action* :
    - dans *Settings > Secrets and variables > Actions >* onglet *Secrets*

---
# Ajouter l'action à votre workflow
Copier/Coller ce bloc de code en tant que dernier _step_ du _job_ que vous voulez vérifier :
```yml
# .github/workflows/votre-worflow.yml
      - name: Notify Telegram
        if: always()
        env:
          TELEGRAM_BOT_TOKEN: ${{ secrets.TELEGRAM_BOT_TOKEN }}
          TELEGRAM_CHAT_ID: ${{ secrets.TELEGRAM_CHAT_ID }}
          JOB_STATUS: ${{ job.status }}
        # Si vous avez besoin d'une autre version que la plus récente
        # remplacer `latest` par la version désirée, ex: `v1`
        uses: Theufyr/actions-library/.github/actions/telegram-notify@telegram-notify/latest
        with:
          bot_token: $TELEGRAM_BOT_TOKEN
          chat_id: $TELEGRAM_CHAT_ID
          status: $JOB_STATUS
```