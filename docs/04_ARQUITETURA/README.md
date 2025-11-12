# 🎯 Árquitetura

## Sobre Esta Pasta

Documentação sobre design do sistema, fluxos de dados e comparações de versões.

## Documentos

- **ARQUITETURA.md** - Design geral do sistema
- **FLUXO_DETALHADO_v4.4.md** - Fluxo por nó (v4.4)
- **FLUXO_DETALHADO_v4.5.md** - Fluxo por nó (v4.5)
- **COMPARACAO_v4.4_vs_v4.5.md** - Análise comparativa
- **NOTA_CORRECCAO_LOOP_v4.5.md** - Correção de loop
- **GMAIL_TRIGGER_RECOMENDACAO.md** - Por que usar Gmail Trigger

## Principais Componentes

### v4.4 (Email IMAP)
- Trigger: Email Read IMAP
- Parser: JavaScript customizado
- Storage: Supabase

### v4.5 (Gmail Trigger)
- Trigger: Gmail Trigger nativo n8n
- Parser: JavaScript otimizado
- Storage: Supabase
- Melhor segurança e confiabilidade

## Como Usar

Se vocé quer:
- **Entender o fluxo**: Leia `ARQUITETURA.md`
- **Ver detalhes de v4.4**: Leia `FLUXO_DETALHADO_v4.4.md`
- **Ver detalhes de v4.5**: Leia `FLUXO_DETALHADO_v4.5.md`
- **Comparar versões**: Leia `COMPARACAO_v4.4_vs_v4.5.md`
- **Entender Gmail Trigger**: Leia `GMAIL_TRIGGER_RECOMENDACAO.md`
- **Ver resolução de loop**: Leia `NOTA_CORRECCAO_LOOP_v4.5.md`

## Próximos Passos

- [Ver Implementação](../02_IMPLEMENTACAO/README.md)
- [Ver Comparações](../06_COMPARACOES/README.md)
- [Ver Versões](../05_VERSOES/README.md)
- [Voltar ao Índice](../00_INDEX_DOCUMENTACAO.md)

---
**Última Atualização**: 12 de Novembro de 2025
