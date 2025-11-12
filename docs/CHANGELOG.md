# Changelog - n8n Automacao Pedidos PDF

## Versionamento

Seguimos [Semantic Versioning](https://semver.org/): MAJOR.MINOR.PATCH

---

## v4.5.0 - 12 de Novembro de 2025

### Adicionado

- **Gmail Trigger Nativo**: Substituição de Email Read IMAP por Gmail Trigger oficial n8n
- **OAuth2 Segurança**: Autenticação Google OAuth2 ao invés de password SMTP
- **Filtros Gmail Avançados**: Suporte a search queries nativas do Gmail
- **Gerenciamento de Labels**: Capacidade de aplicar labels e arquivar emails
- **Documentação Gmail**: Guia completo sobre Gmail Trigger vs IMAP

### Modificado

- **Primeiro Nó Atualizado**: Scheduler -> Email Trigger (IMAP) -> Gmail Trigger
- **Recomendação de Segurança**: v4.5 agora oficial, v4.4 mantido como alternativa
- **Suporte n8n Aprimorado**: Uso de nó mantido oficialmente pelo time n8n

### Detalhes Técnicos

- **Node Type**: `Gmail Trigger` (n8n-nodes-google-gmail)
- **Autenticação**: OAuth2 Google (sem exposição de senha)
- **Trigger**: Quando novo email chega em INBOX
- **Email Capture**: headers.from capturado automaticamente para email_vendedor
- **Polling**: A cada 1 minuto (otimizado pelo n8n)

---

## v4.4.0 - 19 de Dezembro de 2025

### Adicionado

- **Email Trigger (IMAP)**: Substituição do Scheduler por Email Trigger para receptação automática de pedidos via email
- **Suporte a Múltiplos Vendedores**: Campo email_vendedor adicionado para rastrear qual vendedor enviou cada pedido
- **Captura Automática de Email**: Email do remetente (From header) é capturado automaticamente e vinculado ao pedido
- **Documentação de Configuração**: Guia completo para setup IMAP (Hostinger e Gmail)
- **Script de Migração SQL**: Migration para adicionar email_vendedor às tabelas pedidos e processamento_logs
- **View de Relatórios**: CREATE VIEW vendedores_resumo para análise de vendedores
- **Tabela de Vendedores**: Nova tabela para gerenciamento centralizado de vendedores
- **RLS Policies**: Políticas de segurança (Row Level Security) para proteção de dados
- **Índices de Performance**: CREATE INDEX para otimização de queries com email_vendedor

### Modificado

- **Node Scheduler Removido**: Substituído por Email Trigger (n8n-nodes-base.emailReadImap)
- **Conexão do Trigger**: Email Trigger conectado diretamente ao ReadPDFFile
- **HTTP POST para InsertPedido**: Adicionado campo email_vendedor no body mapping
- **Email Extraction**: Uso de $node.EmailTrigger.json.headers.from para captura de email
- **Mark as Read**: Emails processados marcados como lidos automaticamente
- **Loop Over Items**: Mantido structure de feedback loop da v4.3.0

### Detalhes Técnicos

- **Node Type**: `n8n-nodes-base.emailReadImap`
- **Mailbox**: INBOX
- **Format**: simple (retorna texto e attachments)
- **Mark as Read**: true (após processamento)
- **Email Header**: headers.from contém email do vendedor
- **Database Field**: email_vendedor (VARCHAR 255, NOT NULL)
- **Index**: CREATE INDEX idx_pedidos_email_vendedor ON pedidos(email_vendedor)
- **View**: SELECT COUNT(*) by email_vendedor for vendor analytics

### Custo e Viabilidade

- **Custo**: R$ 0/mês (usa Gmail/Hostinger existente)
- **Escalabilidade**: Suporta múltiplos vendedores sem custos adicionais
- **Manutenção**: Mínima - configuração única em n8n credentials
- **Alternativas Rejeitadas**: WhatsApp (R$ 50-300/mês), Telegram (R$ 0 mas manual)

### Roadmap Futuro

- [ ] Integração LDAP para enriquecimento de dados de vendedor (nome, departamento)
- [ ] Dashboard de Supabase com métricas por vendedor
- [ ] Notificações de Email para cada vendedor confirmar recebimento
- [ ] Validação de domínio de email (apenas @empresa.com.br)
- [ ] Autenticação de email via SPF/DKIM para segurança

---

## v4.3.0 - 19 de Dezembro de 2025

### Corrigido

- **Feedback Loop Implementado**: Nó Loop Over Items (Split in Batches) agora possui feedback loop correto
- **Suporte a Múltiplos Itens**: Todos os itens do array 'itens' são processados individualmente
- **Estrutura JSON Aprimorada**: Propriedade 'output' adicionada ao nó Loop para iteração contínua
- **Validação de Duplicidade Preservada**: Se pedido já existe, workflow pula para LogSuccess
- **Referência de Item Corrigida**: Usa `$item.json` para acessar cada item no loop

### Detalhes da Solução

- Problema em v4.2: Tipo de nó `n8n-nodes-base.splitInBatches` estava correto, mas a estrutura de feedback loop estava ausente
- Solução: Adicionada conexão bidirecional entre LoopItems e InsertItens na seção 'connections'
- Fluxo de execução: LoopItems envia item → InsertItens processa → retorna para LoopItems (próximo item)
- Continua até `$node.LoopItems.context['noItemsLeft']` ser true

---

## v4.0.0 - 12 de Novembro de 2025

### Corrigido
- Node 'PDF Extract (OCR)' removido por incompatibilidade com n8n padrão
- Todas as 10 conexões entre nodes agora estão interligadas corretamente
- Fluxo de parsing otimizado para usar apenas Code node (JavaScript)
- Posições dos nodes ajustadas para melhor visualização
- JSON validado e testado para compatibilidade total com n8n

### Modificado
- Versão do fluxo atualizada de 3.0 para 4.0
- Estrutura do fluxo simplificada de 11 para 10 nodes funcionais
- Tamanho do arquivo reduzido de 7.26 KB para 7.04 KB

### Status
- ✅ JSON válido e importável sem erros
- ✅ Todas as conexões de nodes validadas
- ✅ Pronto para importação em instância n8n

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


## v3.0.0 - 12 de Novembro de 2025

### Adicionado

- Loop Node: Iteracao em array de itens para processamento em lote
- Extended Parsing: Regex patterns para 10+ campos de pedidos
- Conditional Flow: Node IF para validacao de duplicidade
- HTTP GET Node: Consulta Supabase com filtro numero_pedido
- Logging Nodes: 3 nodes HTTP POST para sucesso, duplicidade e erros
- Error Handling: continueOnFail para todos nodes HTTP
- Body Mapping: Mapeamento JSON com n8n expressions
- Environment Variables: $env.SUPABASE_URL, $env.SUPABASE_KEY, $env.SUPABASE_SECRET_KEY

### Arquitetura Completa v3.0

Fluxo: Scheduler > ReadFile > ExtractPDF > ParseData > HTTPGet > IF > InsertPedido > Loop > InsertItens > LogSucesso

### Nodes Implementados

1. SchedulerTrigger (cron) - Executa a cada minuto
2. ReadPDFFile (readBinaryFile) - Leitura de arquivo PDF
3. ExtractPDF (pdfExtract) - Extracao OCR de texto
4. ParseData (code) - JavaScript com regex patterns
5. CheckDuplicate (httpRequest GET) - Validacao de numero_pedido
6. ValidateDuplicateCondition (if) - Condicional para duplicidade
7. InsertPedido (httpRequest POST) - Insercao na tabela pedidos
8. LoopItens (loop) - Iteracao em array de itens
9. InsertItens (httpRequest POST) - Insercao em tabela itens_pedido
10. LogSucesso (httpRequest POST) - Registro de sucesso
11. LogDuplicidade (httpRequest POST) - Registro de duplicidade
12. Connections e settings: Active, errorHandler save, timeout 3600s

### Melhorias v3.0

- Loops explícitos para processamento de múltiplos itens
- Validacao robusta com condicional ramificado (true/false)
- Logging estruturado em 3 cenários diferentes
- Regex patterns otimizados para layout Taschibra
- API REST completa com Supabase REST

---

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
