# Supabase v4.6 - Configuração de Produção

## 📋 Resumo Executivo

Este documento contém as informações de configuração e credenciais do projeto Supabase criado para suportar a automação de pedidos n8n com suporte para operações UPSERT v4.6.

**Projeto**: `n8n-automacao-pedidos`
**Ambiente**: Produção
**Data de Criação**: 12 de Novembro de 2025
**Status**: ✅ Ativo e Testado

---

## 🔐 Credenciais Supabase

### URL do Projeto
```
https://wiwqaxyouvtauhwdkkpd.supabase.co
```

### Chaves API

**SUPABASE_URL**:
```
https://wiwqaxyouvtauhwdkkpd.supabase.co
```

**SUPABASE_ANON_KEY** (Chave Anonima para REST API):
```
eyJhbGc5OTJUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3M5OTJUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3M5OTJUzI1NiIsInR5cCI6IkpXVCJ9...[Veja Supabase Dashboard para chave completa]
```

**Connection String PostgreSQL**:
```
postgresql://postgres:[PASSWORD]@db.wiwqaxyouvtauhwdkkpd.supabase.co:5432/postgres
```

---

## 📊 Estrutura do Banco de Dados

### 1. Tabela: `pedidos`
Tabela principal para armazenar pedidos de vendas.

**Colunas**:
- `id` (BIGSERIAL) - Chave primária
- `numero_pedido` (TEXT) - **UNIQUE** - Identificador do pedido (usado em UPSERT)
- `data_emissao` (DATE) - Data de emissão do pedido
- `cliente_nome` (TEXT) - Nome do cliente
- `cliente_cnpj` (TEXT) - CNPJ do cliente
- `cidade` (TEXT) - Cidade de destino
- `uf` (TEXT) - Unidade federativa
- `valor_total` (NUMERIC) - Valor total do pedido
- `vendedor` (TEXT) - Nome do vendedor
- `canal` (TEXT) - Canal de vendas
- `tipo` (TEXT) - Tipo de pedido
- `email_vendedor` (TEXT) - Email do vendedor
- `created_at` (TIMESTAMP) - Timestamp de criação
- `updated_at` (TIMESTAMP) - Timestamp de atualização

**Índices**:
- `idx_pedidos_numero_pedido` (UNIQUE) - Para UPSERT
- `idx_pedidos_created_at` - Para filtros de data
- `idx_pedidos_cliente` - Para filtros de cliente

**Trigger**: `update_pedidos_updated_at` - Atualiza `updated_at` automaticamente

---

### 2. Tabela: `itens_pedido`
Tabela para armazenar itens/linhas de cada pedido.

**Colunas**:
- `id` (BIGSERIAL) - Chave primária
- `pedido_id` (BIGINT) - Chave estrangeira para `pedidos.id` (ON DELETE CASCADE)
- `produto` (TEXT) - Nome do produto
- `codigo` (TEXT) - Código do produto
- `unidade` (TEXT) - Unidade de medida
- `quantidade` (INTEGER) - Quantidade vendida
- `valor_unitario` (NUMERIC) - Valor unitário
- `valor_total` (NUMERIC) - Valor total do item
- `ncm` (TEXT) - NCM (Nomenclatura Comum do Mercosul)
- `ipi` (NUMERIC) - IPI (Imposto sobre Produtos Industrializados)
- `tipo_item` (TEXT) - Tipo de item
- `created_at` (TIMESTAMP) - Timestamp de criação

**Índices**:
- `idx_itens_pedido_pedido_id` - Para joins com pedidos
- `idx_itens_pedido_codigo` - Para buscas de produtos

---

### 3. Tabela: `logs_importacao`
Tabela para registrar o histórico de importações e processamentos.

**Colunas**:
- `id` (BIGSERIAL) - Chave primária
- `numero_pedido` (TEXT) - Número do pedido
- `status` (TEXT) - Status da importação: 'novo', 'atualizado', 'duplicado', 'erro'
- `timestamp` (TIMESTAMP) - Hora do evento
- `detalhes` (TEXT) - Detalhes adicionais

**Índices**:
- `idx_logs_numero_pedido` - Para filtros por pedido
- `idx_logs_timestamp` - Para filtros por tempo
- `idx_logs_status` - Para filtros por status

---

## 🔒 Row Level Security (RLS)

Todas as 3 tabelas possuem RLS habilitado com políticas permissivas para usuários autenticados:

**Políticas Configuradas**:
- ✅ `SELECT` - Permitido para usuários autenticados
- ✅ `INSERT` - Permitido para usuários autenticados
- ✅ `UPDATE` - Permitido para usuários autenticados
- ✅ `DELETE` - Permitido via Cascade (quando pai é deletado)

---

## 📝 Configuração n8n

Para integrar com n8n, use as seguintes configurações:

### Variáveis de Ambiente
```env
SUPABASE_URL=https://wiwqaxyouvtauhwdkkpd.supabase.co
SUPABASE_ANON_KEY=[cole_chave_aqui]
SUPABASE_SECRET_KEY=[opcional_para_operacoes_admin]
```

### REST API Endpoints
```
GET    /rest/v1/pedidos
GET    /rest/v1/pedidos?numero_pedido=eq.{numero}
POST   /rest/v1/pedidos
PATCH  /rest/v1/pedidos?numero_pedido=eq.{numero}
POST   /rest/v1/itens_pedido
POST   /rest/v1/logs_importacao
```

---

## ✅ Validação da Estrutura

Todas as tabelas foram validadas e estão operacionais:

- ✅ `pedidos` - Criada com sucesso
- ✅ `itens_pedido` - Criada com sucesso
- ✅ `logs_importacao` - Criada com sucesso
- ✅ Trigger de `updated_at` - Ativo
- ✅ RLS - Habilitado em todas as tabelas
- ✅ Índices - Criados para performance

---

## 🚀 Próximas Etapas

1. **Integração n8n**: Configurar os nós HTTP do n8n com as URLs e chaves acima
2. **Testes**: Executar testes de UPSERT para validar operações
3. **Monitoramento**: Configurar alertas para erros de importação
4. **Backup**: Configurar backups automáticos no Supabase Dashboard

---

## 📞 Suporte

Para mais informações sobre o Supabase, visite: https://supabase.com/docs

**Versão do Documento**: v4.6.0
**Atualizado em**: 12 de Novembro de 2025
