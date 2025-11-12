# Variáveis de Ambiente - n8n Automação Pedidos PDF v4.4

## Introdução

Este documento descreve todas as variáveis de ambiente necessárias para executar a automação n8n de PDFs de pedidos com Supabase e Email Trigger (IMAP).

**Versão**: 4.4.0  
**Data**: 19/12/2025  
**Status**: ✅ Requer configuração manual em n8n

## 📋 Variáveis Obrigatórias

Todas as 3 variáveis abaixo são **OBRIGATÓRIAS** para o funcionamento do workflow.

### 1. SUPABASE_URL

**Descrição**: URL do projeto Supabase

**Formato**:
```
SUPABASE_URL=https://seu-projeto-uid.supabase.co
```

**Como obter**:
1. Acesse https://supabase.com/dashboard
2. Clique em seu projeto
3. Vá para **Settings** (engrenagem)
4. Clique em **API**
5. Copie o valor em **Project URL**

---

### 2. SUPABASE_KEY

**Descrição**: Chave pública (anon) para autenticação REST

**Tipo**: Chave API Pública (anon key)

**Como obter**:
1. Supabase Dashboard > Projeto > **Settings** > **API**
2. Copie o valor em **anon public**
3. Este é um JWT token longo

**Uso no workflow**:
- Headers HTTP: `Authorization: Bearer $env.SUPABASE_KEY`
- Para leitura de dados

---

### 3. SUPABASE_SECRET_KEY

**Descrição**: Chave secreta (service_role) para operações administrativas

**Tipo**: Chave API Secreta (service_role key)

**Como obter**:
1. Supabase Dashboard > Projeto > **Settings** > **API**
2. Copie o valor em **service_role secret**
3. Este é um JWT token longo, diferente da anon key

**Segurança - CRÍTICO**:
- ⚠️  NUNCA expor em repositórios públicos
- ⚠️  NUNCA compartilhar em emails
- ⚠️  NUNCA commitar em git
- ✅ Usar APENAS em n8n (ambiente seguro)

---

## ✨ Como Configurar em n8n

### Passo 1: Acessar Ambiente

1. **n8n Cloud**:
   - Dashboard → clique em seu nome
   - → **Settings** → **Environment Variables**

2. **n8n Self-hosted**:
   - Administração → **Environment**

### Passo 2: Adicionar Variáveis

Clique em **+ Add Variable** e preencha:

| Nome | Tipo |
|------|------|
| SUPABASE_URL | String |
| SUPABASE_KEY | Secret |
| SUPABASE_SECRET_KEY | Secret |

### Passo 3: Testar Conexão

1. Vá para workflow v4.4
2. Abra um nó HTTP
3. Você deve ver `$env.SUPABASE_URL` no autocomplete
4. Clique em **Test**
5. Deve receber resposta 200

---

## 📝 Exemplo de Uso no Workflow

### CheckDuplicate (HTTP GET)

```
URL: $env.SUPABASE_URL/rest/v1/pedidos?numero_pedido=eq.12345

Headers:
- Authorization: Bearer $env.SUPABASE_KEY
- Content-Type: application/json
```

### InsertPedido (HTTP POST)

```
URL: $env.SUPABASE_URL/rest/v1/pedidos

Headers:
- Authorization: Bearer $env.SUPABASE_SECRET_KEY
- Content-Type: application/json

Body:
{
  "numero_pedido": "123456789",
  "email_vendedor": "vendedor@empresa.com.br"
}
```

---

## ⚠️  Troubleshooting

### Erro: "Variable not found"

**Causa**: Variável não está configurada

**Solução**:
1. Verifique Settings > Environment Variables
2. Rode workflow novamente

### Erro: "401 Unauthorized"

**Causa**: Chave inválida

**Solução**:
1. Regenere a chave em Supabase
2. Copie COMPLETA (sem espaços)
3. Atualize em n8n

### Erro: "403 Forbidden"

**Causa**: RLS policy não permite

**Solução**:
1. Use `SUPABASE_SECRET_KEY` para escrita
2. Verifique RLS policies

---

**Última atualização**: 19/12/2025  
**Versão**: 4.4.0
