#!/bin/bash
# ============================================================================
# TRAINERHUB: Bulk-Anlage aller Trainer aus Webseiten-Daten
# ============================================================================
# Voraussetzungen:
#   - bash, curl, jq installiert
#   - Hendrik-Account existiert mit Admin-Rechten
#   - Edge Function create-trainer ist deployed
#
# Was passiert:
#   1. Login als Hendrik → JWT-Token holen
#   2. Tommy von 'trainer' auf 'leitung' updaten (direkt SQL über REST)
#   3. 56 neue Trainer via create-trainer Edge Function anlegen
#   4. Erfolgs-/Fehler-Bilanz am Ende
# ============================================================================

set -e

SUPABASE_URL="https://rgtivdzmtfulnzbqzeou.supabase.co"
SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJndGl2ZHptdGZ1bG56YnF6ZW91Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcwNDAzMzYsImV4cCI6MjA5MjYxNjMzNn0.0TSBtFAOrFV8tHMHcKzJj5eFP5zU-RvE5Nm160Jjxt0"
DEFAULT_PASSWORD="Trainerhub26"

# --- 1. Hendrik-Credentials abfragen ---
echo "=== TrainerHub Bulk-Import ==="
echo
read -p "Hendrik Email: " ADMIN_EMAIL
read -s -p "Hendrik Passwort: " ADMIN_PASSWORD
echo
echo

# --- 2. Login → JWT-Token holen ---
echo "Login..."
LOGIN_RESPONSE=$(curl -s -X POST \
  "${SUPABASE_URL}/auth/v1/token?grant_type=password" \
  -H "apikey: ${SUPABASE_ANON_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"${ADMIN_EMAIL}\",\"password\":\"${ADMIN_PASSWORD}\"}")

JWT=$(echo "$LOGIN_RESPONSE" | jq -r '.access_token // empty')

if [ -z "$JWT" ]; then
  echo "FEHLER: Login fehlgeschlagen."
  echo "$LOGIN_RESPONSE" | jq .
  exit 1
fi

echo "Login OK."
echo

# --- 3. Tommy auf 'leitung' updaten ---
echo "Tommy → 'leitung' (Brinkum BL Fitness)..."
UPDATE_RESP=$(curl -s -X PATCH \
  "${SUPABASE_URL}/rest/v1/users?email=eq.tommy.brinkum@fitnesspark.de" \
  -H "apikey: ${SUPABASE_ANON_KEY}" \
  -H "Authorization: Bearer ${JWT}" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=representation" \
  -d '{"rolle":"leitung"}')
echo "  Response: ${UPDATE_RESP:0:120}"
echo

# --- 4. Trainer-Liste anlegen ---
# Format: "Name|Email|Studio|Rolle"
# Doppelte Vornamen mit Studio-Suffix in der Email automatisch eindeutig.

TRAINERS=(
  # === BECKETAL (Aumund) ===
  "Greta|greta.becketal@fitnesspark.de|Becketal|leitung"
  "Sönke|soenke.becketal@fitnesspark.de|Becketal|trainer"
  "Lea|lea.becketal@fitnesspark.de|Becketal|trainer"
  "Nancy|nancy.becketal@fitnesspark.de|Becketal|trainer"
  "Joshua|joshua.becketal@fitnesspark.de|Becketal|trainer"
  "Manfred|manfred.becketal@fitnesspark.de|Becketal|trainer"
  "Jakob|jakob.becketal@fitnesspark.de|Becketal|trainer"
  "Halit|halit.becketal@fitnesspark.de|Becketal|trainer"
  "Jennifer|jennifer.becketal@fitnesspark.de|Becketal|trainer"
  "Lucas|lucas.becketal@fitnesspark.de|Becketal|trainer"
  "Timon|timon.becketal@fitnesspark.de|Becketal|trainer"
  "Artur|artur.becketal@fitnesspark.de|Becketal|trainer"
  "Marc|marc.becketal@fitnesspark.de|Becketal|trainer"
  "Julian|julian.becketal@fitnesspark.de|Becketal|trainer"
  "Jesse|jesse.becketal@fitnesspark.de|Becketal|trainer"
  "Dario|dario.becketal@fitnesspark.de|Becketal|trainer"

  # === BURGLESUM ===
  # Daniel (Studioleitung Burglesum) existiert bereits als leitung
  # Janine existiert bereits als leitung
  "Charis|charis.burglesum@fitnesspark.de|Burglesum|trainer"
  "Jasmin|jasmin.burglesum@fitnesspark.de|Burglesum|trainer"
  "Damaris|damaris.burglesum@fitnesspark.de|Burglesum|trainer"
  "Chris|chris.burglesum@fitnesspark.de|Burglesum|trainer"
  "Tina|tina.burglesum@fitnesspark.de|Burglesum|trainer"
  "Roland|roland.burglesum@fitnesspark.de|Burglesum|trainer"
  "Tanja|tanja.burglesum@fitnesspark.de|Burglesum|trainer"
  "Moritz|moritz.burglesum@fitnesspark.de|Burglesum|trainer"

  # === HORN ===
  # Hannes (BL Fitness) existiert bereits als leitung
  "Felix|felix.horn@fitnesspark.de|Horn|trainer"
  "Susanne|susanne.horn@fitnesspark.de|Horn|trainer"
  "Maurice|maurice.horn@fitnesspark.de|Horn|trainer"
  "Leon|leon.horn@fitnesspark.de|Horn|trainer"
  "Pascal|pascal.horn@fitnesspark.de|Horn|trainer"
  "Yannik|yannik.horn@fitnesspark.de|Horn|trainer"
  "Anke|anke.horn@fitnesspark.de|Horn|trainer"
  "Feline|feline.horn@fitnesspark.de|Horn|trainer"
  "Tanja|tanja.horn@fitnesspark.de|Horn|trainer"
  "Fabian|fabian.horn@fitnesspark.de|Horn|trainer"

  # === BRINKUM ===
  # Hendrik existiert bereits als admin
  # Tommy wird oben auf leitung geupdatet
  # Jan existiert bereits als trainer
  "Regine|regine.brinkum@fitnesspark.de|Brinkum|trainer"
  "Benjamin|benjamin.brinkum@fitnesspark.de|Brinkum|trainer"
  "Mari|mari.brinkum@fitnesspark.de|Brinkum|trainer"
  "Nina|nina.brinkum@fitnesspark.de|Brinkum|trainer"
  "Dexter|dexter.brinkum@fitnesspark.de|Brinkum|trainer"
  "Jannick|jannick.brinkum@fitnesspark.de|Brinkum|trainer"
  "Vivien|vivien.brinkum@fitnesspark.de|Brinkum|trainer"
  "Christiane|christiane.brinkum@fitnesspark.de|Brinkum|trainer"
  "Julian|julian.brinkum@fitnesspark.de|Brinkum|trainer"
  "Insa|insa.brinkum@fitnesspark.de|Brinkum|trainer"

  # === DELMENHORST ===
  # Daniel (BL Fitness) existiert bereits als leitung
  "Nico|nico.delmenhorst@fitnesspark.de|Delmenhorst|trainer"
  "Ulrike|ulrike.delmenhorst@fitnesspark.de|Delmenhorst|trainer"
  "Hauke|hauke.delmenhorst@fitnesspark.de|Delmenhorst|trainer"
  "Julia|julia.delmenhorst@fitnesspark.de|Delmenhorst|trainer"
  "Andy|andy.delmenhorst@fitnesspark.de|Delmenhorst|trainer"
  "Laurin|laurin.delmenhorst@fitnesspark.de|Delmenhorst|trainer"
  "Martin|martin.delmenhorst@fitnesspark.de|Delmenhorst|trainer"
  "David|david.delmenhorst@fitnesspark.de|Delmenhorst|trainer"
  "Sören|soeren.delmenhorst@fitnesspark.de|Delmenhorst|trainer"
  "Leon|leon.delmenhorst@fitnesspark.de|Delmenhorst|trainer"
  "Maximilian|maximilian.delmenhorst@fitnesspark.de|Delmenhorst|trainer"
  "Kim|kim.delmenhorst@fitnesspark.de|Delmenhorst|trainer"
)

TOTAL=${#TRAINERS[@]}
SUCCESS=0
FAILED=0
FAILED_LIST=()

echo "=== Lege ${TOTAL} Trainer an ==="
echo

for TRAINER in "${TRAINERS[@]}"; do
  IFS='|' read -r NAME EMAIL STUDIO ROLLE <<< "$TRAINER"

  printf "[%-18s] %-15s %-12s %-8s ... " "$EMAIL" "$NAME" "$STUDIO" "$ROLLE"

  PAYLOAD=$(jq -n \
    --arg name "$NAME" \
    --arg email "$EMAIL" \
    --arg studio "$STUDIO" \
    --arg rolle "$ROLLE" \
    --arg pw "$DEFAULT_PASSWORD" \
    '{name: $name, email: $email, studio: $studio, rolle: $rolle, password: $pw}')

  RESPONSE=$(curl -s -X POST \
    "${SUPABASE_URL}/functions/v1/create-trainer" \
    -H "Authorization: Bearer ${JWT}" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD")

  ERROR=$(echo "$RESPONSE" | jq -r '.error // empty')
  if [ -z "$ERROR" ]; then
    echo "OK"
    SUCCESS=$((SUCCESS+1))
  else
    echo "FEHLER: $ERROR"
    FAILED=$((FAILED+1))
    FAILED_LIST+=("$EMAIL: $ERROR")
  fi
done

echo
echo "=== Ergebnis ==="
echo "Erfolgreich:    $SUCCESS / $TOTAL"
echo "Fehlgeschlagen: $FAILED / $TOTAL"

if [ $FAILED -gt 0 ]; then
  echo
  echo "Fehler-Details:"
  for FAIL in "${FAILED_LIST[@]}"; do
    echo "  - $FAIL"
  done
fi

echo
echo "Initial-Passwort für alle: $DEFAULT_PASSWORD"
echo "Bitte alle Trainer informieren, beim ersten Login zu ändern."
