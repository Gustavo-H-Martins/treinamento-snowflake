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
