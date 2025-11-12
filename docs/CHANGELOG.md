# Changelog - n8n Automacao Pedidos PDF

## Versionamento

Seguimos [Semantic Versioning](https://semver.org/): MAJOR.MINOR.PATCH

---

## v1.0.0 - 11 de Novembro de 2025

### Adicionado
- Estrutura base do repositorio GitHub
- README.md com visao geral do projeto
- docs/DUVIDAS.md - Respostas a 6 duvidas principais
- docs/ARQUITETURA.md - Design e fluxo do n8n
- docs/TESTES.md - Template de testes e validacao
- docs/CHANGELOG.md - Este arquivo
- .gitignore com template Node.js

### Planejado (Backlog)
- [x] workflows/pedidos-pdf-supabase.json - Fluxo n8n CRIADO
- scripts/setup-supabase.sql - DDL para tabelas
- notifications/templates/ - Templates de email/Telegram

### Roadmap

**Sprint 1 (v1.0 - Atual)**: Funcionalidade basica
- [x] Estrutura de documentacao
- [ ] Fluxo n8n funcional
- [ ] Testes iniciais

**Sprint 2 (v1.1)**: Logging e Erros
- [ ] Tabela Logs_Importacao
- [ ] Error handling robusto
- [ ] Monitoramento de execucao

**Sprint 3 (v1.2)**: Notificacoes
- [ ] Integracao Email
- [ ] Integracao Telegram
- [ ] Templates de mensagens

**Backlog**: Futuro
- [ ] Integracao ERP
- [ ] Dashboard Supabase
- [ ] Auditoria de mudancas

---

## Como Atualizar o Changelog

Cada novo commit deve atualizar este arquivo seguindo:

```markdown
## v1.0.X - DATA

### Adicionado
- Funcionalidade nova A
- Funcionalidade nova B

### Modificado
- Comportamento alterado X

### Corrigido
- Bug Y

### Removido
- Funcionalidade Z
```

**Secoes**: Adicionado, Modificado, Corrigido, Removido, Seguranca, Deprecado

---

## Historico Completo

Veja commits no Git: `git log --oneline`
