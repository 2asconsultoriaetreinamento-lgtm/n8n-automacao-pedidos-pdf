# Implementação UPSERT - Versão v4.6

**Status**: 🚀 Funcionalidade de Atualização de Pedidos Duplicados

**Data**: 12 de Novembro de 2025

**Versão**: v4.6.0 (Gmail Trigger + OAuth2 + UPSERT)

---

## Resumo Executivo

Esta versão (v4.6) adiciona funcionalidade **UPSERT** ao workflow v4.5. Em vez de rejeitar pedidos duplicados, o sistema agora **atualiza os dados do pedido existente** com as informações mais recentes do PDF recebido.

### Benefícios:
- ✅ Dados sempre atualizados (reflete última versão do pedido)
- ✅ Sem perda de dados históricos
- ✅ Melhor conformidade com alterações de cliente
- ✅ Reduz necessidade de limpeza manual

---

## Preparação do Supabase

### 1. Criar Constraint UNIQUE em numero_pedido

Antes de implementar UPSERT, execute este SQL no SQL Editor do Supabase:

```sql
-- Criar índice UNIQUE para performance
CREATE UNIQUE INDEX IF NOT EXISTS uq_numero_pedido 
ON pedidos(numero_pedido);

-- Adicionar constraint (opcional, se ainda não existir)
ALTER TABLE pedidos
ADD CONSTRAINT uq_numero_pedido UNIQUE(numero_pedido);
```

### 2. Preparar Triggers de Timestamp (Opcional mas Recomendado)

Se você quer rastrear quando os dados foram atualizados:

```sql
-- Criar coluna updated_at se não existir
ALTER TABLE pedidos
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT NOW();

-- Criar trigger para atualizar automaticamente
CREATE OR REPLACE FUNCTION update_pedidos_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_pedidos_timestamp ON pedidos;

CREATE TRIGGER trigger_update_pedidos_timestamp
BEFORE UPDATE ON pedidos
FOR EACH ROW
EXECUTE FUNCTION update_pedidos_timestamp();
```

### 3. Validar Estrutura de Tabelas

Verifique se suas tabelas têm a seguinte estrutura:

**Tabela: pedidos**
- `id` (serial, PRIMARY KEY)
- `numero_pedido` (text, UNIQUE) ← **IMPORTANTE**
- `data_emissao` (date)
- `cliente_nome` (text)
- `cliente_cnpj` (text)
- `cidade` (text)
- `uf` (text)
- `valor_total` (numeric)
- `vendedor` (text)
- `canal` (text)
- `tipo` (text)
- `email_vendedor` (text)
- `created_at` (timestamp)
- `updated_at` (timestamp) ← **NOVO (opcional)**

**Tabela: itens_pedido**
- `id` (serial, PRIMARY KEY)
- `pedido_id` (int, FOREIGN KEY → pedidos.id)
- `produto` (text)
- `codigo` (text)
- `unidade` (text)
- `quantidade` (integer)
- `valor_unitario` (numeric)
- `valor_total` (numeric)
- `ncm` (text)
- `ipi` (numeric)
- `tipo_item` (text)
- `created_at` (timestamp)

---

## Modificações no Fluxo n8n

### Arquitetura UPSERT (Novo Fluxo)

```
Gmail Trigger
  ↓
Read PDF (Binary)
  ↓
Parse Data (JavaScript Code)
  ↓
HTTP GET: Verificar Duplicidade
  ↓
IF: Duplicado?
  ├─ SIM (Ramo UPDATE):
  │  ├─ HTTP PUT: Atualizar Pedido
  │  ├─ HTTP DELETE: Remover Itens Antigos
  │  ├─ HTTP POST: Inserir Itens Novos
  │  └─ HTTP POST: Log "Atualizado"
  │
  └─ NÃO (Ramo INSERT):
     ├─ HTTP POST: Inserir Pedido
     ├─ HTTP POST: Inserir Itens
     └─ HTTP POST: Log "Novo"
  ↓
Loop Over Items
  ↓
HTTP POST: Log Retornado
```

### Passo-a-Passo de Modificação

#### **PASSO 1: Modificar nó IF**

1. Abra o workflow v4.5 no n8n
2. Clique no nó **IF - Não Duplicado?**
3. **Deixe a condição IGUAL** (não duplicado = true)
4. Quando o workflow for clonado, um ramo será para UPDATE (false) e outro para INSERT (true)

#### **PASSO 2: Adicionar HTTP PUT (Ramo UPDATE)**

**Novo nó**: HTTP Request

```
Nome: HTTP PUT - Atualizar Pedido

Configurações:
- Method: PUT
- URL: https://seu-projeto.supabase.co/rest/v1/pedidos?numero_pedido=eq.{{ $json.numero_pedido }}
- Authentication: Bearer Token
- Bearer Token: {{ $env.SUPABASE_ANON_KEY }}

Headers:
- Content-Type: application/json
- apikey: {{ $env.SUPABASE_ANON_KEY }}
- Prefer: return=representation

Body:
{
  "valor_total": {{ $json.valor_total }},
  "cliente_nome": "{{ $json.cliente_nome }}",
  "cliente_cnpj": "{{ $json.cliente_cnpj }}",
  "cidade": "{{ $json.cidade }}",
  "uf": "{{ $json.uf }}",
  "vendedor": "{{ $json.vendedor }}",
  "canal": "{{ $json.canal }}",
  "tipo": "{{ $json.tipo }}",
  "email_vendedor": "{{ $json.email_vendedor }}"
}
```

#### **PASSO 3: Adicionar HTTP DELETE (Ramo UPDATE)**

**Novo nó**: HTTP Request

```
Nome: HTTP DELETE - Remover Itens Antigos

Configurações:
- Method: DELETE
- URL: https://seu-projeto.supabase.co/rest/v1/itens_pedido?pedido_id=eq.{{ $json.pedido_id }}
- Authentication: Bearer Token
- Bearer Token: {{ $env.SUPABASE_ANON_KEY }}

Headers:
- apikey: {{ $env.SUPABASE_ANON_KEY }}
```

#### **PASSO 4: Adicionar Log "Atualizado" (Ramo UPDATE)**

**Novo nó**: HTTP POST - Log Atualização

```
Nome: HTTP POST - Log Atualizado

Configurações:
- Method: POST
- URL: https://seu-projeto.supabase.co/rest/v1/logs_importacao
- Body:
{
  "numero_pedido": "{{ $json.numero_pedido }}",
  "status": "atualizado",
  "timestamp": "{{ now }}",
  "detalhes": "Pedido atualizado com novos dados do PDF"
}
```

#### **PASSO 5: Reconfigurar Loop**

O loop "Loop Over Items" deve:
1. Receber dados do ramo INSERT (novo pedido_id)
2. **OU** receber dados do ramo UPDATE (pedido_id existente)
3. Inserir itens normalmente em ambos os casos

**Conexão**: Ambos os ramos (INSERT e UPDATE) devem conectar ao Loop Over Items

---

## Testes de Validação

### Teste 1: Novo Pedido (INSERT)
```
1. Enviar email com PDF de novo pedido (numero_pedido = ABC123)
2. Esperado: Pedido inserido em pedidos
3. Esperado: Itens inseridos em itens_pedido
4. Esperado: Log "novo" registrado
5. Verificar: SELECT * FROM pedidos WHERE numero_pedido = 'ABC123'
```

### Teste 2: Pedido Duplicado (UPDATE)
```
1. Enviar email com PDF do MESMO pedido (numero_pedido = ABC123)
2. Esperado: Pedido ATUALIZADO (não inserido duplicado)
3. Esperado: Itens antigos removidos
4. Esperado: Itens novos inseridos
5. Esperado: Log "atualizado" registrado
6. Verificar: SELECT * FROM itens_pedido WHERE pedido_id = X (deve ter dados novos)
```

### Teste 3: Alteração de Valores
```
1. Enviar primeiro PDF com valor_total = 1000
2. Enviar segundo PDF MESMO pedido, valor_total = 1500
3. Esperado: valor_total atualizado de 1000 → 1500
4. Verificar: SELECT valor_total FROM pedidos WHERE numero_pedido = 'ABC123'
```

---

## Deployment

### Fase A: Teste em Ambiente DEV (Recomendado)

1. **Backup do v4.5**: Exporte workflow atual como `pedidos-pdf-supabase-v4.5-backup.json`
2. **Criar workflow v4.6**: Clone o workflow e nomeie como `pedidos-pdf-supabase-v4.6-UPSERT`
3. **Implementar mudanças** conforme passo-a-passo acima
4. **Testar** com 5-10 pedidos duplicados
5. **Validar dados** no Supabase

### Fase B: Validação

1. Executar testes 1-3 acima ✅
2. Verificar logs de execução no n8n
3. Revisar dados no Supabase
4. Confirmar sem erros HTTP

### Fase C: Deploy em Produção

1. **Backup**: Exporte v4.5 como safety backup
2. **Ativar v4.6**: Configure v4.6 como workflow ativo
3. **Desativar v4.5**: Desative workflow antigo
4. **Monitorar**: Acompanhe as primeiras 50 execuções
5. **Rollback plan**: Se erros, reativar v4.5 imediatamente

---

## Rollback (Se Necessário)

Se encontrar problemas:

```bash
# 1. Desativar v4.6
# No n8n: Clique em "Inactive" no workflow v4.6

# 2. Ativar v4.5
# No n8n: Clique em "Active" no workflow v4.5

# 3. Reverter dados (SQL)
# Se necessário limpar dados incorretos:
DELETE FROM itens_pedido WHERE pedido_id IN (
  SELECT id FROM pedidos WHERE updated_at > NOW() - INTERVAL '1 hour'
);

DELETE FROM pedidos WHERE updated_at > NOW() - INTERVAL '1 hour';
```

---

## Variáveis de Ambiente Necessárias

Verifique se estão configuradas no n8n:

```
SUPABASE_URL = https://seu-projeto.supabase.co
SUPABASE_ANON_KEY = your-anon-key-here
SUPABASE_SECRET_KEY = your-secret-key-here (se necessário)
```

---

## Próximos Passos

1. ✅ Preparar Supabase (SQL acima)
2. ✅ Implementar mudanças no n8n (passos 1-5)
3. ✅ Testar em DEV
4. ✅ Validar dados
5. ✅ Deploy em Produção

---

## Suporte e Troubleshooting

**Problema**: "Constraint violation: número_pedido duplicado"
**Solução**: Execute SQL para criar constraint UNIQUE acima

**Problema**: "Itens antigos não foram removidos"
**Solução**: Verifique se HTTP DELETE executou com sucesso (status 204)

**Problema**: "Atualização não refletiu no banco"
**Solução**: Verifique se HTTP PUT retornou status 200 e dados corretos

---

**Versão**: v4.6.0
**Última Atualização**: 12 de Novembro de 2025
**Status**: ✅ Pronto para Implementação
