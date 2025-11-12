-- Migration v4.4: Adiciona suporte para email do vendedor
-- Data: 12 de Novembro de 2025
-- Descrícao: Adiciona campo email_vendedor às tabelas pedidos e processamento_logs

-- 1. Adicionar coluna email_vendedor à tabela pedidos
ALTER TABLE public.pedidos 
ADD COLUMN email_vendedor VARCHAR(255) DEFAULT NULL;

-- 2. Adicionar índice para buscar pedidos por email_vendedor
CREATE INDEX idx_pedidos_email_vendedor ON public.pedidos(email_vendedor);

-- 3. Adicionar coluna email_vendedor à tabela processamento_logs
ALTER TABLE public.processamento_logs 
ADD COLUMN email_vendedor VARCHAR(255) DEFAULT NULL;

-- 4. Adicionar índice para logs por email_vendedor
CREATE INDEX idx_processamento_logs_email_vendedor ON public.processamento_logs(email_vendedor);

-- 5. Criar VIEW para relatório de vendedores
CREATE OR REPLACE VIEW vendedores_resumo AS
SELECT 
  email_vendedor,
  COUNT(DISTINCT numero_pedido) as total_pedidos,
  COUNT(*) as total_registros,
  SUM(CAST(REPLACE(REPLACE(valor_total, 'R$', ''), ',', '.') as FLOAT)) as valor_total_vendedor,
  MAX(created_at) as ultimo_pedido
FROM public.pedidos
WHERE email_vendedor IS NOT NULL
GROUP BY email_vendedor
ORDER BY total_pedidos DESC;

-- 6. Criar tabela de vendedores (opcional, para dados complementares)
CREATE TABLE IF NOT EXISTS public.vendedores (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  email VARCHAR(255) UNIQUE NOT NULL,
  nome VARCHAR(255),
  departamento VARCHAR(255),
  ativo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criar policy RLS para vendedores
ALTER TABLE public.vendedores ENABLE ROW LEVEL SECURITY;
CREATE POLICY vendedores_read ON public.vendedores
FOR SELECT USING (true);

-- 7. Atualizar coluna email_vendedor com FOREIGN KEY (opcional)
-- ALTER TABLE public.pedidos 
-- ADD CONSTRAINT fk_pedidos_vendedor FOREIGN KEY (email_vendedor) 
-- REFERENCES public.vendedores(email) ON DELETE SET NULL;

-- Notas de execução no Supabase:
-- 1. Abra Supabase Dashboard > SQL Editor
-- 2. Cole este script
-- 3. Clique "Run" (play button)
-- 4. Aguarde conclusão (deve ver "Success" com 7 queries executadas)

-- Verificação:
-- SELECT column_name FROM information_schema.columns WHERE table_name='pedidos';
-- SELECT column_name FROM information_schema.columns WHERE table_name='processamento_logs';
-- SELECT * FROM vendedores_resumo;
