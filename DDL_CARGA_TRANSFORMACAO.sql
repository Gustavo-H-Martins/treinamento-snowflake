-- Criação do Database para armazenar nossas tabelas
CREATE DATABASE IF NOT EXISTS LAB_SNOWFLAKE;

-- Define o Database a ser utilizado 
USE DATABASE LAB_SNOWFLAKE;

-- Cria e define o esquema a ser utilizado
CREATE SCHEMA IF NOT EXISTS SCHEMA_LAB;

-- Criação da Tabela base de Alunos
CREATE OR REPLACE TABLE raw_alunos (
    nome STRING,
    disciplinas VARIANT,  -- Armazenará o JSON como VARIANT
    enderecos VARIANT,     -- Armazenará o JSON como VARIANT
    periodo STRING,
    data_matricula DATE,
    data_nascimento DATE,
    percentual_bolsa STRING,  -- Pode ser armazenado como STRING para manter o formato original
    valor_mensalidade FLOAT,
    data_prevista_conclusao DATE
);

-- Verifica o carregamento dos dados
SELECT * FROM raw_alunos;

-- Tabela de Alunos (trusted_alunos)
/*
     Contém dados mais diretos e detalhados sobre cada aluno, excluindo informações como disciplinas e endereços, que são tratadas em tabelas separadas.
*/
CREATE OR REPLACE TABLE trusted_alunos AS
SELECT 
    nome,
    periodo,
    data_matricula,
    data_nascimento,
    percentual_bolsa,
    valor_mensalidade,
    data_prevista_conclusao
FROM 
    raw_alunos;

SELECT * FROM trusted_alunos;

-- Tabela de Disciplinas (trusted_disciplinas)
/*
    Normaliza a relação de disciplinas de cada aluno, transformando a lista de disciplinas em várias linhas com um relacionamento um para muitos.
*/
CREATE OR REPLACE TABLE trusted_disciplinas AS
SELECT 
    nome,
    REPLACE(disciplina.value:disciplina, '"', '') AS disciplina,
    disciplina.value:disciplina_id AS disciplina_id
FROM 
    raw_alunos,
    LATERAL FLATTEN(input => parse_json(disciplinas)) AS disciplina;

SELECT * FROM trusted_disciplinas;

-- Tabela de Endereços (trusted_enderecos)
/*
     Armazena múltiplos endereços e emails associados a cada aluno, gerando múltiplas linhas para diferentes combinações de endereços e emails.
*/
CREATE OR REPLACE TABLE trusted_enderecos AS
SELECT 
    nome,
    REPLACE(endereco.value:rua, '"', '') AS rua,
    REPLACE(endereco.value:numero, '"', '') AS numero,
    REPLACE(endereco.value:bairro, '"', '') AS bairro,
    REPLACE(endereco.value:cidade, '"', '') AS cidade,
    REPLACE(endereco.value:estado, '"', '') AS estado,
    REPLACE(endereco.value:cep, '"', '') AS cep,
    REPLACE(email.value, '"', '') AS email
FROM 
    raw_alunos,
    LATERAL FLATTEN(input => PARSE_JSON(enderecos)) AS endereco,
    LATERAL FLATTEN(input => endereco.value:emails) AS email;

SELECT * FROM trusted_enderecos