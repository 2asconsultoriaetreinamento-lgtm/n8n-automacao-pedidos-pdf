# n8n-automacao-pedidos-pdf

Automacao n8n para extracao de dados de pedidos em PDF (formato Taschibra) e registro em base Supabase, com validacao de duplicidade, agendamento automatico e notificacoes por email/Telegram.

**Status:** Em desenvolvimento v1.0

---

## Visao do Projeto

Este projeto automatiza o processamento de pedidos Taschibra em formato PDF, extraindo dados estruturados e salvando em um banco de dados Supabase.

### Funcionalidades Implementadas
- Leitura e parsing de PDFs com layout padrao
- Validacao de duplicidade antes da insercao
- Agendamento automatico (Scheduler/Cron)
- Separacao de dados: Pedidos (cabecalho) + Itens (detalhes)

### Funcionalidades Planejadas
- Logging e controle de falhas (Sprint 2)
- Notificacoes por email/Telegram (Sprint 3)
- Integracao com ERP (Backlog)

---

## Estrutura das Tabelas (Supabase)

### Tabela: Pedidos
| Campo | Tipo | Exemplo |
|-------|------|----------|
| id | serial (PK) | 1 |
| numero_pedido | text | 79710062025104428 |
| data_emissao | date | 2025-07-11 |
| cliente_nome | text | PAULO SERGIO SILVA - ME |
| cliente_cnpj | text | 06.912.516/0001-99 |
| cidade | text | VICOSA |
| uf | text | MG |
| valor_total | numeric | 7530.04 |
| vendedor | text | ANDRE |
| canal | text | LOJA DE MATERIAL ELETRICO |
| tipo | text | N-Normal |
| created_at | timestamp | - |

### Tabela: Itens_Pedido
| Campo | Tipo | Exemplo |
|-------|------|----------|
| id | serial (PK) | 1 |
| pedido_id | int (FK) | 1 |
| produto | text | LAMPADA LED TKL RGB IR 9W |
| codigo | text | 11080451 |
| unidade | text | PC |
| quantidade | integer | 10 |
| valor_unitario | numeric | 32.75 |
| valor_total | numeric | 455.99 |
| ncm | text | 85395200 |
| ipi | numeric | 6.5 |
| tipo_item | text | LUP / LAP / PEN / NAT |
| created_at | timestamp | - |

---

## Fluxo n8n - Arquitetura

```
Scheduler (Cron)
    |
    v
Ler PDF (Binary)
    |
    v
Extrair PDF (PDF Extract)
    |
    v
Parse JavaScript (Code Node)
    |
    v
Validar Duplicidade (HTTP GET)
    |
    v
Inserir Pedido (HTTP POST)
    |
    v
Inserir Itens (HTTP POST - Loop)
    |
    v
Notificar (Email/Telegram) [Futura]
    |
    v
Registrar Erro/Log [Futura]
```

---

## Configuracao e Deploy

### Pre-requisitos
- n8n v0.x+ instalado (cloud ou self-hosted)
- Supabase projeto criado com tabelas Pedidos e Itens_Pedido
- Credenciais Supabase: URL do projeto e chave API
- PDFs de teste com formato padrao Taschibra

### Passos de Instalacao

1. **Importar Fluxo no n8n**
   - Acesse seu console n8n
   - Clique em Import -> selecione workflows/pedidos-pdf-supabase.json

2. **Configurar Variaveis de Ambiente**
   ```
   SUPABASE_URL=https://<project>.supabase.co
   SUPABASE_KEY=<sua-chave-apisecret>
   SUPABASE_SECRET_KEY=<sua-chave-secreta>
   ```

3. **Agendar Execucao (Cron)**
   - Exemplo: 0 */2 * * * (a cada 2 horas)
   - Exemplo: 0 9 * * MON-FRI (diariamente seg-sex as 9h)

4. **Testar com PDF**
   - Coloque um PDF de teste
   - Dispare o fluxo manualmente
   - Verifique em Supabase se os registros foram criados

---

## Validacao de Duplicidade

Antes de inserir um pedido, o fluxo consulta Supabase:

```
GET /rest/v1/Pedidos?numero_pedido=eq.{numero_pedido}
```

- Se encontrado: Pula insercao, registra como duplicado
- Se nao encontrado: Insere novo pedido e itens

---

## Backlog e User Stories

### Sprint 1 (v1.0 - Funcionalidade Basica) - ATUAL
- [x] US-001: Importar PDFs de pedido e registrar automaticamente
- [x] US-004: Agendar fluxo automaticamente (Cron)
- [x] US-005: Validar e evitar duplicidades
- [x] US-008: Parsing robusto para variacoes de dados

### Sprint 2 (v1.1 - Logging e Erros)
- [ ] US-006: Log/controle de falhas por pedido/item
- [ ] Criar tabela Logs_Importacao no Supabase
- [ ] Node de erro que registra falhas

### Sprint 3 (v1.2 - Notificacoes)
- [ ] US-007: Notificar remetente por email/Telegram
- [ ] Integrar node Email ou Telegram
- [ ] Criar templates de notificacao

---

## Duvidas Validadas

### Respondidas
- **Layout dos PDFs**: Sempre igual, apenas dados variam
- **Agendamento**: Fluxo deve ser agendado (Scheduler)
- **Logging**: Iniciar simples, ativar apos validacao
- **Duplicidade**: Nunca inserir pedidos duplicados
- **Campos NCM/IPI**: Apenas extrair e registrar
- **Integracao**: Email e/ou Telegram ao remetente

Ver `docs/DUVIDAS.md` para detalhes completos.

---

## Testes e Validacao

### Cenarios de Teste
- [ ] Upload PDF valido com 1-5 itens
- [ ] Upload multiplos PDFs simultaneamente
- [ ] Teste de duplicidade: enviar mesmo PDF 2x
- [ ] PDF invalido ou corrupto
- [ ] Campos faltantes no PDF

### Como Executar Testes
1. Adicione PDFs reais em tests/sample-pdfs/
2. Rode o fluxo manualmente
3. Verifique em Supabase: SELECT * FROM Pedidos ORDER BY created_at DESC;
4. Registre resultados em docs/TESTES.md

---

## Estrutura do Repositorio

```
n8n-automacao-pedidos-pdf/
├── README.md
├── .gitignore
├── workflows/
│   └── pedidos-pdf-supabase.json      # Fluxo n8n principal
├── docs/
│   ├── ARQUITETURA.md                 # Design do sistema
│   ├── DUVIDAS.md                      # Duvidas validadas
│   ├── TESTES.md                       # Resultados de testes
│   └── CHANGELOG.md                    # Historico de versoes
├── tests/
│   └── sample-pdfs/                    # PDFs de teste
│       ├── PED1752268076588.pdf
│       ├── PED1752587206347.pdf
│       └── PED1754424082584.pdf
├── scripts/
│   ├── setup-supabase.sql              # Script para criar tabelas
│   └── validate-parsing.js             # Tester do parser
└── notifications/
    └── templates/
        ├── success-email.html          # Template de sucesso
        └── error-email.html            # Template de erro
```

---

## Proximos Passos

1. Validar credenciais Supabase
2. Importar fluxo n8n
3. Executar testes com PDFs reais
4. Registrar findings em docs/TESTES.md
5. Ativar logging apos validacao funcional
6. Implementar notificacoes na sprint 3

---

## Licenca

MIT License

---

## Suporte

Para duvidas ou issues:
1. Crie uma Issue no GitHub
2. Rotule conforme tipo: bug, feature, docs
3. Incluir logs/screenshots quando possivel

**Mantenedor**: Noowx Consultoria  
**Data**: Nov 11, 2025
