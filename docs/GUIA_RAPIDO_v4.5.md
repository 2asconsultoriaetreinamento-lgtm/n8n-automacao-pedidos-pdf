# Guia Rápido - n8n Automação Pedidos PDF v4.5 (Gmail Trigger)

**Status**: ✅ Versão 4.5.0 - Recepção via Gmail Trigger (OAuth2)

**Data**: 12 de Novembro de 2025

## 🚀 Início Rápido (20 minutos)

> **RECOMENDADO**: Esta versão (v4.5) é a recomendada para produção por oferecer:
> - Autenticação segura via OAuth2 (sem armazenar senhas)
> - Compatibilidade com nó nativo do n8n (suporte oficial)
> - Loop corrigido e verificado
> - Sem necessidade de senhas de aplicativo no Gmail

Este guia assume que você já possui:

- ✅ Conta Supabase ativa
- ✅ n8n instalado (cloud ou self-hosted)
- ✅ Conta Gmail para receber PDFs

## Passo 1: Configurar Gmail no n8n (5 minutos)

### 1.1 Adicionar Nó Gmail Trigger

1. No editor n8n, clique em "Add node"
2. Procure por "Gmail Trigger"
3. Selecione "Gmail Trigger"
4. Clique em "Connect my account"

### 1.2 Autenticar com Google

1. Uma janela de autenticação do Google será aberta
2. Faça login com sua conta Gmail
3. Clique "Allow" para dar permissão ao n8n
4. Copie o código de autorização e cole no n8n

### 1.3 Configurar Trigger

- **Watch**: Selecione "New message on a label"
- **Label**: Selecione "Inbox" ou crie um label "PDF Pedidos"
- **Poll interval**: 30 segundos (ou conforme sua necessidade)

## Passo 2: Configurar Banco de Dados (5 minutos)

Ver: [VARIAVEIS_AMBIENTE.md](./VARIAVEIS_AMBIENTE.md) - mesmas variáveis de v4.4

## Passo 3: Importar Workflow (5 minutos)

1. Faça download do arquivo: `pedidos-pdf-supabase-v4.5.json`
2. No n8n, clique menu (3 pontos) > "Import from file"
3. Selecione o arquivo JSON
4. O workflow será importado com todos os nós

## Passo 4: Ajustar Credenciais (3 minutos)

Os nós HTTP estarão com status de erro. Para cada um:

1. Clique no nó HTTP (ex: "HTTP GET - Verificar Duplicidade")
2. No painel direito, atualize os dados:
   - **Authentication**: "Bearer Token"
   - **Bearer**: Seu token Supabase (mesma variável de v4.4)
   - **Custom Headers**: Adicione headers necessários
3. Repita para todos os nós HTTP

## Diferenças v4.4 vs v4.5

| Aspecto | v4.4 | v4.5 |
|--------|------|------|
| **Trigger** | Email Read IMAP | Gmail Trigger (nativo) |
| **Autenticação** | SMTP (senha) | OAuth2 (seguro) |
| **Configuração** | Média (IMAP settings) | Fácil (clique autorizar) |
| **Suporte** | Community | Oficial n8n |
| **Loop** | Verificado | Verificado + corrigido |

## Testes Rápidos

1. Envie um e-mail com PDF para seu Gmail
2. O workflow deve acionar em até 30 segundos
3. Verifique os logs para confirmacião
4. Consulte Supabase para verificar inserção dos dados

## Migração de v4.4 para v4.5

Se você já tem v4.4 em produção:

1. **Backup**: Exporte o workflow v4.4 como JSON
2. **Teste**: Configure v4.5 em um banco de dados de teste
3. **Migre**: Aps validação, ative v4.5 e desative v4.4
4. **Monitore**: Acompanhe os primeiros 100 emails

## Troubleshooting

### "Gmail Trigger não está acionando"
- Verifique se o label/inbox foi configurado corretamente
- Confirme que n8n tem permissão para acessar Gmail
- Aguarde o intervalo de poll (pode levar até 1 minuto)

### "PDFs não estão sendo baixados"
- Verifique se nó "Read Binary File" tem caminho correto
- Confirme permissões de acesso ao Google Drive/attachment

### "Erros de banco de dados"
- Consulte [VARIAVEIS_AMBIENTE.md](./VARIAVEIS_AMBIENTE.md)
- Verifique credenciais Supabase nos nós HTTP

## Próximos Passos

- Ler [NOTA_CORRECCAO_LOOP_v4.5.md](./NOTA_CORRECCAO_LOOP_v4.5.md) para entender a verificação do loop
- Consultar [IMPLEMENTACAO_v4.5.md](./IMPLEMENTACAO_v4.5.md) para detalhes completos
- Ver [GMAIL_TRIGGER_RECOMENDACAO.md](./GMAIL_TRIGGER_RECOMENDACAO.md) para comparação v4.4 vs v4.5

---

**Versão**: v4.5.0  
**Última atualização**: 12 de Novembro de 2025  
**Status**: ✅ Prónt para Produção
