# Testes e Validacao - n8n Automacao Pedidos

**Data de Atualizacao**: 11 de Novembro de 2025  
**Status**: Template pronto para preenchimento

---

## Cenarios de Teste

### Teste 1: Upload PDF Valido (1-5 itens)
**Status**: [ ] Pendente  
**Data Teste**: ___________  
**Resultado**: [ ] PASSOU [ ] FALHOU

- [ ] PDF extraido corretamente
- [ ] Campos parseados sem erros
- [ ] Pedido criado no Supabase
- [ ] Itens criados com FK correto
- [ ] Sem duplicatas

**Observacoes**: _______________________________________________

---

### Teste 2: Upload Multiplos PDFs
**Status**: [ ] Pendente  
**Data Teste**: ___________  
**Resultado**: [ ] PASSOU [ ] FALHOU

- [ ] Multiplos PDFs processados em loop
- [ ] Cada pedido criado independentemente
- [ ] Sem conflitos de FK

**Observacoes**: _______________________________________________

---

### Teste 3: Validacao de Duplicidade
**Status**: [ ] Pendente  
**Data Teste**: ___________  
**Resultado**: [ ] PASSOU [ ] FALHOU

- [ ] Enviar mesmo PDF 2x
- [ ] Segunda execucao detecta duplicata
- [ ] Nao insere duplicado
- [ ] Log registra como SKIPPED

**Observacoes**: _______________________________________________

---

### Teste 4: PDF Invalido/Corrupto
**Status**: [ ] Pendente  
**Data Teste**: ___________  
**Resultado**: [ ] PASSOU [ ] FALHOU

- [ ] Sistema trata erro graciosamente
- [ ] Log registra erro com mensagem
- [ ] Fluxo continua para proximo PDF

**Observacoes**: _______________________________________________

---

### Teste 5: Campos Faltantes
**Status**: [ ] Pendente  
**Data Teste**: ___________  
**Resultado**: [ ] PASSOU [ ] FALHOU

- [ ] Campos ausentes registrados como NULL
- [ ] Pedido criado mesmo com campos faltantes
- [ ] Log avisor sobre campos faltantes

**Observacoes**: _______________________________________________

---

## Query de Validacao

Executar em Supabase:

```sql
SELECT * FROM Pedidos ORDER BY created_at DESC LIMIT 10;
SELECT * FROM Itens_Pedido WHERE pedido_id = ? ORDER BY created_at DESC;
SELECT COUNT(*) FROM Pedidos; -- Contar total
```

---

## Checklist de Execucao

- [ ] Todos os cenarios executados
- [ ] Todos os testes passaram
- [ ] Screenshots capturados
- [ ] Logs revisados
- [ ] Issues registradas (se houver)
- [ ] Documentacao atualizada

---

## Problemas Encontrados

| # | Data | Problema | Severidade | Status |
|----|------|----------|------------|--------|
| 1 | ___  | ________ | [ ] CRITICA [ ] ALTA [ ] MEDIA [ ] BAIXA | [ ] ABERTO [ ] RESOLVIDO |

---

## Assinatura

**Executado por**: _________________  
**Validado por**: _________________  
**Data**: _________________
