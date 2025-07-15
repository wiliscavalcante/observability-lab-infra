#!/bin/bash

MISSING=()

check_command() {
  if ! command -v "$1" &> /dev/null; then
    echo -e "❌ '$1' não encontrado."
    MISSING+=("$1")
  else
    echo -e "✅ $1 encontrado."
  fi
}

echo -e "\n🔍 Verificando dependências necessárias..."

check_command docker
check_command kind
check_command terraform

if [ ${#MISSING[@]} -eq 0 ]; then
  echo -e "\n✅ Todas as dependências estão instaladas. Pronto para executar o Terraform."
else
  echo -e "\n⚠️ As seguintes dependências estão ausentes e precisam ser instaladas antes de continuar:"
  for dep in "${MISSING[@]}"; do
    echo -e "   - $dep"
  done
  echo -e "\n🚫 Corrija os requisitos acima e execute novamente."
  exit 1
fi
