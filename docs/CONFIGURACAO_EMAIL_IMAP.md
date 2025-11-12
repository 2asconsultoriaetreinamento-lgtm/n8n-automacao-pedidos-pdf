# Guia de Configuração: Email Trigger (IMAP) - Hostinger + Gmail

Este guia explica como configurar o workflow v4.4 para receber pedidos via email.

## Opção 1: Usar Email Hostinger (RECOMENDADO)

### Passo 1: Obter credenciais Hostinger

1. Acesse painel Hostinger: https://www.hostinger.com/cp
2. Menu: **Email** > **Gerenciar Email**
3. Selecione o email que vai receber pedidos (ex: `pedidos@seudominio.com.br`)
4. Anote as credenciais:
   - **Email**: pedidos@seudominio.com.br
   - **Senha**: sua_senha_hostinger
   - **Host IMAP**: imap.hostinger.com
   - **Porta**: 993
   - **Criptografia**: SSL/TLS

### Passo 2: Configurar no n8n

1. Abra seu workflow v4.4 no n8n
2. Clique no nó **Email Trigger (IMAP)**
3. Clique em **+ Credentials** ou selecione credencial existente
4. Preencha:
   ```
   User: pedidos@seudominio.com.br
   Password: sua_senha_hostinger
   Host: imap.hostinger.com
   Port: 993
   SSL/TLS: Ativado
   ```
5. Clique **Test Connection**
6. Se OK, salve as credenciais

### Configuração do Email Trigger

No nó Email Trigger (IMAP):
- **Mailbox**: INBOX
- **Format**: Simple
- **Mark as Read**: Ativado (✓)
- **Conditions**: Deixe vazio (recebe todos emails)

---

## Opção 2: Usar Gmail

### Passo 1: Ativar App Passwords no Gmail

1. Acesse https://myaccount.google.com/security
2. Menu esquerda: **Autenticação de 2 fatores** > Ativar (se já não estiver)
3. Volte para Security > **Senhas de app**
4. Selecione: App = Mail, Device = Windows Computer
5. Gere e copie a senha de app (será algo como: `abcd efgh ijkl mnop`)

### Passo 2: Configurar no n8n

1. Clique no nó **Email Trigger (IMAP)**
2. Clique em **+ Credentials**
3. Preencha:
   ```
   User: seu_email@gmail.com
   Password: abcd efgh ijkl mnop (senha de app gerada)
   Host: imap.gmail.com
   Port: 993
   SSL/TLS: Ativado
   ```
4. Clique **Test Connection**
5. Se OK, salve

---

## 📄 Campos Capturados Automaticamente

Quando um email com PDF chegar, o workflow captura:

| Campo | Extraido de | Exemplo |
|-------|-------------|----------|
| `email_vendedor` | Email headers.from | joao@taschibra.com.br |
| `nome_vendedor` | Pode ser extraido do LDAP (futuro) | João Silva |
| `arquivo_pdf` | Anexo do email | pedido_001.pdf |
| `data_recebimento` | Timestamp do email | 2025-11-12 01:30 |

---

## 🤫 Teste de Funcionalidade

1. **Ative o workflow**: Clique no botão toggle "Active" (verde)
2. **Envie um email de teste**:
   - Para: pedidos@seudominio.com.br
   - Anexe um PDF com dados de pedido
   - Assunto: "Pedido novo"
3. **Monitore a execução**:
   - Veja tab **Executions** no n8n
   - Procure por logs verde (sucesso) ou vermelho (erro)
4. **Verifique Supabase**:
   - Acesse seu banco Supabase
   - Tabela `pedidos` deve ter novo registro com `email_vendedor`
   - Tabela `pedido_itens` deve ter items processados

---

## ⚠️ Troubleshooting

### Erro: "Connection refused"
- Verifique Host e Port
- Hostinger: imap.hostinger.com:993
- Gmail: imap.gmail.com:993

### Erro: "Invalid credentials"
- Para Gmail: Verifique se gerou **senha de app** (não a senha normal)
- Para Hostinger: Verifique email e senha corretos
- Teste em Hostinger webmail primeiro

### Workflow não dispara
- Verifique botão **Active** está VERDE
- Aguarde 1-2 minutos (polling IMAP)
- Verifique em **Executions** se há erros

### PDF não sendo lido
- Verifique se anexo está chegando (tab Attachments no debug)
- Verifique formato do PDF (deve ser válido)
- Aumente timeout no workflow settings

---

## 🔍 Monitoramento Contínuo

### Ativar logs estruturados

No tab **Settings** do workflow:
- **Save Manual Executions**: ✓ Ativado
- **Error Handler**: "Save" (para debug de erros)
- **Timeout**: 3600s (1 hora)

Isso cria um registro em **processamento_logs** toda vez que um pedido é recebido.

---

## 🦋 Próximos Passos

1. [x] Configurar Email Trigger
2. [ ] Extrair nome do vendedor automaticamente (via LDAP ou tabela local)
3. [ ] Adicionar suporte para múltiplas caixas de entrada
4. [ ] Criar webhook para integração com sistema de vendas

---

**Data de Criação**: 12 de Novembro de 2025
**Versão do Workflow**: v4.4
