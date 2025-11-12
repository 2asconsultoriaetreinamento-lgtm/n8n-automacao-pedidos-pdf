# Arquitetura - n8n Automacao Pedidos PDF

## Visao Geral

Fluxo n8n end-to-end que processa PDFs Taschibra e persiste em Supabase.

**Stack**: n8n + Supabase (PostgreSQL) + JavaScript/Regex

---

## Diagrama do Fluxo

```
Scheduler (Cron)
    |
    v
Read Binary File (PDF)
    |
    v
PDF Extract (texto)
    |
    v
Parse Code Node (Regex + JS)
    |
    v
Check Duplicate (GET Supabase)
    |
    +--[Duplicado]--> Skip
    |
    +--[Novo]
         |
         v
    Insert Pedido (POST)
         |
         v
    Insert Itens Loop (POST x N)
         |
         v
    Send Notification [Sprint 3]
```

---

## Nodes Principais

### 1. Scheduler (Cron)
- Trigger: `0 */2 * * *` (a cada 2h)
- Ou: `0 9 * * MON-FRI` (seg-sex 9h)

### 2. Read Binary File
- L \u00ea PDF do sistema/FTP/S3
- Modo: Binary

### 3. PDF Extract
- Converte PDF para texto

### 4. Parse Code Node
- Usa regex para extrair:
  - numero_pedido, data_emissao, cliente_nome, etc
  - Array de itens

### 5. Check Duplicate
- GET /rest/v1/Pedidos?numero_pedido=eq.{numero_pedido}
- Se existe: Skip
- Se novo: Inserir

### 6. Insert Pedido
- POST /rest/v1/Pedidos
- Retorna: pedido_id

### 7. Insert Itens Loop
- FOR EACH item IN itens_array
- POST /rest/v1/Itens_Pedido
- Usa pedido_id como FK

### 8. Send Notification [Sprint 3]
- Email ou Telegram
- Status: OK / ERRO

---

## Tabelas Supabase

### Pedidos
- id (PK)
- numero_pedido (unique)
- data_emissao, cliente_nome, cliente_cnpj
- cidade, uf, valor_total, vendedor, canal, tipo
- created_at, updated_at

### Itens_Pedido
- id (PK)
- pedido_id (FK)
- produto, codigo, unidade, quantidade
- valor_unitario, valor_total
- ncm, ipi, tipo_item
- created_at

### Logs_Importacao [Sprint 2]
- id (PK)
- pedido_id (FK, nullable)
- status (SUCCESS/ERROR/SKIPPED)
- mensagem_erro, timestamp

---

## Seguranca

- Auth: Supabase API Key + Bearer Token
- Validacao: Unicidade por numero_pedido
- Integridade: Inserir Pedido antes de Itens (FK)
- Error Handling: Try-catch em Code Nodes

---

## Performance

- Loop: Um HTTP POST por item
- Rate Limit: Supabase 300k req/min
- Timeout: Configurar apropriadamente

---

## Manutencao

- Monitorar logs n8n
- Revisar Logs_Importacao (Sprint 2)
- Ajustar Cron conforme carga
- Documentar variacoes de PDF
