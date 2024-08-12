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
