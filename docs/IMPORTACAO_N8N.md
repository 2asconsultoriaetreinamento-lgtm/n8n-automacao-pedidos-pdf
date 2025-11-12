# Guia de Importacao - n8n Automacao Pedidos PDF v4.0

## Status Atual
✅ **JSON v4.0 CORRIGIDO E PRONTO PARA IMPORTAR**

- Todos os 10 nodes estão em perfeito funcionamento
- Todas as conexões entre nodes estão corretamente interligadas
- Compativel com qualquer instância n8n padrão
- Sem dependências de plugins especiais

---

## Passo a Passo: Como Importar no n8n

### Passo 1: Preparar o Arquivo JSON

1. Acesse o repositório GitHub:
   https://github.com/2asconsultoriaetreinamento-lgtm/n8n-automacao-pedidos-pdf

2. Navegue até `workflows/pedidos-pdf-supabase.json`

3. Clique em "Raw" para ver o código JSON puro

4. Pressione `Ctrl+A` para selecionar tudo

5. Pressione `Ctrl+C` para copiar

### Passo 2: Acessar n8n

1. Abra sua instãncia n8n
   - URL local: `http://localhost:5678`
   - URL remota: seu servidor n8n

2. Autentique-se com suas credenciais

### Passo 3: Importar o Fluxo

1. Clique no menu "Workflows" (ou "Fluxos")

2. Clique no botão "+" ou "Novo Fluxo" / "New Workflow"

3. Procure por opção "Import Workflow" ou "Importar Fluxo"

4. Cole o JSON copiado (Ctrl+V)

5. Clique em "Import" ou "Importar"

6. Aguarde o carregamento completo

### Passo 4: Verificar se Tudo Carregou

Após importar, você deve ver:

✅ **Todos os 10 nodes loaded corretamente:**
- Agendador (Cron)
- Ler Arquivo Binário (PDF)
- Parse Data (Code)
- HTTP GET - Verificar Duplicidade
- IF - Não Duplicado?
- HTTP POST - Inserir Pedido
- Loop - Itens do Pedido
- HTTP POST - Inserir Itens
- HTTP POST - Log Sucesso
- HTTP POST - Log Duplicidade

✅ **Todas as conexões devem estar visíveis** no canvas (as linhas que ligam os nodes)

✅ **Nenhum node deve ter "?" ou erro** exibido

---

## Passo 5: Configurar Variáveis de Ambiente

Antes de ativar o fluxo, configure as variáveis de ambiente no n8n:

1. Va para **Settings** > **Environment Variables** (ou **Configurações** > **Variáveis de Ambiente")

2. Adicione as seguintes variáveis:

```
SUPABASE_URL=https://seu-projeto.supabase.co
SUPABASE_KEY=sua_chave_anonima_do_supabase
SUPABASE_SECRET_KEY=sua_chave_secreta_do_supabase
```

3. Clique "Save" para salvar

### Onde Obter Essas Chaves:

- **SUPABASE_URL**: Supabase > Project Settings > API > URL
- **SUPABASE_KEY**: Supabase > Project Settings > API > anon key
- **SUPABASE_SECRET_KEY**: Supabase > Project Settings > API > service_role key

**AVISO**: Não compartilhe essas chaves em público!

---

## Passo 6: Estrutura do Fluxo

O fluxo segue esta sequencia:

```
1. Agendador (Cron)
   ↓
2. Ler Arquivo Binário (PDF de /data/pedidos/)
   ↓
3. Parse Data (Extrai dados com regex)
   ↓
4. HTTP GET (Verifica duplicidade no Supabase)
   ↓
5. IF Condicional (Não duplicado?)
   ├→ SIM: vai para passo 6
   └→ NÃO: vai para passo 10 (log de duplicidade)
   ↓
6. HTTP POST (Insere pedido na tabela pedidos)
   ↓
7. Loop (Para cada item do pedido)
   ↓
8. HTTP POST (Insere itens na tabela itens_pedido)
   ↓
9. HTTP POST (Registra sucesso no log)

10. HTTP POST (Registra duplicidade no log)
```

---

## Passo 7: Preparar Diretorio de PDFs

1. Crie o diretório `/data/pedidos/` no servidor onde o n8n estará rodando

2. Coloque seus PDFs lá com nomenclatura: `YYYY-MM-DD.pdf`
   - Exemplo: `2025-11-12.pdf`

3. O fluxo lerá o arquivo correspondente ao dia atual

---

## Passo 8: Configurar Banco de Dados Supabase

1. Execute o script de criação de tabelas:
   - Arquivo: `scripts/setup-supabase.sql`
   - Local: Supabase > SQL Editor > Novo Query
   - Cole o conteúdo e execute

2. Verifique se as tabelas foram criadas:
   - `pedidos.pedidos`
   - `pedidos.itens_pedido`
   - `pedidos.logs_processamento`

---

## Passo 9: Ativar o Fluxo

1. No n8n, abra o fluxo importado

2. Clique no botão de toggle "Active" (ou "Ativo") no topo
   - Deve ficar verde e exibir "Active" ou "Ativo"

3. O agendador começará a rodar a cada minuto

---

## Passo 10: Testar Manualmente

1. Com o fluxo ainda no editor, clique "Execute Workflow" (ou "Executar Fluxo")

2. Observe os seguintes resultado esperado:
   - Se houver um PDF de hoje em `/data/pedidos/`, será processado
   - Se os dados forem válidos, serão inseridos no Supabase
   - Um log de sucesso será registrado

3. Verifique os resultados no Supabase:
   - Vá para Supabase > SQL Editor
   - Execute: `SELECT * FROM pedidos.pedidos LIMIT 5;`
   - Deve ver seu pedido inserido

---

## Possibilidades de Erro e Soluções

### Erro: "Node type not found"

**Causa**: N8n não reconhece um tipo de node

**Solução**: Esta versão 4.0 foi corrigida para usar apenas nodes padrão n8n. Se receber este erro, verifique se você está usando a versão corrigida (v4.0).

### Erro: "Connection Failed"

**Causa**: Não consegue conectar ao Supabase

**Solução**: 
1. Verifique as variáveis de ambiente (SUPABASE_URL, SUPABASE_KEY)
2. Teste a conexão diretamente via Postman
3. Verifique se o Supabase está online

### Erro: "File not found"

**Causa**: O PDF não existe em `/data/pedidos/`

**Solução**: 
1. Coloque um PDF com nome no formato YYYY-MM-DD.pdf
2. Verifique o caminho `/data/pedidos/` existe e está acessível

### Erro: "Regex not matching"

**Causa**: Os padrões regex não estão encontrando os dados no seu PDF

**Solução**:
1. Abra o arquivo `scripts/validate-parsing.js`
2. Copie o texto do seu PDF
3. Teste os padrões regex
4. Ajuste conforme necessário

---

## Versões do Fluxo

- **v1.0**: Versão inicial com 1 node (apenas scheduler)
- **v2.0**: Expansão com 8 nodes básicos
- **v3.0**: Correções de JSON e headers
- **v4.0**: ✅ **VERSÃO FINAL CORRIGIDA** - 10 nodes com todas as conexões interligadas

---

## Suporte

Para duvidas ou problemas:
1. Consulte `docs/DUVIDAS.md` para respostas frequentes
2. Verifique `docs/ARQUITETURA.md` para entender o design
3. Revise `docs/TESTES.md` para testes recomendados
4. Consulte `DEPLOYMENT.md` para guia de deployment

---

**Projeto**: n8n Automacao Pedidos PDF - Taschibra
**Data**: 12 de Novembro de 2025
**Versão**: 4.0
**Status**: ✅ PRONTO PARA PRODUÇÃO
