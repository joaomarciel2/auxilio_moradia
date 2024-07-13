-- Criando um database
CREATE DATABASE min_publico;

-- Comando para utilizar a database
USE min_publico;

-- Criando a tabela ministerio
CREATE TABLE ministerio
(dt_valor DATE NOT NULL,
cod_orgao INT NOT NULL,
nm_orgao VARCHAR(350) NOT NULL,
nm_uorg VARCHAR(500) NOT NULL,
nm_municipio_uorg VARCHAR(200) NOT NULL,
uf_uorg VARCHAR(3) NOT NULL,
mat_serv INT NOT NULL,
valor_auxilio DECIMAL(15,2)
);

-- Criando a tabela servidores
CREATE TABLE servidores
(dt_valor DATE NOT NULL,
cod_orgao INT NOT NULL,
mat_serv INT NOT NULL,
nm_servidor VARCHAR(500) NOT NULL,
grupo_cargo VARCHAR(250),
funcao_cargo VARCHAR(250) NOT NULL
);

-- Importando os dados na tabela ministerio
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/ministerios.csv'
INTO TABLE ministerio
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Ignora o cabeçalho do arquivo CSV

-- Importando os dados na tabela servidores
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/servidores.csv'
INTO TABLE servidores
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Ignora o cabeçalho do arquivo CSV
-----------------------