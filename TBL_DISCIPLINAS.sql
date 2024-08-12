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
