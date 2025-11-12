> ⚠️ **IMPORTANTE**: Este é um guia para a versão **v4.4 (Email IMAP)**. 
> 
> Para instalação em PRODUÇÃO, recomendamos usar a **versão v4.5 (Gmail Trigger)** que oferece:
> - **Segurança melhor**: Autenticação OAuth2 (sem armazenar senha)
> - **Compatibilidade**: Nó nativo do n8n (suporte oficial)
> - **Loop corrigido**: Verificação completa da estrutura
> 
> Ver: [GUIA_RAPIDO_v4.5.md](./GUIA_RAPIDO_v4.5.md) para setup de v4.5
> 
> ---


# Guia Rápido - n8n Automação Pedidos PDF v4.4

**Status**: ✅ Versão 4.4.0 - Recepção via Email (IMAP)

**Data**: 19 de Dezembro de 2025

## 🚀 Início Rápido (20 minutos)

Este guia assume que você já possui:
- ✅ Conta Supabase ativa
- ✅ n8n instalado (cloud ou self-hosted)
- ✅ Email (Gmail ou Hostinger) para recepcionar PDFs

### Passo 1: Preparar o Banco de Dados (5 minutos)

1. Abra o **Supabase SQL Editor**
2. Copie o conteúdo de: `/scripts/migration-add-email-vendedor.sql`
3. Cole no SQL Editor e clique **Run**
4. Aguarde a mensagem de sucesso (✓ 7 queries executadas)

**O que foi criado:**
- ✅ Novo campo `email_vendedor` na tabela `pedidos`
- ✅ Índice de performance para queries rápidas
- ✅ View `vendedores_resumo` para relatórios
- ✅ Tabela `vendedores` para gerenciamento
- ✅ RLS Policies para segurança

### Passo 2: Configurar n8n (10 minutos)

#### 2.1 - Importar Workflow

1. Abra seu **n8n**
2. Clique em **Workflows** → **New** → **Import from file**
3. Selecione `/workflows/pedidos-pdf-supabase.json` (versão v4.4)
4. Clique **Import**
5. Você deve ver os nós conectados corretamente (não deve haver nós desconectados)

#### 2.2 - Configurar Variáveis de Ambiente

1. Vá para **Settings** → **Environment Variables**
2. Adicione as 3 variáveis (copie do Supabase API settings):

```
SUPABASE_URL=https://seu-projeto.supabase.co
SUPABASE_KEY=sua_chave_api_publica
SUPABASE_SECRET_KEY=sua_chave_secreta
```

**Onde encontrar:**
- Supabase → Project Settings → API
- Copie `Project URL` para `SUPABASE_URL`
- Copie `anon public` key para `SUPABASE_KEY`
- Copie `service_role secret` para `SUPABASE_SECRET_KEY`

#### 2.3 - Configurar Email Trigger (IMAP)

1. No workflow v4.4, clique no primeiro nó: **Email Trigger (EmailReadImap)**
2. Clique em **Create New Credential**
3. Escolha seu provedor:

**Opção A: Gmail (Recomendado)**
- Host: `imap.gmail.com`
- Port: `993`
- Email: seu_email@gmail.com
- Senha: **App-specific password** (genérica, não a senha da conta)
  - Acesse: https://myaccount.google.com/apppasswords
  - Selecione App: Mail, Device: Windows
  - Copie a senha de 16 caracteres

**Opção B: Hostinger**
- Host: `imap.hostinger.com`
- Port: `993`
- Email: seu_email@seudominio.com.br
- Senha: a mesma do email

4. Clique **Test Connection** para validar
5. Clique **Save**

#### 2.4 - Ativar Workflow

1. No topo do workflow, clique no toggle para **ativar** (deve ficar VERDE)
2. Agora o workflow escuta automaticamente por emails com PDFs

### Passo 3: Testar (5 minutos)

#### 3.1 - Enviar Email de Teste

1. De qualquer email, envie um PDF para o seu email configurado:
   - Assunto: Qualquer coisa (não é usado)
   - Anexo: 1 PDF de pedido (formato Taschibra)

#### 3.2 - Monitorar Execução

1. Volte para o n8n
2. Clique em **Executions** (no lado esquerdo)
3. Você deve ver a execução rodando
4. Espere a conclusão (status deve ser ✅ ou ❌)

#### 3.3 - Verificar Dados no Supabase

1. Abra Supabase
2. Clique em **Table Editor**
3. Selecione tabela **pedidos**
4. Procure pela linha mais recente (OrderBy `created_at`)
5. Verifique:
   - ✅ `numero_pedido` foi preenchido
   - ✅ `email_vendedor` contém o email de quem enviou
   - ✅ Outros campos (cliente, valor, etc)

6. Clique em uma linha para expandir
7. No final, você deve ver:
   - ✅ `created_at` = data/hora de hoje
   - ✅ `email_vendedor` = seu email

## 📊 O que acontece a cada email recebido?

```
┌─ Email chega (IMAP)
├─ n8n detecta novembro email
├─ Extrai o PDF do anexo
├─ Parse do PDF com regex
├─ Valida se pedido já existe
├─ Insere novo pedido com email_vendedor
├─ Insere todos os itens (loop)
├─ Marca email como lido
├─ Log de sucesso
└─ Fim
```

## 🔍 Monitoramento e Troubleshooting

### Email não está sendo detectado?

**Checklist:**
- [ ] Workflow está ativado? (toggle VERDE?)
- [ ] Email Trigger tem credenciais salvas? (Clique e veja senha mascarada)
- [ ] IMAP está habilitado? (Para Gmail: https://myaccount.google.com/lesssecureapps)
- [ ] Email foi enviado para o endereço certo?
- [ ] PDF está no anexo (não no corpo)?

### Dados não aparecem no Supabase?

**Checklist:**
- [ ] Variáveis de ambiente estão definidas? (clique em Settings)
- [ ] A chave Supabase está correta? (teste em https://supabase.com/dashboard)
- [ ] A tabela `pedidos` existe? (Clique em Table Editor)
- [ ] RLS não está bloqueando? (desative RLS temporariamente para debug)

### PDF não está sendo lido?

**Checklist:**
- [ ] O PDF é do formato Taschibra? (compare com arquivos em /tests/sample-pdfs/)
- [ ] O PDF não é protegido por senha?
- [ ] Veja o log do n8n (Executions → clique na execução falhada)

## 📚 Documentação Complementar

- **IMPLEMENTACAO_v4.4_PASSO_A_PASSO.md** - Versão detalhada deste guia
- **CONFIGURACAO_EMAIL_IMAP.md** - Configuração profunda de IMAP
- **CHANGELOG.md** - Histórico completo de versões
- **ARQUITETURA.md** - Design do sistema n8n

## ✅ Checklist de Conclusão

Ao terminar, marque:

- [ ] Supabase SQL script executado com sucesso
- [ ] Workflow v4.4 importado em n8n
- [ ] Variáveis de ambiente configuradas
- [ ] Email Trigger credential salva e testada
- [ ] Workflow ativado (toggle VERDE)
- [ ] Email de teste enviado
- [ ] Dados aparecem no Supabase com email_vendedor preenchido
- [ ] Todos os itens do pedido foram processados

## 🎯 Próximos Passos

1. **Fase de Testes**: Envie 3-5 emails com PDFs reais
2. **Validação**: Confirme que email_vendedor é capturado corretamente
3. **Ativação**: Configure para todos os vendedores
4. **Futuro**: Considere dashboard com métricas por vendedor

---

**Versão**: 4.4.0
**Data**: 19/12/2025
**Atualizado por**: 2asconsultoriaetreinamento-lgtm
