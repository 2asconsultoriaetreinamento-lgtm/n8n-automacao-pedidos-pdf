# Guia de Deployment - n8n Automacao Pedidos PDF

Este documento descreve os passos necessarios para fazer deploy e executar a automacao de processamento de pedidos em PDF.

## Pre-requisitos

- Conta ativa no Supabase (https://supabase.com)
- Instancia n8n em execucao (auto-hosted ou n8n.cloud)
- Acesso a API do Supabase
- Node.js 14+ (para validacao local de regex)

## Passo 1: Configurar Banco de Dados Supabase

### 1.1 Criar Projeto Supabase

1. Acesse https://supabase.com e crie uma nova conta ou faça login
2. Crie um novo projeto
3. Anote as credenciais:
   - Project URL (SUPABASE_URL)
   - Anon Key (SUPABASE_KEY)
   - Service Role Key (SUPABASE_SECRET_KEY)

### 1.2 Executar Script de Setup

1. Acesse o SQL Editor do seu projeto Supabase
2. Copie o conteudo do arquivo `scripts/setup-supabase.sql`
3. Cole e execute no editor SQL
4. Verifique se as tabelas foram criadas:
   - pedidos.pedidos
   - pedidos.itens_pedido
   - pedidos.logs_processamento

### 1.3 Configurar Row Level Security (RLS)

1. Vá para Authentication > Policies
2. Configure politicas para permitir acesso da aplicacao n8n:
   ```
   - Enable RLS para todas as tabelas
   - Criar politica de INSERT/SELECT/UPDATE para service role
   ```

## Passo 2: Configurar n8n

### 2.1 Importar Workflow

1. Acesse sua instancia n8n
2. Crie um novo workflow ou importe `workflows/pedidos-pdf-supabase.json`
3. Configure as variaveis de ambiente:

```bash
SUPABASE_URL=sua_url_do_projeto
SUPABASE_KEY=sua_anon_key
SUPABASE_SECRET_KEY=sua_service_role_key
```

### 2.2 Configurar Credenciais HTTP

1. No n8n, vá para Credentials
2. Crie uma nova credencial HTTP com:
   - Authorization: Bearer {SUPABASE_SECRET_KEY}
   - Headers: Content-Type: application/json

### 2.3 Testar Conexao

1. Execute o workflow com um arquivo PDF de teste
2. Verifique os logs em pedidos.logs_processamento
3. Confirme se pedidos foram inseridos em pedidos.pedidos

## Passo 3: Validar Parsing

### 3.1 Teste Local de Regex

```bash
cd scripts
node validate-parsing.js
```

Este script testa os padroes regex usados no n8n.

### 3.2 Resultados Esperados

O script deve extrair com sucesso:
- Numero do pedido
- Data do pedido
- Nome do cliente
- Email do cliente
- Valor total
- Itens do pedido

## Passo 4: Agendar Execucao

### 4.1 Configurar Scheduler n8n

1. No workflow, clique no node "Scheduler (Cron)"
2. Configure a frequencia desejada:
   - Diaria: `0 9 * * *` (09:00 toda manhã)
   - Horaria: `0 * * * *` (a cada hora)
   - Personalizavel conforme necessidade

### 4.2 Ativar Workflow

1. Clique em "Activate" para ativar o workflow
2. Monitore os logs em Executions

## Passo 5: Monitoramento e Manutencao

### 5.1 Verificar Logs

```sql
SELECT * FROM pedidos.logs_processamento 
ORDER BY data_evento DESC LIMIT 50;
```

### 5.2 Validar Duplicatas

O workflow valida automaticamente para evitar duplicidade usando:
```sql
SELECT COUNT(*) FROM pedidos.pedidos 
WHERE numero_pedido = $1;
```

### 5.3 Tratamento de Erros

- Erros sao salvos em `logs_processamento` com tipo_evento = 'erro'
- Configurar alertas no n8n para notificar em caso de falhas
- Future: Integrar com Email/Telegram para notificacoes

## Troubleshooting

### Problema: Pedidos nao estao sendo inseridos

1. Verifique as credenciais Supabase no n8n
2. Valide se as variaveis de ambiente estao carregadas
3. Verifique os logs em pedidos.logs_processamento
4. Confirme se o PDF tem layout esperado

### Problema: Regex nao faz match com dados

1. Execute o script de validacao: `node scripts/validate-parsing.js`
2. Adapte os padroes regex conforme necessario
3. Atualize o node "ParseData" no workflow

### Problema: RLS bloqueando insercoes

1. Verifique as politicas de RLS no Supabase
2. Confirme que a credencial esta usando service_role key
3. Teste diretamente no SQL Editor com privilegios elevados

## Proximas Etapas (Sprint 2+)

- [ ] Implementar logging detalhado
- [ ] Adicionar autenticacao adicional
- [ ] Integrar com Email para notificacoes
- [ ] Integrar com Telegram para alertas
- [ ] Criar dashboard de monitoramento
- [ ] Implementar testes automatizados
- [ ] Documentar tratamento de erros customizado

## Suporte e Documentacao

- [Documentacao Supabase](https://supabase.com/docs)
- [Documentacao n8n](https://docs.n8n.io/)
- Consulte o README.md principal para mais informacoes
