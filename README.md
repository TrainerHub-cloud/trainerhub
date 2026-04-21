# TrainerHub online stellen — Schritt für Schritt

Alles passiert im Browser. Du brauchst kein Programm zu installieren.

---

## SCHRITT 1: API-Schlüssel holen (2 Minuten)

Der API-Schlüssel ist wie ein Passwort, damit TrainerHub mit der KI sprechen darf.

1. Öffne https://console.anthropic.com
2. Erstelle ein Konto (oder logge dich ein, falls du schon eins hast)
3. Klicke links auf **"API Keys"**
4. Klicke auf **"Create Key"**
5. Gib einen Namen ein, z.B. "TrainerHub"
6. Kopiere den Schlüssel — er fängt an mit sk-ant-...
7. **Speichere ihn irgendwo sicher ab** (z.B. Notizen-App). Du siehst ihn nur einmal.

Achtung: Für die API brauchst du Guthaben. Unter "Billing" kannst du z.B. 5$ aufladen. Das reicht für hunderte Briefings.

---

## SCHRITT 2: Netlify-Konto erstellen (1 Minute)

Netlify ist die Plattform, auf der deine Website läuft. Kostenlos.

1. Öffne https://app.netlify.com
2. Klicke auf **"Sign up"**
3. Wähle **"Sign up with email"** (oder GitHub, falls du das hast)
4. Bestätige deine E-Mail

---

## SCHRITT 3: Website hochladen (2 Minuten)

1. Lade die Datei **trainerhub-deploy.zip** herunter (die aus unserem Chat)
2. **Entpacke die ZIP-Datei** auf deinem Computer (Rechtsklick > Alle extrahieren)
3. Gehe zu https://app.netlify.com
4. Du siehst eine Seite mit dem Text **"Drag and drop your site output folder here"**
5. Öffne den entpackten Ordner auf deinem Computer — da drin ist ein Ordner namens **trainerhub-deploy**
6. **Ziehe den ganzen Ordner trainerhub-deploy** mit der Maus auf die Netlify-Seite
7. Warte kurz — Netlify zeigt dir eine URL wie z.B. sunny-dolphin-12345.netlify.app
8. Die Seite ist jetzt online, aber die KI funktioniert noch nicht (dafür brauchen wir Schritt 4)

---

## SCHRITT 4: API-Schlüssel eintragen (1 Minute)

Damit die KI funktioniert, muss Netlify deinen Schlüssel kennen.

1. Klicke auf Netlify auf deine neue Seite
2. Gehe zu **"Site configuration"** (links im Menü)
3. Klicke auf **"Environment variables"**
4. Klicke auf **"Add a variable"**
5. Trage ein:
   - **Key:** ANTHROPIC_API_KEY
   - **Values:** Füge hier deinen API-Schlüssel ein (der mit sk-ant-...)
6. Klicke auf **"Create variable"**

---

## SCHRITT 5: Nochmal deployen (30 Sekunden)

Nach dem Eintragen des Schlüssels muss die Seite einmal neu gestartet werden.

1. Gehe zu **"Deploys"** (links im Menü)
2. Klicke auf **"Trigger deploy"** dann auf **"Deploy site"**
3. Warte 30 Sekunden
4. Fertig. Öffne die URL — TrainerHub läuft.

---

## SCHRITT 6 (optional): Eigene Adresse statt Netlify-URL

Die Seite hat erstmal eine zufällige Adresse wie sunny-dolphin-12345.netlify.app.
Wenn du willst, kannst du:

- **Netlify-Name ändern:** Site configuration > Site details > Change site name > z.B. trainerhub-fp > Dann ist die Adresse trainerhub-fp.netlify.app
- **trainerhub.cloud verbinden:** Das machen wir später gemeinsam wenn gewünscht.

---

## Test-Zugänge

Wenn die Seite läuft, kannst du dich einloggen mit:

| Name | Studio | Rolle | PIN |
|------|--------|-------|-----|
| Hendrik | Brinkum | Leitung | 1234 |
| Tommy | Brinkum | Trainer | 0000 |
| Jan | Brinkum | Trainer | 0000 |

Über den **Team-Tab** (nur sichtbar als Leitung) kannst du weitere Trainer anlegen.

---

## Gut zu wissen

- **Anamnese-Daten werden NICHT gespeichert.** Die KI liest sie, erstellt das Briefing, und danach sind sie weg. Kein Datenschutz-Problem.
- **Erfolge werden im Browser gespeichert.** Das heisst: Jeder sieht nur seine eigenen Testdaten. Für den ersten Test reicht das.
- **Kosten:** Netlify ist kostenlos. Die KI kostet ca. 0,5-1 Cent pro Briefing.
