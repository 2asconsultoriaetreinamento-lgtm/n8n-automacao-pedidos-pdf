# Implementação v4.5 - Guia Completo (Passo-a-Passo)

## Versão: 4.5.0 (Gmail Trigger - OAuth2)

**Status**: ✅ Recomendado para Produção

Este documento fornece um guia completo e detalhado para implementar a versão v4.5 do workflow de automação de pedidos PDF com n8n usando Gmail Trigger.

---

## Š Tabela de Conteúdo

1. [Pré-requisitos](#pr%C3%A9-requisitos)
2. [Configuração do Gmail](#configura%C3%A7%C3%A3o-do-gmail)
3. [Configuração do n8n](#configura%C3%A7%C3%A3o-do-n8n)
4. [Importação do Workflow](#importa%C3%A7%C3%A3o-do-workflow)
5. [Configuração do Banco de Dados](#configura%C3%A7%C3%A3o-do-banco-de-dados)
6. [Verificação e Testes](#verifica%C3%A7%C3%A3o-e-testes)
7. [Deploy em Produção](#deploy-em-produ%C3%A7%C3%A3o)

---

## Pré-requisitos

### 1. Conta Google/Gmail
- [ ] Conta Gmail ativa
- [ ] Permissões de administrador (para criar labels se necessário)

### 2. Instalação n8n
- [ ] n8n cloud OU self-hosted (localhost)
- [ ] URL de acesso acessível
- [ ] Versão recomendada: 1.0+

### 3. Banco de Dados Supabase
- [ ] Projeto Supabase ativo
- [ ] Tabelas criadas (ver script SQL)
- [ ] Token/API key disponível
- [ ] URL da API disponível

### 4. Arquivos do Repositório
- [ ] Workflow JSON: `pedidos-pdf-supabase-v4.5.json`
- [ ] Documentação: `NOTA_CORRECCAO_LOOP_v4.5.md`
- [ ] Variáveis: `VARIAVEIS_AMBIENTE.md`

---

## Configuração do Gmail

### Passo 1: Ativar API do Gmail

1. Acesse [Google Cloud Console](https://console.cloud.google.com/)
2. Crie um novo projeto (ou selecione existente)
3. Na barra de busca, procure "Gmail API"
4. Clique em "Enable"
5. Aguarde ativação (1-2 minutos)

### Passo 2: Criar Credenciais OAuth2

1. No Google Cloud Console, vá a "Credenciais"
2. Clique "Criar credenciais" > "ID do cliente OAuth"
3. Selecione "Aplicativo da web" como tipo
4. Na seção "URIs autorizados de redirecionamento", adicione:
   ```
   http://localhost:5678/rest/oauth2-credential/callback
   https://seu-n8n-instance.com/rest/oauth2-credential/callback
   ```
5. Clique "Criar"
6. Copie:
   - Client ID
   - Client Secret
7. Guarde em lugar seguro

### Passo 3: Criar Label no Gmail (Opcional)

1. Acesse gmail.com
2. Na barra lateral esquerda, clique em "Criar rótulo"
3. Nome sugerido: "PDF Pedidos" ou "Automacao"
4. Clique "Criar"

---

## Configuração do n8n

### Passo 4: Conectar Gmail no n8n

1. No editor n8n, clique em "Add node"
2. Procure por "Gmail"
3. Selecione "Gmail Trigger"
4. No painel de configuração:
   - Clique em "Create new credential"
   - Selecione "Gmail API (OAuth2)"
   - Preencha Client ID e Client Secret (do passo anterior)
5. Clique "Connect"
6. Uma janela de autenticação do Google será aberta
7. Faça login com sua conta Gmail
8. Clique "Allow" para dar permissões
9. Volte para n8n, o acesso será confirmado

### Passo 5: Configurar Parametros do Trigger

No nó Gmail Trigger, preencha:

- **Watch**: "New message on a label"
- **Label**: Selecione "Inbox" (ou seu label customizado)
- **Poll interval**: 30 (segundos)
- **Additional fields**: (deixar em branco)

---

## Importação do Workflow

### Passo 6: Importar Workflow JSON

1. Faça download: `pedidos-pdf-supabase-v4.5.json`
2. No n8n, clique no menu (3 pontos) no topo direito
3. Selecione "Import from file"
4. Escolha o arquivo `pedidos-pdf-supabase-v4.5.json`
5. Aguarde importáção (15-30 segundos)
6. O workflow será carregado com todos os nós

### Passo 7: Verificar Estrutura do Workflow

Verífique se todos os nós estão presentes:

- [ ] Gmail Trigger (inicio)
- [ ] Read Binary File (PDF)
- [ ] Parse Data (Code - extracao JSON)
- [ ] HTTP GET - Verificar Duplicidade
- [ ] IF - Não Duplicado?
- [ ] HTTP POST - Inserir Pedido
- [ ] **Loop Over Items** (Split in Batches)
- [ ] HTTP POST - Inserir Itens
- [ ] HTTP POST - Log Sucesso
- [ ] HTTP POST - Log Duplicidade

**Importante**: Verificar que o **Loop Over Items** está corrigido. Ver: [NOTA_CORRECCAO_LOOP_v4.5.md](./NOTA_CORRECCAO_LOOP_v4.5.md)

---

## Configuração do Banco de Dados

### Passo 8: Configurar Credenciais Supabase

Para cada nó HTTP no workflow:

1. Clique no nó HTTP
2. No painel direito, configure:
   - **URL**: `https://seu-projeto.supabase.co/rest/v1/...`
   - **Authentication**: Bearer Token
   - **Bearer**: Seu SUPABASE_ANON_KEY
   - **Headers**:
     - `apikey`: seu SUPABASE_ANON_KEY
     - `Content-Type`: `application/json`

### Passo 9: Verificar Variáveis de Ambiente

Consulte [VARIAVEIS_AMBIENTE.md](./VARIAVEIS_AMBIENTE.md) para:

- SUPABASE_URL
- SUPABASE_ANON_KEY
- Email_Vendedor (capturado automaticamente do Gmail)

---

## Verificação e Testes

### Passo 10: Teste Inicial

1. Salve o workflow (Ctrl+S)
2. Clique em "Execute workflow" (botão vermelho)
3. Envie um e-mail de teste para seu Gmail com um PDF
4. Verifique se o workflow acionou:
   - Logs do n8n mostram execução
   - PDF foi processado
   - Dados foram inseridos no banco

### Passo 11: Validar Dados

Verifique no Supabase:

```sql
SELECT * FROM pedidos ORDER BY data_criacao DESC LIMIT 5;
SELECT * FROM itens_pedido ORDER BY id DESC LIMIT 5;
```

---

## Deploy em Produção

### Passo 12: Habilitar Workflow

1. No n8n, clique em "Inactive" (topo esquerdo)
2. Mude para "Active"
3. O workflow agora responderá a todos os emails

### Passo 13: Monitoramento

- Verifique execuções regularmente
- Revise logs em "Executions"
- Monitore taxa de erro
- Valide dados no banco

---

## Conclusão

V4.5 está agora em produção e processando pedidos PDF automaticamente!

Para suporte, consulte:
- NOTA_CORRECCAO_LOOP_v4.5.md
- GUIA_RAPIDO_v4.5.md
- GMAIL_TRIGGER_RECOMENDACAO.md
