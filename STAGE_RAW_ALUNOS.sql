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
