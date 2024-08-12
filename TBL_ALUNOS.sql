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
