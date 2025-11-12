# Setup SQL UPSERT - Versão v4.6

**Arquivo**: Scripts SQL para preparar o banco Supabase para UPSERT

**Data**: 12 de Novembro de 2025

---

## 📋 Índice de Scripts

1. [Criar Constraint UNIQUE](#1-criar-constraint-unique)
2. [Criar Coluna updated_at](#2-criar-coluna-updated_at)
3. [Criar Trigger de Timestamp](#3-criar-trigger-de-timestamp)
4. [Validar Estrutura](#4-validar-estrutura)
5. [Scripts de Limpeza](#5-scripts-de-limpeza)

---

## 1. Criar Constraint UNIQUE

Execute este script PRIMEIRO no SQL Editor do Supabase:

```sql
-- Criar índice UNIQUE para performance
CREATE UNIQUE INDEX IF NOT EXISTS idx_uq_numero_pedido 
ON pedidos(numero_pedido);

-- Adicionar constraint (vai usar o índice acima)
ALTER TABLE pedidos
ADD CONSTRAINT uq_numero_pedido UNIQUE(numero_pedido);
```

**O que faz**: Garante que cada `numero_pedido` seja único na tabela `pedidos`

**Por quê importante**: Permite que n8n identifique se um pedido já existe e precise ser atualizado

---

## 2. Criar Coluna updated_at

Se você quer rastrear Última atualização (RECOMENDADO):

```sql
-- Adicionar coluna updated_at com timestamp padrão
ALTER TABLE pedidos
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT NOW();

-- Criar índice em updated_at para queries mais rápidas
CREATE INDEX IF NOT EXISTS idx_pedidos_updated_at 
ON pedidos(updated_at);
```

**O que faz**: Adiciona rastreamento automático de quando cada pedido foi criado/atualizado

**Por quê útil**: Permite rollback fácil (deletar por timestamp) se algo der errado

---

## 3. Criar Trigger de Timestamp

Para atualizar automaticamente `updated_at` quando o pedido mudar:

```sql
-- Criar função que atualiza timestamp
CREATE OR REPLACE FUNCTION update_pedidos_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Remover trigger antigo se existir
DROP TRIGGER IF EXISTS trg_update_pedidos_timestamp ON pedidos;

-- Criar novo trigger
CREATE TRIGGER trg_update_pedidos_timestamp
BEFORE UPDATE ON pedidos
FOR EACH ROW
EXECUTE FUNCTION update_pedidos_timestamp();
```

**O que faz**: Toda vez que um pedido é atualizado, o `updated_at` é automaticamente ajustado

**IMPORTANTE**: Isso é do lado banco, independent do n8n

---

## 4. Validar Estrutura

Antes de ativar v4.6, execute para validar:

```sql
-- Verificar se constraint UNIQUE existe
SELECT *
FROM pg_constraints
WHERE table_name = 'pedidos' 
AND constraint_type = 'UNIQUE';

-- Resultado esperado: Uma linha com uq_numero_pedido

-- Verificar se coluna updated_at existe
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'pedidos'
AND column_name = 'updated_at';

-- Resultado esperado: Uma linha com timestamp

-- Verificar se trigger foi criado
SELECT *
FROM pg_trigger
WHERE tgname = 'trg_update_pedidos_timestamp';

-- Resultado esperado: Uma linha com o trigger
```

---

## 5. Scripts de Limpeza

### 5.1 Remover Duplicatas Manualmente

Se houver duplicatas de `numero_pedido`:

```sql
-- Ver duplicatas
SELECT numero_pedido, COUNT(*) as total
FROM pedidos
GROUP BY numero_pedido
HAVING COUNT(*) > 1;

-- Deletar cópias (mantendo a mais recente)
WITH duplicates AS (
  SELECT id,
    ROW_NUMBER() OVER (PARTITION BY numero_pedido ORDER BY created_at DESC) as rn
  FROM pedidos
)
DELETE FROM pedidos
WHERE id IN (
  SELECT id FROM duplicates WHERE rn > 1
);
```

### 5.2 Limpar Itens Órfãos

Se houver itens_pedido sem pedido correspondente:

```sql
-- Ver itens Órfãos
SELECT ip.*
FROM itens_pedido ip
LEFT JOIN pedidos p ON ip.pedido_id = p.id
WHERE p.id IS NULL;

-- Deletar itens Órfãos
DELETE FROM itens_pedido
WHERE pedido_id NOT IN (SELECT id FROM pedidos);
```

### 5.3 Remover Updates Recentes

Se precisar reverter atualizações dos últimos X minutos:

```sql
-- Ver o que seria deletado
SELECT *
FROM pedidos
WHERE updated_at > NOW() - INTERVAL '30 minutes';

-- Deletar (CUIDADO!)
DELETE FROM pedidos
WHERE updated_at > NOW() - INTERVAL '30 minutes';
```

---

## 🔱 Ordem de Execução

**IMPORTANTE**: Execute os scripts nesta ordem:

1. ✅ Script 1 (Constraint UNIQUE)
2. ✅ Script 2 (Coluna updated_at)
3. ✅ Script 3 (Trigger)
4. ✅ Script 4 (Validação)
5. Somente depois: Deploy v4.6 no n8n

---

## 🔍 Verificação Pós-Deploy

Após ativar v4.6, execute:

```sql
-- Contar pedidos por status
SELECT COUNT(*) as total_pedidos
FROM pedidos;

-- Ver pedidos atualizados (nos últimos 10 minutos)
SELECT id, numero_pedido, created_at, updated_at
FROM pedidos
WHERE updated_at > NOW() - INTERVAL '10 minutes'
ORDER BY updated_at DESC;

-- Contar itens por pedido (média)
SELECT AVG(item_count) as media_itens
FROM (
  SELECT pedido_id, COUNT(*) as item_count
  FROM itens_pedido
  GROUP BY pedido_id
) subquery;
```

---

## … Troubleshooting

### "ERROR: constraint "uq_numero_pedido" already exists"

```sql
-- Se o constraint já existe, pulando:
-- Não é erro, apenas significa que já estava lá

-- Se quiser remover e recriar:
ALTER TABLE pedidos DROP CONSTRAINT IF EXISTS uq_numero_pedido;
DROP INDEX IF EXISTS idx_uq_numero_pedido;
-- Então execute os scripts acima novamente
```

### "ERROR: relation does not exist"

Verifique se as tabelas `pedidos` e `itens_pedido` existem:

```sql
-- Listar todas as tabelas
\dt

-- Ou via query:
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';
```

### "Dados não estão sendo atualizados"

Verifique se o trigger está ativo:

```sql
-- Listar triggers
SELECT *
FROM pg_trigger
WHERE tgname LIKE 'trg_%';

-- Verificar se está habilitado
SELECT tgenabled FROM pg_trigger WHERE tgname = 'trg_update_pedidos_timestamp';
-- Resultado: 'O' = ativo, 'D' = desativo
```

---

## 📄 Documentação Relacionada

- [UPSERT_v4.6_IMPLEMENTACAO.md](./UPSERT_v4.6_IMPLEMENTACAO.md) - Guia completo de implementação
- [IMPLEMENTACAO_v4.5_PASSO_A_PASSO.md](./IMPLEMENTACAO_v4.5_PASSO_A_PASSO.md) - Setup v4.5 (base)

---

**Versão**: v4.6.0
**Última Atualização**: 12 de Novembro de 2025
**Status**: ✅ Pronto para Execução
