-- Script de Setup para Supabase
-- Cria as tabelas para a automacao de pedidos PDF
-- Executar apos criar o projeto Supabase

CREATE SCHEMA IF NOT EXISTS pedidos;

-- Tabela de Pedidos
CREATE TABLE IF NOT EXISTS pedidos.pedidos (
  id BIGSERIAL PRIMARY KEY,
  numero_pedido VARCHAR(50) NOT NULL UNIQUE,
  data_pedido TIMESTAMP WITH TIME ZONE NOT NULL,
  cliente_nome VARCHAR(255) NOT NULL,
  cliente_email VARCHAR(255),
  cliente_telefone VARCHAR(20),
  valor_total DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) DEFAULT 'novo',
  arquivo_pdf_url VARCHAR(500),
  data_criacao TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  data_atualizacao TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT unique_numero_pedido UNIQUE (numero_pedido)
);

-- Tabela de Itens do Pedido
CREATE TABLE IF NOT EXISTS pedidos.itens_pedido (
  id BIGSERIAL PRIMARY KEY,
  pedido_id BIGINT NOT NULL REFERENCES pedidos.pedidos(id) ON DELETE CASCADE,
  numero_item VARCHAR(10) NOT NULL,
  descricao_produto VARCHAR(500) NOT NULL,
  quantidade DECIMAL(10, 2) NOT NULL,
  valor_unitario DECIMAL(10, 2) NOT NULL,
  valor_total DECIMAL(10, 2) NOT NULL,
  data_criacao TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_pedido_id FOREIGN KEY (pedido_id) REFERENCES pedidos.pedidos(id)
);

-- Tabela de Log de Processamento
CREATE TABLE IF NOT EXISTS pedidos.logs_processamento (
  id BIGSERIAL PRIMARY KEY,
  pedido_id BIGINT REFERENCES pedidos.pedidos(id) ON DELETE CASCADE,
  tipo_evento VARCHAR(50) NOT NULL,
  mensagem TEXT,
  status_sucesso BOOLEAN DEFAULT true,
  data_evento TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indices para melhor performance
CREATE INDEX IF NOT EXISTS idx_pedidos_numero ON pedidos.pedidos(numero_pedido);
CREATE INDEX IF NOT EXISTS idx_pedidos_status ON pedidos.pedidos(status);
CREATE INDEX IF NOT EXISTS idx_itens_pedido_id ON pedidos.itens_pedido(pedido_id);
CREATE INDEX IF NOT EXISTS idx_logs_pedido_id ON pedidos.logs_processamento(pedido_id);
CREATE INDEX IF NOT EXISTS idx_logs_tipo ON pedidos.logs_processamento(tipo_evento);

-- Habilitar Row Level Security (RLS)
ALTER TABLE pedidos.pedidos ENABLE ROW LEVEL SECURITY;
ALTER TABLE pedidos.itens_pedido ENABLE ROW LEVEL SECURITY;
ALTER TABLE pedidos.logs_processamento ENABLE ROW LEVEL SECURITY;

-- Trigger para atualizar data de atualizacao
CREATE OR REPLACE FUNCTION pedidos.atualizar_data_atualizacao()
RETURNS TRIGGER AS $$
BEGIN
  NEW.data_atualizacao = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_pedidos
  BEFORE UPDATE ON pedidos.pedidos
  FOR EACH ROW
  EXECUTE FUNCTION pedidos.atualizar_data_atualizacao();

-- Comentarios nas tabelas
COMMENT ON TABLE pedidos.pedidos IS 'Registro de pedidos extraidos de PDFs';
COMMENT ON TABLE pedidos.itens_pedido IS 'Itens individuais de cada pedido';
COMMENT ON TABLE pedidos.logs_processamento IS 'Log de eventos e erros';
COMMENT ON COLUMN pedidos.pedidos.numero_pedido IS 'ID unico do pedido';
COMMENT ON COLUMN pedidos.pedidos.status IS 'Status: novo, processado, erro';

-- Fim do script
