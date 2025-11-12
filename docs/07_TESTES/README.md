# ✅ Testes

## Sobre Esta Pasta

Documentação sobre planos de teste, casos de teste, roteiros de validação e estratégias de QA para o projeto.

## Documentos

- **TESTES.md** - Guia geral de testes e estratégia de QA
- **TESTE_IMPORTACAO_v4.0.md** - Plano de testes para versão 4.0
- **TESTE_IMPORTACAO_v4.1.md** - Plano de testes para versão 4.1
- **TESTE_IMPORTACAO_v4.5.md** - Plano de testes para versão 4.5 (recomendado)
- **CHECKLIST_DEPLOY.md** - Checklist para validação antes de deployment

## Áreas de Teste

### Funcional
- Importação de PDFs
- Extração de dados
- Geração de relatórios
- Integrações (Supabase, Gmail, etc)

### Não-Funcional
- Performance e volume
- Segurança (credenciais, permissões)
- Confiabilidade (retry, timeout)

### Regressão
- Testes em v4.4 antes de migrar
- Verificação pós-upgrade

## Como Usar

Se você precisa:

- **Planejar testes**: Leia `TESTES.md`
- **Testar versão específica**: Use o arquivo correspondente (e.g., `TESTE_IMPORTACAO_v4.5.md`)
- **Preparar produção**: Use `CHECKLIST_DEPLOY.md`
- **Entender cobertura**: Consulte tabela de versões acima

## Próximos Passos

- [Ver Implementação](../02_IMPLEMENTACAO/README.md)
- [Troubleshoot](../08_TROUBLESHOOTING/README.md)
- [Voltar ao Índice](../00_INDEX_DOCUMENTACAO.md)

---
**Última Atualização**: 12 de Novembro de 2025
