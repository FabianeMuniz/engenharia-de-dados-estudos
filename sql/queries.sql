-- =====================================================
-- SQL PARA ENGENHARIA DE DADOS
-- Autor: Fabiane Muniz
-- Descrição:
-- Conjunto de queries utilizadas no dia a dia de suporte técnico e
-- análise de dados em um ambiente SaaS, aplicadas em cenários de
-- extração, análise e apoio à tomada de decisão.
-- =====================================================


-- =====================================================
-- 1. INNER JOIN
-- =====================================================
-- Objetivo:
-- Identificar clientes que contrataram e utilizam determinados
-- serviços ou plugins dentro do sistema SaaS.

SELECT
    p.pedido_id,
    c.cliente_nome,
    p.valor_total
FROM pedidos p
INNER JOIN clientes c
    ON p.cliente_id = c.cliente_id;

-- Utilização no dia a dia:
-- Query semelhante foi utilizada para levantar quais clientes
-- possuíam contratos ativos e utilizavam plugins específicos,
-- informação solicitada pela liderança e áreas de negócio.


-- =====================================================
-- 2. LEFT JOIN
-- =====================================================
-- Objetivo:
-- Retornar todos os clientes, incluindo aqueles que não possuem
-- registros associados, garantindo dados completos para relatórios.

SELECT
    c.cliente_nome,
    p.pedido_id
FROM clientes c
LEFT JOIN pedidos p
    ON c.cliente_id = p.cliente_id;

-- Utilização no dia a dia:
-- Muito utilizado para exportação de históricos completos,
-- como chamados, contratos ou registros operacionais, envolvendo
-- múltiplas tabelas para garantir visão integral do cliente.


-- =====================================================
-- 3. GROUP BY + HAVING
-- =====================================================
-- Objetivo:
-- Realizar agregações para análise quantitativa e financeira,
-- filtrando resultados com base em métricas consolidadas.

SELECT
    cliente_id,
    COUNT(pedido_id) AS total_pedidos,
    SUM(valor_total) AS total_gasto
FROM pedidos
GROUP BY cliente_id
HAVING SUM(valor_total) > 1000;

-- Utilização no dia a dia:
-- Estrutura utilizada para identificar volume de ativos ou consumo
-- por cliente, informações repassadas ao financeiro para cálculo
-- de cobrança e validação de planos contratados.


-- =====================================================
-- 4. SUBQUERY
-- =====================================================
-- Objetivo:
-- Identificar clientes com comportamento acima da média,
-- útil para análises estratégicas e segmentações.

SELECT
    cliente_id,
    cliente_nome
FROM clientes
WHERE cliente_id IN (
    SELECT
        cliente_id
    FROM pedidos
    GROUP BY cliente_id
    HAVING AVG(valor_total) > (
        SELECT AVG(valor_total)
        FROM pedidos
    )
);

-- Utilização no dia a dia:
-- Aplicável em análises para identificar clientes com maior uso
-- ou consumo acima do padrão, auxiliando decisões comerciais
-- e estratégicas.


-- =====================================================
-- 5. CTE (Common Table Expression)
-- =====================================================
-- Objetivo:
-- Facilitar a leitura e manutenção da query ao trabalhar com
-- dados agregados, simulando uma tabela temporária.

WITH ativos_por_cliente AS (
    SELECT
        cliente_id,
        COUNT(ativo_id) AS total_ativos
    FROM ativos
    GROUP BY cliente_id
)

SELECT
    cliente_id,
    total_ativos
FROM ativos_por_cliente
WHERE total_ativos > 10;

-- Utilização no dia a dia:
-- Estrutura semelhante foi utilizada para calcular a quantidade
-- de ativos por cliente, informação essencial para análises
-- financeiras, cobrança e auditoria de contratos.


