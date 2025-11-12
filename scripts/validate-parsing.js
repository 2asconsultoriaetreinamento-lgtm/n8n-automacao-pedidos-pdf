/**
 * Script para validar a logica de parsing de dados de pedidos em PDF
 * Teste unitario para as regex patterns utilizadas no n8n
 * 
 * Execucao: node validate-parsing.js
 */

// Padroes regex para parsing de dados
const PATTERNS = {
  numero_pedido: /Pedido\s*[#:]?\s*(\d{6,})/i,
  data_pedido: /Data\s*[#:]?\s*(\d{1,2})[/-](\d{1,2})[/-](\d{4})/i,
  cliente: /Cliente\s*[#:]?\s*([^\n]+)/i,
  email: /Email\s*[#:]?\s*([\w.-]+@[\w.-]+\.\w+)/i,
  valor_total: /Total\s*[#:]?\s*(?:R\$)?\s*([\d.,]+)/i,
  item_line: /\d{1,3}\.?\s+(.+?)\s+(\d+)\s+x?\s*(?:R\$)?\s*([\d.,]+)/g
};

// Dados de teste
const TEST_PDF_CONTENT = `
  PEDIDO #001234
  Data: 14/11/2025
  Cliente: Empresa XYZ Ltda
  Email: contato@empresaxyz.com
  Telefone: (11) 98765-4321
  
  ITENS:
  1. Produto A - Quantidade: 5 - R$ 100.00
  2. Servico B - Quantidade: 2 - R$ 250.50
  3. Produto C - Quantidade: 1 - R$ 1500.00
  
  Total: R$ 3.650,50
`;

// Funcoes de teste
function testarPadroes() {
  console.log('\n=== TESTE DE VALIDACAO DE PARSING ===\n');
  
  // Teste numero pedido
  const numeroPedido = TEST_PDF_CONTENT.match(PATTERNS.numero_pedido);
  console.log('Numero Pedido:', numeroPedido ? numeroPedido[1] : 'NAO ENCONTRADO');
  
  // Teste data
  const dataPedido = TEST_PDF_CONTENT.match(PATTERNS.data_pedido);
  if (dataPedido) {
    console.log(`Data Pedido: ${dataPedido[1]}/${dataPedido[2]}/${dataPedido[3]}`);
  }
  
  // Teste cliente
  const cliente = TEST_PDF_CONTENT.match(PATTERNS.cliente);
  console.log('Cliente:', cliente ? cliente[1].trim() : 'NAO ENCONTRADO');
  
  // Teste email
  const email = TEST_PDF_CONTENT.match(PATTERNS.email);
  console.log('Email:', email ? email[1] : 'NAO ENCONTRADO');
  
  // Teste valor total
  const valorTotal = TEST_PDF_CONTENT.match(PATTERNS.valor_total);
  console.log('Valor Total:', valorTotal ? valorTotal[1] : 'NAO ENCONTRADO');
  
  // Teste itens (loop)
  console.log('\nItens Encontrados:');
  let match;
  let contador = 0;
  while ((match = PATTERNS.item_line.exec(TEST_PDF_CONTENT)) !== null) {
    contador++;
    console.log(`  Item ${contador}: ${match[1]} | Qtd: ${match[2]} | Valor: R$ ${match[3]}`);
  }
  
  if (contador === 0) {
    console.log('  Nenhum item encontrado');
  }
}

// Executar testes
if (require.main === module) {
  testarPadroes();
}

module.exports = { PATTERNS, testarPadroes };
