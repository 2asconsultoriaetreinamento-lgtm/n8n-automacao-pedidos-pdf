# 📋 Plano de Organização de Documentos

**Data**: 12 de Novembro de 2025
**Status**: Planejamento para execução

Este documento lista todos os arquivos de documentação existentes e onde devem ser movidos na nova estrutura de dire tórios.

---

## 📂 Mapeamento de Arquivos

### 01_GUIAS_RAPIDOS
Guias de início rápido (20 minutos)

- `GUIA_RAPIDO_v4.4.md` ✅
- `GUIA_RAPIDO_v4.5.md` ✅

**Ação**: Mover para `01_GUIAS_RAPIDOS/`

---

### 02_IMPLEMENTACAO
Guias de implementação passo a passo

- `IMPLEMENTACAO_v4.4_PASSO_A_PASSO.md` ✅
- `IMPLEMENTACAO_v4.5_PASSO_A_PASSO.md` ✅
- `IMPORTACAO_N8N.md` ✅ (criar versão `MIGRACAO_v4.4_para_v4.5.md` se necessário)

**Ação**: Mover para `02_IMPLEMENTACAO/`

---

### 03_CONFIGURACAO
Guias de configuração e setup

- `CONFIGURACAO_EMAIL_IMAP.md` ✅
- `VARIAVEIS_AMBIENTE.md` ✅
- (Criar `CONFIGURACAO_GMAIL_OAUTH2.md` se necessário)
- (Criar `SETUP_SUPABASE.sql` se necessário)

**Ação**: Mover para `03_CONFIGURACAO/`

---

### 04_ARQUITETURA
Documentação de arquitetura e design

- `ARQUITETURA.md` ✅
- `FLUXO_DETALHADO_v4.4.md` ⚠️ (não encontrado - pode ser integrado em ARQUITETURA.md)
- `FLUXO_DETALHADO_v4.5.md` ⚠️ (não encontrado - pode ser integrado em ARQUITETURA.md)
- `COMPARACAO_v4.4_vs_v4.5.md` ✅ (na verdade: criar ou mover de 06_COMPARACOES)
- `NOTA_CORRECCAO_LOOP_v4.5.md` ✅ (ou em 08_TROUBLESHOOTING)
- `GMAIL_TRIGGER_RECOMENDACAO.md` ✅

**Ação**: Mover para `04_ARQUITETURA/`

---

### 05_VERSOES
Versões e changelog

- `CHANGELOG.md` ✅
- `IMPORTACAO_N8N.md` (pode ter informações de versão)

**Ação**: Mover para `05_VERSOES/`

**Subdiretórios**: Criar subdirs v4.0/, v4.1/, v4.2/, v4.3/, v4.4/, v4.5/

---

### 06_COMPARACOES
Análises comparativas

- `COMPARACAO_v4.4_vs_v4.5.md` ✅ (criar se não existir)
- `COMPARACAO_TRIGGERS.md` ✅ (criar baseado em `GMAIL_TRIGGER_RECOMENDACAO.md`)
- `MATRIZ_RECURSOS_VERSOES.md` ✅ (criar)

**Acao**: Criar e mover para `06_COMPARACOES/`

---

### 07_TESTES
Documentação de testes

- `TESTES.md` ✅
- `TESTE_IMPORTACAO_v4.0.md` ✅
- `TESTE_IMPORTACAO_v4.5.md` ✅ (criar se não existir)
- `CHECKLIST_DEPLOY.md` ✅ (criar)

**Acao**: Mover para `07_TESTES/`

---

### 08_TROUBLESHOOTING
Resolução de problemas

- `RESOLUCAO_PROBLEMA_LOOP.md` ✅
- `NOTA_CORRECCAO_LOOP_v4.5.md` ✅ (ou em 04_ARQUITETURA)
- `FAQ_v4.4.md` ✅ (criar)
- `FAQ_v4.5.md` ✅ (criar)
- `GUIA_DIAGNOSTICO.md` ✅ (criar)
- `LOGS_COMUNS.md` ✅ (criar)

**Acao**: Mover para `08_TROUBLESHOOTING/`

---

### 99_ARQUIVOS_LEGADO
Arquivos descontinuados ou obsoletos

- `DUVIDAS.md` ✅
- `DEPLOYMENT.md` ✅
- (Criar `ARQUIVOS_REFERENCIA.md`)

**Acao**: Mover para `99_ARQUIVOS_LEGADO/`

---

## 📌 Arquivos que Permanecem na Raiz /docs

Esses arquivos servem como índices e guias de navegação:

- `00_INDEX_DOCUMENTACAO.md` - Índice principal
- `README_ORGANIZACAO.md` - Resumo da reorganização
- `PLANO_ORGANIZACAO_DOCS.md` - Este arquivo (plano de execução)

---

## ✅ Próximos Passos

1. **Mover arquivos existentes** para os dire tórios apropriados via GitHub UI
2. **Criar arquivos faltantes** (FAQ, Comparações, etc.)
3. **Atualizar links internos** em todos os README.md
4. **Verificar referências cruzadas**
5. **Testar navegação** entre seções
6. **Criar commit final** com a organização completa

---

## 📊 Resumo

| Diretório | Arquivos | Status |
|-----------|----------|--------|
| 01_GUIAS_RAPIDOS | 2 | Pronto para mover |
| 02_IMPLEMENTACAO | 3 | Pronto para mover |
| 03_CONFIGURACAO | 2 | Pronto para mover |
| 04_ARQUITETURA | 4+ | Pronto para mover |
| 05_VERSOES | 2 | Pronto para mover |
| 06_COMPARACOES | 2-3 | Criar + mover |
| 07_TESTES | 3-4 | Criar + mover |
| 08_TROUBLESHOOTING | 4-6 | Criar + mover |
| 99_ARQUIVOS_LEGADO | 2-3 | Pronto para mover |

**Total**: ~28-35 arquivos a organizar

---
**Última Atualização**: 12 de Novembro de 2025
