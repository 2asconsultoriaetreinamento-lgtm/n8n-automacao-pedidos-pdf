# 🧪 Guia de Teste Prático - n8n Automação de Pedidos v4.6

## 📌 Objetivo

Este guia fornece instruções passo-a-passo para testar o fluxo completo de automação de pedidos Taschibra com o projeto Supabase recém-criado.

---

## 🎯 O Que Será Testado

1. ✅ **Gmail Trigger** - Recebimento de email com PDF
2. ✅ **Extração de PDF** - Leitura e parsing de dados
3. ✅ **Verificação de Duplicatas** - Consulta Supabase
4. ✅ **Inser** - Gravação em pedidos e itens_pedido
5. ✅ **Logging** - Registro de importação
6. ✅ **UPSERT v4.6** - Atualização de pedidos existentes

---

## 📧 Email de Teste

### Como Criar o Email de Teste

**Para: automacao@empresa.com.br**
**De: vendedor@taschibra.com.br**
**Assunto: Pedido de Vendas - 001234**

### Corpo do Email (Exemplo)

```
Segue em anexo o pedido de vendas número 001234 da Taschibra.

Dados do Pedido:
- Data: 12/11/2025
- Cliente: Distribuidora XYZ
- CNPJ: 12.345.678/0001-90
- Cidade: São Paulo
- UF: SP
- Valor Total: R$ 5.500,00
- Vendedor: João Silva
- Canal: Distribuição
- Tipo: Normal
- Email do Vendedor: joao.silva@taschibra.com.br

Itens do Pedido:
1. Produto: Furadeira Elétrica 700W
   Código: FURA-700-01
   Unidade: UN
   Quantidade: 50
   Valor Unitário: R$ 89,90
   Valor Total: R$ 4.495,00
   NCM: 8456.29.00
   IPI: 7.5%

2. Produto: Broca para Concreto 10mm
   Código: BROC-10-01
   Unidade: CX
   Quantidade: 20
   Valor Unitário: R$ 50,50
   Valor Total: R$ 1.010,00
   NCM: 8207.30.00
   IPI: 0%

Favor processar com prioridade.
```

### Anexo: PDF

**Nome do arquivo:** `PEDIDO_001234_TASCHIBRA.pdf`
**Tipo:** application/pdf
**Tamanho:** ~250 KB

---

## 🚀 Procedimento de Teste Passo-a-Passo

### Passo 1: Preparar o Ambiente

- ✅ Supabase project criado: `n8n-automacao-pedidos`
- ✅ Tabelas criadas: `pedidos`, `itens_pedido`, `logs_importacao`
- ✅ n8n workflow v4.5 ativo
- ✅ Gmail Astra credenciado

### Passo 2: Enviar Email de Teste

1. Abrir cliente de email (Gmail, Outlook, etc.)
2. Criar novo email com os dados acima
3. **Anexar PDF** do pedido Taschibra
4. Enviar para: `automacao@empresa.com.br`

### Passo 3: Monitorar Workflow

1. Abrir n8n em: http://localhost:5678
2. Navegar para workflow: "Automacao Pedidos PDF - Taschibra v4.5"
3. Ir para aba **"Executions"** (Execuções)
4. Observar novas execuções chegando

### Passo 4: Validar Resultados

#### No n8n:
- ✅ Gmail Trigger recebe o email
- ✅ PDF é lido corretamente
- ✅ Dados são extraídos
- ✅ Consulta ao Supabase retorna 0 resultados (pedido novo)
- ✅ INSERT em pedidos: Status 201 Created
- ✅ INSERT em itens_pedido: Status 201 Created
- ✅ Log de importação: Status 201 Created

#### No Supabase:
1. Abrir Supabase Dashboard
2. Ir para SQL Editor
3. Executar query de verificação:

```sql
-- Verificar pedidos inseridos
SELECT * FROM pedidos 
WHERE numero_pedido = '001234'
ORDER BY created_at DESC LIMIT 1;

-- Verificar itens do pedido
SELECT * FROM itens_pedido 
WHERE pedido_id = (SELECT id FROM pedidos WHERE numero_pedido = '001234')
ORDER BY id;

-- Verificar logs de importação
SELECT * FROM logs_importacao 
WHERE numero_pedido = '001234'
ORDER BY timestamp DESC;
```

---

## 🔄 Teste de UPSERT v4.6

### Cenário: Pedido Duplicado

1. **Enviar o mesmo email novamente** (com mesmo numero_pedido: 001234)
2. O workflow deve:
   - Consultar Supabase e encontrar o pedido existente
   - Identificar como duplicado
   - Executar UPDATE ao invés de INSERT (UPSERT)
   - Registrar no log_importacao com status "atualizado"

### Query para Verificar UPSERT:

```sql
-- Ver histórico de tentativas
SELECT numero_pedido, status, COUNT(*) as quantidade
FROM logs_importacao 
WHERE numero_pedido = '001234'
GROUP BY numero_pedido, status
ORDER BY timestamp DESC;

-- Verificar timestamp atualizado
SELECT numero_pedido, created_at, updated_at 
FROM pedidos 
WHERE numero_pedido = '001234';
```

---

## ✅ Checklist de Validação

- [ ] Email recebido pelo n8n
- [ ] PDF extraído com sucesso
- [ ] Dados parseados corretamente
- [ ] Pedido inserido no Supabase
- [ ] Itens inseridos no Supabase
- [ ] Log de importação criado
- [ ] Timestamp created_at preenchido
- [ ] UNIQUE constraint respeitado (numero_pedido único)
- [ ] Trigger updated_at funcionando
- [ ] RLS policies permitindo INSERT/SELECT
- [ ] Segundo email identificado como duplicado
- [ ] UPSERT atualiza o timestamp
- [ ] Log registra status "atualizado"

---

## 🐛 Troubleshooting

### Problema: Email não chega ao n8n
**Solução:**
- Verificar credenciais do Gmail Astra
- Confirmar que email foi enviado para a conta correta
- Verificar modo "polled" está ativo: "Every Minute"

### Problema: PDF não é lido
**Solução:**
- Verificar se o arquivo está com extensão .pdf
- Confirmar se não é arquivo corrompido
- Tentar com PDF simples de teste

### Problema: Dados não aparecem no Supabase
**Solução:**
- Verificar credenciais da API REST (SUPABASE_ANON_KEY)
- Confirmar RLS policies em modo permissivo
- Executar INSERT manual no SQL Editor

### Problema: UPSERT não funciona
**Solução:**
- Verificar se numero_pedido é UNIQUE
- Confirmar índice idx_pedidos_numero_pedido existe
- Validar lógica de condicional "IF - Não Duplicado?"

---

## 📊 Resultados Esperados

### Execução 1 (Novo Pedido)
```json
{
  "status": "sucesso",
  "pedidos_inseridos": 1,
  "itens_inseridos": 2,
  "log_status": "novo",
  "timestamp": "2025-11-12T10:30:00Z"
}
```

### Execução 2 (Pedido Duplicado)
```json
{
  "status": "atualizado",
  "pedidos_atualizados": 1,
  "itens_atualizados": 2,
  "log_status": "atualizado",
  "timestamp": "2025-11-12T10:35:00Z"
}
```

---

## 📝 Documentação de Referência

- [Supabase v4.6 Configuration](./SUPABASE_v4.6_CONFIGURACAO_PRODUCAO.md)
- [UPSERT v4.6 Implementation](./UPSERT_v4.6_IMPLEMENTACAO.md)
- [SQL Setup Scripts](./UPSERT_v4.6_SQL_SETUP.md)

---

## 🎓 Próximas Etapas Após Teste

1. **Ajustes no Parsing**: Refinar regex para diferentes formatos de PDF
2. **Tratamento de Erros**: Melhorar notificações em caso de falha
3. **Logs Detalhados**: Adicionar mais informações aos logs
4. **Performance**: Otimizar queries ao Supabase
5. **Monitoramento**: Configurar alertas para erros
6. **Produção**: Deploy com credenciais reais

---

**Versão**: v4.6.0
**Data**: 12 de Novembro de 2025
**Status**: 🟢 Pronto para Testes
