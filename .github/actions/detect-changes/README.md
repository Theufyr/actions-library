#### English version
[Afficher la version française](#version-française)

---
# Overview
This action notifies your workflow of any changes in `frontend` or `backend` directories since the last commit on the distant branch (the last push/merge/etc.). The workflow will know what to update and will avoid useless *build* or *FTP* operations.

You can also use some tags with this action, in your commit's comment, to notify the workflow to force updates even if no change has been detected. The action returns `true`/`false` for `frontend`, `backend` and `reinit`. You can use these variables to trigger other steps than updates in your workfkow (tests for exemple).

#### How-to
- [Add the action to your workflow](#add-the-action-to-your-workflow)
- use the returned variables in your workflow to trigger updates, tests, etc.<br>
    list of received variables with a `true` or `false` value if your workflow step ID is `changes` (name of your choice) :
    - `${{ steps.changes.outputs.frontend }}`
    - `${{ steps.changes.outputs.backend }}`
    - `${{ steps.changes.outputs.reinit }}`
- [Example of variables usage](#example-of-variables-usage)
- [Examples of tags usage](#examples-of-tags-usage)

---
#### Example of variables usage
```yml
# .github/workflows/your-worflow.yml
      - name: Install frontend dependencies
        if: steps.changes.outputs.reinit == 'true' || steps.changes.outputs.frontend == 'true'
        working-directory: frontend
        run: npm ci

      - name: Build frontend
        if: steps.changes.outputs.reinit == 'true' || steps.changes.outputs.frontend == 'true'
        working-directory: frontend
        env:
          VITE_BASENAME: ${{ vars.VITE_BASENAME }}
          VITE_API_URL: ${{ vars.VITE_API_URL }}
        run: npm run build
```

---
#### Examples of tags usage
You can use these commands in the terminal :
```bash
# tags can be anywhere in the commit's comment
git commit -m "feat: [frontend] something new was added"
git push

git commit -m "[backend] feat: something new was added"
git push

# use the flag --allow-empty
# to send a commit where nothing changed but will trigger a tag
git commit --allow-empty -m "Trigger redeploy [reinit]"
git push
```

---
# Add the action to your workflow
Paste this code block in a job before the steps that need the variables :
```yml
# .github/workflows/your-worflow.yml
      - name: Detect changes
        id: changes
        # If you need another version, replace `latest` for another version, ex: `v1`
        uses: Theufyr/actions-library/.github/actions/detect-changes@detect-changes/latest

      # OPTIONNAL : check results
      # display the outputs in GitHub Actions logs
      - name: Debug changes outputs
        run: |
          echo "backend=${{ steps.changes.outputs.backend }}"
          echo "frontend=${{ steps.changes.outputs.frontend }}"
          echo "reinit=${{ steps.changes.outputs.reinit }}"
          cat changed.txt || true
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
Cette action permet de prévenir le workflow si le contenu des dossiers `frontend` ou `backend` ont été modifiés depuis le dernier commit de la branche distante (donc le dernier push/merge/etc) pour qu'il sache automatiquement quoi mettre à jour et éviter, par exemple, un *build* ou des opérations *FTP* inutiles.

Elle permet aussi avec un simple tag ajouté dans le commentaire d'un commit, de signaler au workflow (même si aucun changement n'a été détecté), qu'on désire réinitialiser tout ou partie de l'app sur l'hébergeur.

L'action retourne au worklow des valeurs `true`/`false` pour `frontend`, `backend` et `reinit`, qui peuvent être utilisées pour déclencher autre chose que des mises à jour dans le worflow (des tests par exemple).

### Marche à suivre
- [Ajouter l'action à votre workflow](#ajouter-laction-à-votre-workflow)
- utiliser les variables renvoyées au workflow pour déclencher des mises à jour, tests, etc.<br>
    liste des variables obtenues (retournant une valeur `true` ou `false`) si `changes` est l'ID du step de votre workflow (nom au choix) :
    - `${{ steps.changes.outputs.frontend }}`
    - `${{ steps.changes.outputs.backend }}`
    - `${{ steps.changes.outputs.reinit }}`
- [Exemple d'utilisation des variables](#exemple-dutilisation-des-variables)
- [Exemples d'utilisation des tags](#exemples-dutilisation-des-tags)

---
#### Exemple d'utilisation des variables
```yml
# .github/workflows/votre-worflow.yml
      - name: Install frontend dependencies
        if: steps.changes.outputs.reinit == 'true' || steps.changes.outputs.frontend == 'true'
        working-directory: frontend
        run: npm ci

      - name: Build frontend
        if: steps.changes.outputs.reinit == 'true' || steps.changes.outputs.frontend == 'true'
        working-directory: frontend
        env:
          VITE_BASENAME: ${{ vars.VITE_BASENAME }}
          VITE_API_URL: ${{ vars.VITE_API_URL }}
        run: npm run build
```

---
#### Exemples d'utilisation des tags
Dans le terminal utiliser ces commandes :
```bash
# les tags peuvent être placés n'importe où dans le commentaire
git commit -m "feat: [frontend] something new was added"
git push

git commit -m "[backend] feat: something new was added"
git push

# utilisation du flag --allow-empty
# pour envoyer un commit où rien n'a changé mais qui déclenche un tag
git commit --allow-empty -m "Trigger redeploy [reinit]"
git push
```

---
# Ajouter l'action à votre workflow
Copier/Coller ce bloc de code dans le  _job_ avant les _steps_ qui ont besoin des variables :
```yml
# .github/workflows/votre-worflow.yml
      - name: Detect changes
        id: changes
        # Si vous avez besoin d'une autre version que la plus récente
        # remplacer `latest` par la version désirée, ex: `v1`
        uses: Theufyr/actions-library/.github/actions/detect-changes@detect-changes/latest

      # FACULTATIF : vérification des résultats
      # permet d'afficher un retour dans les logs de GitHub Actions
      - name: Debug changes outputs
        run: |
          echo "backend=${{ steps.changes.outputs.backend }}"
          echo "frontend=${{ steps.changes.outputs.frontend }}"
          echo "reinit=${{ steps.changes.outputs.reinit }}"
          cat changed.txt || true
```