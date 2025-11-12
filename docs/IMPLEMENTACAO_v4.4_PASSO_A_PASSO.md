# Implementacao v4.4: Email Trigger - Guia Simplificado

## Objetivo: Receber pedidos por EMAIL

Múltiplos vendedores enviam PDFs para `pedidos@seudominio.com.br` → n8n processa → Supabase registra com email do vendedor.

---

## PASSO 1: Preparar Supabase (5 min)

1. Abra SQL Editor no Supabase
2. Execute script: `scripts/migration-add-email-vendedor.sql`
3. Resultado: 7 queries success

✓ Coluna `email_vendedor` criada em tabelas: pedidos, processamento_logs
✓ Indices criados para performance
✓ VIEW `vendedores_resumo` para relatorios

---

## PASSO 2: Configurar n8n (10 min)

### 2.1 Importar Workflow
1. n8n → Workflows → Import from JSON
2. Cole JSON v4.4
3. Nome: "Automacao Pedidos PDF - Taschibra v4.4"

### 2.2 Environment Variables
1. Settings → Environment variables
2. Adicione:
   - SUPABASE_URL = https://seu-projeto.supabase.co
   - SUPABASE_KEY = sua-chave-api

### 2.3 Email Trigger (IMAP)
1. Clique node "Email Trigger (IMAP)" (primeiro)
2. + Credentials

**Opcao A: Hostinger (RECOMENDADO)**
```
User: pedidos@seudominio.com.br
Password: sua_senha
Host: imap.hostinger.com
Port: 993
SSL/TLS: Ativado
```

**Opcao B: Gmail**
```
User: seu_email@gmail.com
Password: [app_password]
Host: imap.gmail.com
Port: 993
```
Veja CONFIGURACAO_EMAIL_IMAP.md para gerar app password

3. Test Connection
4. Salve credenciais

### 2.4 Ativar Workflow
Clique toggle "Active" (mude para VERDE)

---

## PASSO 3: Testar (5 min)

1. **Envie email de teste:**
   - Para: pedidos@seudominio.com.br
   - Anexo: PDF com dados de pedido
   - Assunto: "Pedido novo"

2. **Monitore n8n:**
   - Tab "Executions"
   - Aguarde 1-2 min (polling IMAP)
   - Verde ✓ = sucesso
   - Vermelho ✗ = erro (clique para detalhes)

3. **Verifique Supabase:**
   - Tabela "pedidos"
   - Veja nova linha com email_vendedor preenchido
   - Tabela "pedido_itens" tem todos os items

---

## Arquivos de Suporte

| Arquivo | Onde |
|---------|------|
| CONFIGURACAO_EMAIL_IMAP.md | docs/ |
| migration-add-email-vendedor.sql | scripts/ |
| pedidos-pdf-supabase.json | workflows/ |

---

## Troubleshooting

| Erro | Solucao |
|------|----------|
| Nao dispara | Toggle Active verde? Aguarde 2 min |
| Connection refused | Host/Port corretos? Verifique imap.hostinger.com:993 |
| PDF nao lido | Anexo chegou? PDF valido? |
| Email_vendedor vazio | Migration executada? Coluna existe? |

---

**Versao**: 4.4 | **Status**: 🚨 PRONTO PARA PRODUCAO | **Data**: 12 Nov 2025
