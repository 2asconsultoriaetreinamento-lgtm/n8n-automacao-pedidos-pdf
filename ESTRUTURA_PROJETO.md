ESTRUTURA_PROJETO.md# Estrutura Completa do Projeto - n8n Automacao Pedidos PDF

**Data**: 11 de Novembro de 2025  
**Versao**: v1.0.0  
**Status**: Estrutura documentada e pronta para desenvolvimento

---

## Arvore de Diretorio

```
n8n-automacao-pedidos-pdf/
├── README.md			# Descricao principal do projeto
├── ESTRUTURA_PROJETO.md	# Este arquivo
├── .gitignore			# Template Node.js
├── LICENSE			# MIT (a adicionar)
├── .github/
│   ├── ISSUE_TEMPLATE/
│   └── workflows/		# GitHub Actions (futuro)
├── docs/
│   ├── DUVIDAS.md		# 6 duvidas validadas com respostas
│   ├── ARQUITETURA.md	# Design do fluxo n8n
│   ├─┐ TESTES.md		# Template de testes e validacao
│   └─┐ CHANGELOG.md	# Historico de versoes
├─┐ workflows/
│   └─┐ pedidos-pdf-supabase.json  # Fluxo n8n (a desenvolver)
├─┐ scripts/
│   ├─┐ setup-supabase.sql	# DDL Supabase (a desenvolver)
│   └─┐ validate-parsing.js	# Teste do parser (a desenvolver)
├─┐ tests/
│   └─┐ sample-pdfs/
│       ├─┐ PED1752268076588.pdf	# PDF exemplo 1
│       ├─┐ PED1752587206347.pdf	# PDF exemplo 2
│       └─┐ PED1754424082584.pdf	# PDF exemplo 3
├─┐ notifications/
│   └─┐ templates/
│       ├─┐ success-email.html	# Template sucesso (Sprint 3)
│       └─┐ error-email.html		# Template erro (Sprint 3)
└─┐ config/
    └─┐ n8n-config.json	# Configuracoes n8n (a definir)
```

---

## Arquivos Existentes vs Pendentes

### Criados (v1.0.0 - Dia 1)
- [x] README.md - Documentacao principal
- [x] .gitignore - Template Node.js
- [x] docs/DUVIDAS.md - Q&A validadas
- [x] docs/ARQUITETURA.md - Design fluxo
- [x] docs/TESTES.md - Template testes
- [x] docs/CHANGELOG.md - Historico
- [x] ESTRUTURA_PROJETO.md - Este arquivo

### Pendentes (Sprints 1-3)
- [ ] workflows/pedidos-pdf-supabase.json - Fluxo n8n
- [ ] scripts/setup-supabase.sql - SQL de tabelas
- [ ] scripts/validate-parsing.js - Validador
- [ ] tests/sample-pdfs/ - PDFs de teste
- [ ] notifications/templates/ - Templates email/Telegram
- [ ] LICENSE - Licenca MIT
- [ ] .github/workflows/ - CI/CD GitHub Actions

---

## Guia de Atualizacao

### Quando Criar Novo Arquivo

1. **Fluxo n8n**: `workflows/pedidos-pdf-supabase.json`
   - Exportar do n8n como JSON
   - Validar estrutura
   - Commit com msg: `feat: Adiciona fluxo n8n v1.0`

2. **Script SQL**: `scripts/setup-supabase.sql`
   - DDL das tabelas Pedidos, Itens_Pedido, Logs_Importacao
   - Commit com msg: `docs: Adiciona script SQL Supabase`

3. **Template Email**: `notifications/templates/success-email.html`
   - Cada mensagem com logo/style
   - Commit com msg: `feat: Adiciona templates email (Sprint 3)`

### Quando Atualizar README/CHANGELOG

- **README.md**: Apenas secoes gerais ou links
- **CHANGELOG.md**: Toda mudanca importante (DEVE)
- **DUVIDAS.md**: Novas duvidas resolvidas
- **TESTES.md**: Apos executar cada teste
- **ARQUITETURA.md**: Se fluxo mudar significativamente

---

## Padroes de Commit

### Convention Commits
```
<tipo>(<escopo>): <descricao>

<corpo>

<rodape>
```

**Tipos**: feat, fix, docs, style, refactor, test, chore  
**Escopo**: n8n, supabase, parsing, testing, docs  
**Exemplo**: `feat(n8n): Adiciona node de validacao duplicidade`

---

## Checklist para Proxima Sprint

### Sprint 1 (Continua)
- [ ] Desenvolver workflows/pedidos-pdf-supabase.json
- [ ] Criar scripts/setup-supabase.sql
- [ ] Executar testes conforme TESTES.md
- [ ] Atualizar CHANGELOG.md

### Sprint 2
- [ ] Adicionar tabela Logs_Importacao
- [ ] Implementar error handling
- [ ] Atualizar docs/ARQUITETURA.md

### Sprint 3
- [ ] Criar templates email/Telegram
- [ ] Integrar n8n Email Node
- [ ] Documentar notificacoes

---

## Contribuicoes

Ao contribuir, siga:
1. Criar branch: `git checkout -b feature/nome-feature`
2. Fazer mudancas + testes
3. Commit com Convention Commits
4. Update docs/ se necessario
5. Update CHANGELOG.md
6. PR para main

---

**Mantenedor**: Noowx Consultoria
