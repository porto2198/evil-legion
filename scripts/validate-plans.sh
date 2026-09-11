#!/bin/bash

# ================================================
# 🔍 Evil Quality Control
# ================================================
# Verifies that all plans comply with the Legion's
# rules before being approved by the Council.
#
# Verified rules:
#   #1 - Every plan must have an escape plan
#   #2 - Launch codes must not be stored in the repository
#   #3 - All villains must have active status
# ================================================

ERRORS=0
WARNINGS=0

echo "╔══════════════════════════════════════╗"
echo "║       🔍 EVIL QUALITY CONTROL       ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "Review requested by: Lex Luthor"
echo "Executed by: Brainiac v12.0"
echo "Date: $(date -u +"%d/%m/%Y - %H:%M UTC")"
echo ""

# ──────────────────────────────────────────
# Rule #1: Every plan must have an escape plan
# ──────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Rule #1: Checking escape plans..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if ls plans/*.md 1>/dev/null 2>&1; then
  for plan in plans/*.md; do
    PLAN_NAME=$(basename "$plan" .md)

    if ! grep -q "## Plan de escape" "$plan"; then
      echo "  ❌ $PLAN_NAME — Does NOT have an escape plan."
      echo "     → Rejected by the Council. Do you want Batman to catch you?"
      ERRORS=$((ERRORS + 1))
    else
      echo "  ✅ $PLAN_NAME — Escape plan verified."
    fi
  done
else
  echo "  ⚠️  No plans were found in plans/"
  WARNINGS=$((WARNINGS + 1))
fi

echo ""

# ──────────────────────────────────────────
# Rule #2: Launch codes
# ──────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Rule #2: Checking launch codes..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Search for .env files tracked by Git
ENV_FILES=$(git ls-files "*.env" 2>/dev/null)

if [ -n "$ENV_FILES" ]; then
  echo "  ❌ RED ALERT! .env files detected in the repository:"

  echo "$ENV_FILES" | while read -r file; do
    echo "     → $file"
  done

  echo "     Whoever committed them will be handed over to Batman!"
  ERRORS=$((ERRORS + 1))
else
  echo "  ✅ No .env files are tracked by Git."
  echo "     The launch codes are safe."
fi

echo ""

# ──────────────────────────────────────────
# Rule #3: Verify villain records
# ──────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Rule #3: Checking villain records..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if ls members/*.yml 1>/dev/null 2>&1; then
  for record in members/*.yml; do
    NAME=$(grep "^nombre:" "$record" | head -1 | sed 's/nombre: *//;s/"//g')

    if [ -z "$NAME" ]; then
      NAME=$(basename "$record" .yml)
    fi

    if ! grep -q "estado: activo" "$record"; then
      echo "  ⚠️  $NAME — Status is not 'active'. Captured by the heroes?"
      WARNINGS=$((WARNINGS + 1))
    else
      echo "  ✅ $NAME — Active and ready for the mission."
    fi
  done
else
  echo "  ⚠️  No villain records were found in villains/"
  WARNINGS=$((WARNINGS + 1))
fi

echo ""

# ──────────────────────────────────────────
# Verify intelligence dossiers
# ──────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Checking hero intelligence..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if ls intelligence/losers/*.md 1>/dev/null 2>&1; then
  TOTAL_DOSSIERS=$(ls intelligence/losers/*.md | wc -l)

  echo "  📁 $TOTAL_DOSSIERS hero dossiers found in the database."

  for dossier in intelligence/*.md; do
    HERO_NAME=$(basename "$dossier" .md)

    if ! grep -q "## Estrategia recomendada" "$dossier"; then
      echo "  ⚠️  $HERO_NAME — Missing recommended strategy."
      echo "     → Brainiac: 'A dossier without a strategy is just a poster.'"
      WARNINGS=$((WARNINGS + 1))
    else
      echo "  ✅ $HERO_NAME — Dossier complete."
    fi
  done
else
  echo "  ⚠️  No intelligence dossiers were found in intelligence/"
  WARNINGS=$((WARNINGS + 1))
fi

echo ""

# ──────────────────────────────────────────
# Final result
# ──────────────────────────────────────────
echo "╔══════════════════════════════════════╗"
echo "║            FINAL RESULT             ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "  Critical errors: $ERRORS"
echo "  Warnings:        $WARNINGS"
echo ""

if [ "$ERRORS" -gt 0 ]; then
  echo "  ❌ REJECTED BY THE COUNCIL"
  echo ""
  echo "  Lex Luthor: 'Unacceptable. Fix this before the merge.'"
  echo "  Magneto: 'I will not tolerate incompetence.'"
  echo ""

  exit 1
else
  if [ "$WARNINGS" -gt 0 ]; then
    echo "  ✅ APPROVED WITH OBSERVATIONS"
    echo ""
    echo "  Lex Luthor: 'Approved, but review the warnings.'"
    echo ""
  else
    echo "  ✅ APPROVED BY THE COUNCIL"
    echo ""
    echo "  Lex Luthor: 'Perfect. Proceed with the mission.'"
    echo "  Brainiac: 'Probability of success: calculating...'"
    echo ""
  fi

  exit 0
fi
