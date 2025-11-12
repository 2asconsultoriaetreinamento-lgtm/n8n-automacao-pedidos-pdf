# Duvidas Validadas - Projeto n8n Automacao Pedidos PDF

**Data**: 11 de Novembro de 2025  
**Status**: Resolvidas

---

## Tabela de Duvidas e Respostas

| # | Duvida | Resposta | Status | Data |
|---|--------|----------|--------|------|
| 1 | Algum campo do PDF pode variar consideravelmente? | Layout sempre igual, apenas dados variam | Resolvida | 11/11/2025 |
| 2 | O fluxo pode ser agendado? | Sim, deve ser agendado (Scheduler/Cron) | Resolvida | 11/11/2025 |
| 3 | Necessidade de log/controle de falhas? | Sim, apos validacao inicial (Sprint 2) | Resolvida | 11/11/2025 |
| 4 | Como evitar duplicidades? | Validar numero_pedido antes de inserir | Resolvida | 11/11/2025 |
| 5 | Campos NCM/IPI/tipo_item ja estao no PDF? | Nao, apenas extrair e registrar | Resolvida | 11/11/2025 |
| 6 | Quais integrações futuras? | Email e/ou Telegram ao remetente | Resolvida | 11/11/2025 |

---

## Detalhes das Respostas

### 1. Variação do Layout dos PDFs

**Pergunta Original**: "Algum campo do PDF pode variar consideravelmente (novos campos, layouts diferentes)?"

**Resposta**: O layout sempre é o mesmo. O que varia são as **informações dos campos**.

**Implicações**:
- Regexes podem ser fixas e reutilizaveis
- Menos manutenção do codigo de parsing
- Possibilidade de reutilizar o fluxo para multiplos PDFs

**Acao**: Manter parsing com regex padronizado

---

### 2. Agendamento do Fluxo

**Pergunta Original**: "O fluxo pode ser agendado (scheduled) ou sempre sera manual/on demand?"

**Resposta**: O fluxo **DEVE ser agendado** automaticamente.

**Configuracao**:
- Node: Scheduler (Cron) no n8n
- Exemplo: `0 */2 * * *` (a cada 2 horas)
- Exemplo: `0 9 * * MON-FRI` (diariamente seg-sex as 9h)

**Acao**: Implementar Scheduler node como trigger inicial

---

### 3. Logging e Controle de Falhas

**Pergunta Original**: "Existe necessidade de log/controle de falhas por pedido/item?"

**Resposta**: **SIM, mas apos validacao inicial**. Iniciar simples, ativar logging na Sprint 2.

**Fases**:
- Sprint 1 (atual): Sem logging detalhado
- Sprint 2: Criar tabela `Logs_Importacao` no Supabase
- Sprint 2: Registrar erros e sucessos por execucao

**Tabela Supabase (Sprint 2)**:
```sql
CREATE TABLE Logs_Importacao (
    id SERIAL PRIMARY KEY,
    pedido_id INT REFERENCES Pedidos(id),
    status VARCHAR(50), -- 'SUCCESS' ou 'ERROR'
    mensagem_erro TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Acao**: Planejar tabela, implementar na Sprint 2

---

### 4. Validacao de Duplicidade

**Pergunta Original**: "Como evitar inserir mesmo pedido mais de uma vez?"

**Resposta**: **Nunca inserir duplicidades**. Validar `numero_pedido` antes de cada insercao.

**Implementacao**:
1. HTTP GET em Supabase: `GET /rest/v1/Pedidos?numero_pedido=eq.{numero_pedido}`
2. Se houver retorno: Pular insercao
3. Se vazio: Inserir novo pedido + itens

**Codigo Exemplo (n8n Code Node)**:
```javascript
const numero_pedido = $json["pedido"]["numero_pedido"];
const response = await fetch(
    `https://<project>.supabase.co/rest/v1/Pedidos?numero_pedido=eq.${numero_pedido}`,
    {
        headers: {
            apikey: SUPABASE_KEY,
            Authorization: `Bearer ${SUPABASE_KEY}`
        }
    }
);
const data = await response.json();
return [{ isDuplicate: data.length > 0 }];
```

**Acao**: Implementado no fluxo principal Sprint 1

---

### 5. Campos NCM / IPI / tipo_item

**Pergunta Original**: "Campos NCM, IPI, tipo_item ja estao presentes no PDF/precisam ser validados?"

**Resposta**: **Nao existem no PDF original**. Apenas **extrair e registrar** se presentes.

**Comportamento**:
- Se campo estiver no PDF: Extrair
- Se nao estiver: Registrar como `NULL` ou valor padrao
- Sem validacao de formato neste momento

**Acao**: Manter campos com valores extraidos ou nulos

---

### 6. Integrações Futuras

**Pergunta Original**: "Quais integrações futuras sao desejadas?"

**Resposta**: **Email e/ou notificacoes ao remetente** do anexo/pedido.

**Roadmap**:
- Sprint 1: Fluxo basico (ATUAL)
- Sprint 2: Logging e controle de erros
- Sprint 3: **Notificacoes por Email/Telegram**
  - Node Email: Notificar sucesso/erro
  - Node Telegram: Bot com status de processamento
  - Templates de mensagens em `notifications/templates/`

**Futuro (Backlog)**:
- Integracao com ERP
- Dashboard de monitoramento
- Auditoria de mudancas

**Acao**: Planejar sprint 3 com templates prontos

---

## Rastreabilidade

**Criado por**: Consultor de Automacoes Noowx  
**Validado com**: Usuario Final / Stakeholder  
**Proxima revisao**: Apos Sprint 1 (validacao funcional)  

---

## Historico de Atualizacoes

- **11/11/2025 - v1.0**: Inicial com 6 duvidas resolvidas
