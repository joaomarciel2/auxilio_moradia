-- Total de auxílio-moradia por ano
SELECT
YEAR(dt_valor) as 'ano', -- comando YEAR() para pegar somente o ano da coluna 'dt_valor'
SUM(valor_auxilio) AS 'total_auxilio' -- Somando todo o valor do auxílio-moradia
FROM ministerio
GROUP BY YEAR(dt_valor); -- Agrupando por ano

-- 1. Qual é o valor total de auxílio-moradia pago por cada órgão público?
SELECT nm_orgao AS 'nome_orgao',
nm_municipio_uorg AS 'municipio',
uf_uorg AS 'estado', 
COUNT(DISTINCT mat_serv) AS 'numero_de_funcionarios', -- Contando de forma distinta os funcionários 
SUM(valor_auxilio) AS 'total_auxilio_moradia'
FROM ministerio
GROUP BY nm_orgao, nm_municipio_uorg, uf_uorg
ORDER BY total_auxilio_moradia DESC;

-- 2. Quais são os municípios com maior gasto total em auxílio-moradia?
SELECT nm_municipio_uorg AS 'municipio',
uf_uorg AS 'estado',
COUNT(DISTINCT mat_serv) AS 'numero_funcionarios', -- Contando de forma distinta os funcionários 
SUM(valor_auxilio) AS 'total_auxilio_moradia'
FROM ministerio
GROUP BY nm_municipio_uorg, uf_uorg
ORDER BY numero_funcionarios DESC;

-- 3. Qual é o cargo com maior média de auxílio-moradia?
SELECT 
S.funcao_cargo AS 'cargo',
ROUND(SUM(M.valor_auxilio) / COUNT(DISTINCT S.mat_serv), 2) AS 'media_valor_auxilio', -- Soma do auxílio-moradia dividido pela contagem distinta de funcionários
COUNT(DISTINCT S.mat_serv) AS 'numero_funcionarios'
FROM servidores S
INNER JOIN ministerio M -- Fazendo uma operação para retornar os resultados que possuem em ambas as tabelas.
ON S.mat_serv = M.mat_serv AND
S.cod_orgao = M.cod_orgao AND
S.dt_valor = M.dt_valor
GROUP BY S.funcao_cargo
HAVING COUNT(DISTINCT S.mat_serv) >= 100 -- Retornando somente os cargos que possuem 100 ou mais funcionários
ORDER BY media_valor_auxilio DESC;

-- 4. Qual é a distribuição de valores de auxílio-moradia por cargo?
SELECT
S.funcao_cargo AS 'cargo',
COUNT(*) AS 'quantidade', -- Contando o número de ocorrências de cada valor de auxílio-moradia para cada cargo
SUM(M.valor_auxilio) AS 'total_auxilio'
FROM servidores S
INNER JOIN ministerio M -- Fazendo uma operação para retornar os resultados que possuem em ambas as tabelas.
ON S.mat_serv = M.mat_serv 
AND S.cod_orgao = M.cod_orgao 
AND S.dt_valor = M.dt_valor
GROUP BY S.funcao_cargo
ORDER BY total_auxilio DESC;


-- 5. Quais são os 10 funcionários que tiveram os maiores recebimentos em auxilio-moradia?
SELECT
S.nm_servidor AS 'nome',
M.nm_orgao AS 'orgao',
S.funcao_cargo AS 'cargo',
DATE_FORMAT(MIN(M.dt_valor), '%Y-%m') AS 'primeira_data', -- comando DATE_FORMAT(..., '%Y-%m') que retornará somente o mês e ano juntos
DATE_FORMAT(MAX(M.dt_valor), '%Y-%m') AS 'ultima_data', -- comando DATE_FORMAT(..., '%Y-%m') que retornará somente o mês e ano juntos
SUM(M.valor_auxilio) AS 'valor_auxilio'
FROM servidores S
INNER JOIN ministerio M -- Fazendo uma operação para retornar os resultados que possuem em ambas as tabelas.
ON S.mat_serv = M.mat_serv 
AND S.cod_orgao = M.cod_orgao 
AND S.dt_valor = M.dt_valor
GROUP BY S.nm_servidor, S.funcao_cargo, M.nm_orgao
ORDER BY valor_auxilio DESC
LIMIT 10; -- Retornando somente os 10 maiores resultados


-- 6. Qual é o órgão público que paga o maior valor de auxílio-moradia para um único funcionário?
SELECT
DATE_FORMAT(M.dt_valor, '%Y-%m') AS 'mes_ano',
S.nm_servidor AS 'nome',
M.nm_orgao AS 'orgao',
S.funcao_cargo AS 'cargo',
M.valor_auxilio
FROM servidores S
INNER JOIN ministerio M
ON S.mat_serv = M.mat_serv 
AND S.cod_orgao = M.cod_orgao 
AND S.dt_valor = M.dt_valor
WHERE M.valor_auxilio =  -- Filtrando para retornar somente resultados que possuam o valor de auxílio-moradia igual ao maior valor registrado
( SELECT MAX(valor_auxilio) -- Subquery que retorna o maior valor de auxílio-moradia
FROM ministerio 
)
ORDER BY mes_ano DESC;


-- 7. Qual é a proporção de funcionários que recebem auxílio-moradia em cada unidade organizacional?
SELECT
f1.nm_uorg,
f1.total_funcionarios,
COALESCE(f2.funcionarios_com_auxilio, 0) AS 'funcionario_com_auxilio', -- Caso tenha valor diferente de NULL, ele retornará o valor. Se estiver NULL, ele retornará como 0.
ROUND((COALESCE(f2.funcionarios_com_auxilio, 0) / f1.total_funcionarios) * 100, 2) AS proporcao -- função ROUND() para arredondar os valores com quantas casas decimais quiser.
FROM (
SELECT
nm_uorg,
COUNT(*) AS total_funcionarios
FROM ministerio
GROUP BY nm_uorg) AS f1
LEFT JOIN (
SELECT
nm_uorg,
COUNT(*) AS 'funcionarios_com_auxilio'
FROM ministerio
WHERE valor_auxilio > 0
GROUP BY nm_uorg) AS f2
ON f1.nm_uorg = f2.nm_uorg
ORDER BY proporcao DESC;
