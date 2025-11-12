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

## v2.0.0 - 15 de Novembro de 2025

### Adicionado

- Expansao completa do fluxo n8n com 8 nodes para processamento de PDFs
- ReadPDFFile: Leitura binaria e processamento de arquivos PDF
- ExtractPDF: Extracao de texto com OCR em n8n
- ParseData: Node JavaScript com regex para parsing de dados de pedidos
- CheckDuplicate: Validacao HTTP GET em Supabase para evitar duplicidade
- InsertPedido: Insercao de registros de pedidos via HTTP POST
- LoopItens: Construtor de loop para iteracao de itens do pedido
- InsertItens: Insercao em lote de itens do pedido via HTTP POST
- Configuracao de variaveis de ambiente ($env.SUPABASE_URL, $env.SUPABASE_KEY)
- Mapeamento completo de parametros entre nodes
- Headers HTTP com autenticacao Bearer
- Tratamento de erros configurado para "save" e debug

### Modificado

- workflows/pedidos-pdf-supabase.json: Expandido de v1.0 (1 node) para v2.0 (8 nodes)
- CHANGELOG.md: Atualizado com informacoes de v2.0.0

---
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
