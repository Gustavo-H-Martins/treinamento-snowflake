-- Análise dos Dados com SQL
/*
    Cálculo da média geral dos alunos considerando o percentual de bolsa e o valor da mensalidade
*/
-- Média Geral de Percentual de Bolsa
SELECT 
    AVG(TO_NUMBER(REPLACE(percentual_bolsa, '%', ''))) AS media_percentual_bolsa
FROM 
    trusted_alunos;


-- Faturamento Médio Baseado nas Mensalidades (após aplicação de bolsa)
SELECT 
    AVG(valor_mensalidade * (1 - TO_NUMBER(REPLACE(percentual_bolsa, '%', '')) / 100)) AS faturamento_medio
FROM 
    trusted_alunos;

-- Matérias Mais Populares
SELECT 
    disciplina, 
    COUNT(*) AS frequencia
FROM 
    trusted_disciplinas
GROUP BY 
    disciplina
ORDER BY 
    frequencia DESC;

/*
    Ativação do suporte a Python no Snowflake:
    Snowflake permite que você execute UDFs com Python usando o Snowpark. Certifique-se de que o suporte ao Snowpark para Python está ativado no seu Snowflake account.
*/

-- Criação da UDF em Python:
CREATE OR REPLACE FUNCTION mask_email(email STRING)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.8'
HANDLER = 'mask_email'
AS
$$
import re

def mask_email(email):
    # Máscara a parte antes do '@'
    local_part, domain = email.split('@')
    local_part_masked = local_part[0] + '*' * (len(local_part) - 2) + local_part[-1]
    
    # Máscara a parte após o '@', mantendo o domínio de nível superior (TLD)
    domain_name, tld = domain.rsplit('.', 1)
    domain_name_masked = domain_name[0] + '*' * (len(domain_name) - 2) + domain_name[-1]
    
    # Reconstrói o email mascarado
    masked_email = f"{local_part_masked}@{domain_name_masked}.{tld}"
    
    return masked_email
$$;

-- Aplicando diretamente a UDF `mask_email`
SELECT 
    nome, 
    mask_email(email) AS email_mascarado
FROM 
    trusted_enderecos;

