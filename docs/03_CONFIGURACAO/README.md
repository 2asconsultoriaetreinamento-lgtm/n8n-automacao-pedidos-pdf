# ⚙️ Configuração

## Sobre Esta Pasta

Guias de configuração de credenciais, variáveis de ambiente e setup de banco de dados.

## Documentos

### [VARIAVEIS_AMBIENTE.md](./VARIAVEIS_AMBIENTE.md)
Todas as variáveis de ambiente necessárias
- SUPABASE_URL
- SUPABASE_ANON_KEY
- email_vendedor (automático via Gmail)

### [CONFIGURACAO_EMAIL_IMAP.md](./CONFIGURACAO_EMAIL_IMAP.md)
Configuração de Email IMAP (v4.4)
- Setup de SMTP
- Autenticação com senha

### [CONFIGURACAO_GMAIL_OAUTH2.md](./CONFIGURACAO_GMAIL_OAUTH2.md) (Novo)
Configuração de Gmail OAuth2 (v4.5 - RECOMENDADO)
- Google Cloud Console setup
- OAuth2 credentials
- Scopes necessários

### [SETUP_SUPABASE.sql](./SETUP_SUPABASE.sql) (Novo)
Script SQL para criar tabelas
- Tabela pedidos
- Tabela itens_pedido
- Índices

## Como Usar

1. Escolha sua versão (v4.4 ou v4.5)
2. Configure conforme documentado
3. Defina variáveis de ambiente
4. Execute SQL se necessário

---

**Última Atualização**: 12 de Novembro de 2025
