-- Criação da Tabela base de Alunos
CREATE OR REPLACE TABLE raw_alunos (
    nome STRING,
    disciplinas STRING,  -- Armazenará o JSON como string
    enderecos STRING,     -- Armazenará o JSON como string
    periodo STRING,
    data_matricula DATE,
    data_nascimento DATE,
    percentual_bolsa STRING,  -- Pode ser armazenado como STRING para manter o formato original
    valor_mensalidade FLOAT,
    data_prevista_conclusao DATE
);

-- Cria um estágio interno (opcional se você já tiver um estágio definido)
CREATE OR REPLACE STAGE raw_alunos_stage;

-- Carrega o arquivo CSV no estágio
SET caminho_do_arquivo = './alunos.csv';
PUT file://${caminho_do_arquivo} @raw_alunos_stage AUTO_COMPRESS=TRUE;

-- Copia os dados do CSV para a tabela raw_alunos
COPY INTO raw_alunos
FROM @raw_alunos_stage/alunos.csv.gz  -- Assumindo que o arquivo foi comprimido automaticamente
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1)
ON_ERROR = 'CONTINUE';  -- Opcional: Especifica o comportamento em caso de erros

-- Verifica o carregamento dos dados
SELECT * FROM raw_alunos;


-- Tabela de Alunos (trusted_alunos)
/*
     Contém dados mais diretos e detalhados sobre cada aluno, excluindo informações como disciplinas e endereços, que são tratadas em tabelas separadas.
*/
CREATE TABLE trusted_alunos AS
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


-- Tabela de Disciplinas (trusted_disciplinas)
/*
    Normaliza a relação de disciplinas de cada aluno, transformando a lista de disciplinas em várias linhas com um relacionamento um para muitos.
*/
CREATE TABLE trusted_disciplinas AS
SELECT 
    nome,
    disciplina::STRING AS disciplina,
    disciplina_id::INTEGER AS disciplina_id
FROM 
    raw_alunos,
    LATERAL FLATTEN(input => PARSE_JSON(disciplinas)) AS disciplina;


-- Tabela de Endereços (trusted_enderecos)
/*
     Armazena múltiplos endereços e emails associados a cada aluno, gerando múltiplas linhas para diferentes combinações de endereços e emails.
*/
CREATE TABLE trusted_enderecos AS
SELECT 
    nome,
    endereco.value:rua::STRING AS rua,
    endereco.value:numero::STRING AS numero,
    endereco.value:bairro::STRING AS bairro,
    endereco.value:cidade::STRING AS cidade,
    endereco.value:estado::STRING AS estado,
    endereco.value:cep::STRING AS cep,
    email.value::STRING AS email
FROM 
    raw_alunos,
    LATERAL FLATTEN(input => PARSE_JSON(enderecos)) AS endereco,
    LATERAL FLATTEN(input => endereco.value:emails) AS email;
