# 📑 Índice e Estrutura de Documentação do Projeto

## Visão Geral

Este documento descreve a organização atual e futura da documentação do projeto n8n de automação de pedidos PDF (Taschibra).

---

## 📂 Estrutura Proposta de Diretórios

```
docs/
├── 00_INDEX_DOCUMENTACAO.md          # Este arquivo (guia de navegação)
├── README_ORGANIZACAO.md             # Documentação da reorganização
│
├── 01_GUIAS_RAPIDOS/
│   ├── README.md                     # Índice de guias rápidos
│   ├── GUIA_RAPIDO_v4.4.md          # Setup rápido (v4.4 - IMAP)
│   └── GUIA_RAPIDO_v4.5.md          # Setup rápido (v4.5 - Gmail Trigger)
│
├── 02_IMPLEMENTACAO/
│   ├── README.md                     # Índice de implementação
│   ├── IMPLEMENTACAO_v4.4_PASSO_A_PASSO.md
│   ├── IMPLEMENTACAO_v4.5_PASSO_A_PASSO.md
│   └── MIGRACAO_v4.4_para_v4.5.md   # Guia de migração
│
├── 03_CONFIGURACAO/
│   ├── README.md                     # Índice de configuração
│   ├── VARIAVEIS_AMBIENTE.md         # Variáveis de ambiente
│   ├── CONFIGURACAO_EMAIL_IMAP.md    # Config v4.4 (Email IMAP)
│   ├── CONFIGURACAO_GMAIL_OAUTH2.md  # Config v4.5 (Gmail OAuth2)
│   └── SETUP_SUPABASE.sql            # SQL de setup do banco
│
├── 04_ARQUITETURA/
│   ├── README.md                     # Índice de arquitetura
│   ├── ARQUITETURA.md                # Design geral do sistema
│   ├── FLUXO_DETALHADO_v4.4.md      # Detalhes do fluxo v4.4
│   ├── FLUXO_DETALHADO_v4.5.md      # Detalhes do fluxo v4.5
│   ├── NOTA_CORRECCAO_LOOP_v4.5.md  # Nota sobre loop corrigido
│   └── COMPARACAO_v4.4_vs_v4.5.md   # Comparação de versões
│
├── 05_VERSOES/
│   ├── README.md                     # Índice de versões
│   ├── CHANGELOG.md                  # Histórico de mudanças (todas versões)
│   ├── HISTORICO_VERSOES.md          # Detalhes de cada versão
│   ├── v4.0/
│   │   └── README.md                 # v4.0 - Scheduler (Inicial)
│   ├── v4.1/
│   │   └── README.md                 # v4.1 - Email Trigger (IMAP)
│   ├── v4.2/
│   │   └── README.md                 # v4.2 - Loop fixes
│   ├── v4.3/
│   │   └── README.md                 # v4.3 - Improvements
│   ├── v4.4/
│   │   ├── README.md                 # v4.4 - Final Email IMAP
│   │   └── RECOMENDACOES.md          # Recomendações de v4.4
│   └── v4.5/
│       ├── README.md                 # v4.5 - RECOMENDADO (Gmail Trigger)
│       ├── GMAIL_TRIGGER_RECOMENDACAO.md
│       └── NOTA_CORRECCAO.md         # Notas de correção
│
├── 06_COMPARACOES/
│   ├── README.md                     # Índice de comparações
│   ├── COMPARACAO_TRIGGERS.md        # Gmail vs IMAP vs Scheduler
│   └── MATRIZ_RECURSOSX_VERSOES.md   # Recurso por versão
│
├── 07_TESTES/
│   ├── README.md                     # Índice de testes
│   ├── TESTES.md                     # Plano de testes
│   ├── TESTE_IMPORTACAO_v4.0.md      # Testes v4.0
│   ├── TESTE_IMPORTACAO_v4.1.md      # Testes v4.1
│   └── TESTE_IMPORTACAO_v4.5.md      # Testes v4.5
│
├── 08_TROUBLESHOOTING/
│   ├── README.md                     # Índice de troubleshooting
│   ├── RESOLUCAO_PROBLEMA_LOOP.md    # Solução problema loop
│   ├── FAQV4.4.md                    # FAQ v4.4
│   └── FAQ_V4.5.md                   # FAQ v4.5
│
└── 99_ARQUIVOS_LEGADO/
    ├── README.md                     # Índice de legado
    ├── DUVIDAS.md                    # Dúvidas validadas (legado)
    ├── DEPLOYMENT.md                 # Guia deploy (legado)
    └── ARQUIVOS_REFERENCIA.md        # Arquivos de referência
```

---

## 📋 Mapeamento Atual → Novo

| Documento Atual | Localização Nova | Tipo |
|---|---|---|
| GUIA_RAPIDO_v4.4.md | 01_GUIAS_RAPIDOS/ | Guia Rápido |
| GUIA_RAPIDO_v4.5.md | 01_GUIAS_RAPIDOS/ | Guia Rápido |
| IMPLEMENTACAO_v4.4_PASSO_A_PASSO.md | 02_IMPLEMENTACAO/ | Implementação |
| IMPLEMENTACAO_v4.5_PASSO_A_PASSO.md | 02_IMPLEMENTACAO/ | Implementação |
| VARIAVEIS_AMBIENTE.md | 03_CONFIGURACAO/ | Configuração |
| CONFIGURACAO_EMAIL_IMAP.md | 03_CONFIGURACAO/ | Configuração |
| ARQUITETURA.md | 04_ARQUITETURA/ | Arquitetura |
| CHANGELOG.md | 05_VERSOES/ | Versionamento |
| GMAIL_TRIGGER_RECOMENDACAO.md | 04_ARQUITETURA/ | Arquitetura |
| NOTA_CORRECCAO_LOOP_v4.5.md | 04_ARQUITETURA/ | Arquitetura |
| RESOLUCAO_PROBLEMA_LOOP.md | 08_TROUBLESHOOTING/ | Troubleshooting |
| TESTES.md | 07_TESTES/ | Testes |
| TESTE_IMPORTACAO_v4.0.md | 07_TESTES/ | Testes |
| DUVIDAS.md | 99_ARQUIVOS_LEGADO/ | Legado |
| DEPLOYMENT.md | 99_ARQUIVOS_LEGADO/ | Legado |

---

## 🎯 Navegação por Caso de Uso

### 🚀 "Quero começar rápido (20 minutos)"
→ Vá para: **01_GUIAS_RAPIDOS/**
   - Se v4.4: `GUIA_RAPIDO_v4.4.md`
   - Se v4.5: `GUIA_RAPIDO_v4.5.md`

### 🔧 "Preciso implementar/fazer deploy"
→ Vá para: **02_IMPLEMENTACAO/**
   - Escolha versão (v4.4 ou v4.5)
   - Siga passos detalhados

### ⚙️ "Preciso configurar variáveis/credenciais"
→ Vá para: **03_CONFIGURACAO/**
   - Selecione tipo de trigger
   - Siga guia de setup

### 🏗️ "Preciso entender a arquitetura"
→ Vá para: **04_ARQUITETURA/**
   - Leia FLUXO_DETALHADO da sua versão
   - Compare versões se necessário

### 📈 "Quero ver histórico de versões"
→ Vá para: **05_VERSOES/**
   - Histórico completo
   - Detalhes de cada versão

### 🔀 "Devo migrar de v4.4 para v4.5?"
→ Vá para: **06_COMPARACOES/COMPARACAO_TRIGGERS.md**
   - Depois: **02_IMPLEMENTACAO/MIGRACAO_v4.4_para_v4.5.md**

### ✅ "Preciso testar/validar"
→ Vá para: **07_TESTES/**
   - Plano de testes
   - Testes específicos da versão

### 🆘 "Algo não está funcionando"
→ Vá para: **08_TROUBLESHOOTING/**
   - FAQ da sua versão
   - Guia de resolução

---

## 📚 Documentos Iniciais (Root)

Na raiz de `docs/` permanecem:

- **00_INDEX_DOCUMENTACAO.md** (este arquivo)
- **README_ORGANIZACAO.md** (explicação da reorganização)

---

## 🔄 Próximas Ações

1. ✅ Criar estrutura de diretórios
2. ✅ Mover documentos para suas pastas
3. ✅ Criar README.md em cada subdiretório
4. ✅ Atualizar links internos
5. ✅ Atualizar README.md principal

---

## 📖 Convenções de Nomenclatura

### Numeração de Diretórios
- `01_`, `02_`, etc. → Facilita ordenação alfabética

### Documentos
- Usar underscores para separação
- Versão no final se aplicável: `DOCUMENTO_v4.5.md`
- Começar com verbo: `COMPARACAO_`, `MIGRACAO_`, etc.

---

**Última Atualização**: 12 de Novembro de 2025  
**Status**: 📋 Estrutura Planejada
