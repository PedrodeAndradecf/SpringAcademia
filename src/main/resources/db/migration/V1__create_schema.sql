-- 1. CRIAÇÃO DAS TABELAS

CREATE TABLE alunos(
                       id BIGSERIAL PRIMARY KEY,
                       nome VARCHAR(150) NOT NULL,
                       data_nascimento DATE,
                       sexo VARCHAR(1) CHECK (sexo IN ('M', 'F')),
                       telefone VARCHAR(30),
                       celular VARCHAR(30),
                       email VARCHAR(150),
                       observacao TEXT,
                       endereco VARCHAR(150),
                       numero VARCHAR(20),
                       complemento VARCHAR(100),
                       bairro VARCHAR(100),
                       cidade VARCHAR(100),
                       estado VARCHAR(2),
                       cep VARCHAR(20),
                       criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       atualizado_em TIMESTAMP
);

CREATE TABLE modalidades(
                            id BIGSERIAL PRIMARY KEY,
                            nome VARCHAR(100) NOT NULL UNIQUE,
                            ativa BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE graduacoes(
                           id BIGSERIAL PRIMARY KEY,
                           modalidade_id BIGINT NOT NULL REFERENCES modalidades(id),
                           nome VARCHAR(100) NOT NULL,
                           UNIQUE (modalidade_id, nome)
);

CREATE TABLE planos(
                       id BIGSERIAL PRIMARY KEY,
                       modalidade_id BIGINT NOT NULL REFERENCES modalidades(id),
                       nome VARCHAR(100) NOT NULL,
                       valor_mensal NUMERIC(10,2) NOT NULL CHECK(valor_mensal >= 0),
                       ativo BOOLEAN NOT NULL DEFAULT TRUE,
                       UNIQUE (modalidade_id, nome)
);

CREATE TABLE matriculas(
                           id BIGSERIAL PRIMARY KEY,
                           aluno_id BIGINT NOT NULL REFERENCES alunos(id),
                           data_matricula DATE NOT NULL DEFAULT CURRENT_DATE,
                           dia_vencimento INTEGER NOT NULL CHECK (dia_vencimento BETWEEN 1 AND 31),
                           data_encerramento DATE,
                           status VARCHAR(20) NOT NULL DEFAULT 'ATIVA',
                           CHECK (status IN ('ATIVA', 'ENCERRADA', 'CANCELADA'))
);

CREATE TABLE matriculas_modalidades(
                                       id BIGSERIAL PRIMARY KEY,
                                       matricula_id BIGINT NOT NULL REFERENCES matriculas(id),
                                       modalidade_id BIGINT NOT NULL REFERENCES modalidades(id),
                                       graduacao_id BIGINT REFERENCES graduacoes(id), -- CORREÇÃO: Removido o NOT NULL para permitir modalidades sem graduação (ex: musculação)
                                       plano_id BIGINT NOT NULL REFERENCES planos(id),
                                       data_inicio DATE NOT NULL DEFAULT CURRENT_DATE,
                                       data_fim DATE,
                                       UNIQUE (matricula_id, modalidade_id)
);

CREATE TABLE faturas_matriculas(
                                   id BIGSERIAL PRIMARY KEY,
                                   matricula_id BIGINT NOT NULL REFERENCES matriculas(id),
                                   data_vencimento DATE NOT NULL,
                                   valor NUMERIC(10, 2) NOT NULL CHECK ( valor >= 0 ),
                                   data_pagamento TIMESTAMP,
                                   data_cancelamento DATE,
                                   status VARCHAR(20) NOT NULL DEFAULT 'ABERTA',
                                   CHECK ( status IN ('ABERTA', 'PAGA', 'CANCELADA', 'VENCIDA') ),
                                   UNIQUE (matricula_id, data_vencimento)
);

CREATE TABLE assiduidade(
                            id BIGSERIAL PRIMARY KEY,
                            matricula_id BIGINT NOT NULL REFERENCES matriculas(id),
                            data_entrada TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                            data_saida TIMESTAMP
);

-- 2. INSERÇÃO DE DADOS (SEEDING)

-- Criando alunos de teste para que as matrículas funcionem (IDs 1, 2 e 3)
INSERT INTO alunos (nome, sexo, email) VALUES
                                           ('João Silva', 'M', 'joao@email.com'),
                                           ('Maria Oliveira', 'F', 'maria@email.com'),
                                           ('Carlos Souza', 'M', 'carlos@email.com');

-- Modalidades, Planos e Graduações
INSERT INTO modalidades (nome) VALUES
                                   ('Musculação'),
                                   ('Funcional'),
                                   ('Jiu-Jitsu'),
                                   ('Muay Thai'),
                                   ('Pilates');

INSERT INTO planos (modalidade_id, nome, valor_mensal)
SELECT id, 'Mensal', 120.00 FROM modalidades WHERE nome = 'Musculação';

INSERT INTO planos (modalidade_id, nome, valor_mensal)
SELECT id, 'Trimestral', 330.00 FROM modalidades WHERE nome = 'Musculação';

INSERT INTO planos (modalidade_id, nome, valor_mensal)
SELECT id, 'Mensal', 150.00 FROM modalidades WHERE nome = 'Funcional';

INSERT INTO planos (modalidade_id, nome, valor_mensal)
SELECT id, 'Mensal', 180.00 FROM modalidades WHERE nome = 'Jiu-Jitsu';

INSERT INTO graduacoes (modalidade_id, nome)
SELECT id, 'Faixa Branca' FROM modalidades WHERE nome = 'Jiu-Jitsu';

INSERT INTO graduacoes (modalidade_id, nome)
SELECT id, 'Faixa Azul' FROM modalidades WHERE nome = 'Jiu-Jitsu';

INSERT INTO graduacoes (modalidade_id, nome)
SELECT id, 'Faixa Roxa' FROM modalidades WHERE nome = 'Jiu-Jitsu';

-- Matrículas
INSERT INTO matriculas (aluno_id, data_matricula, dia_vencimento, status)
VALUES (2, CURRENT_DATE - INTERVAL '90 days', 10, 'ATIVA');

INSERT INTO matriculas (aluno_id, data_matricula, dia_vencimento, status)
VALUES (3, CURRENT_DATE - INTERVAL '60 days', 15, 'ATIVA');

-- Matrículas Modalidades
INSERT INTO matriculas_modalidades(
    matricula_id,
    modalidade_id,
    plano_id,
    data_inicio
)
SELECT
    m.id,
    mo.id,
    p.id,
    CURRENT_DATE - INTERVAL '90 days'
FROM matriculas m
    JOIN modalidades mo ON mo.nome = 'Musculação'
    JOIN planos p ON p.modalidade_id = mo.id AND p.nome = 'Mensal'
WHERE m.aluno_id = 2;

INSERT INTO matriculas_modalidades(
    matricula_id,
    modalidade_id,
    graduacao_id,
    plano_id,
    data_inicio
)
SELECT
    m.id,
    mo.id,
    1, -- Faixa Branca
    p.id,
    CURRENT_DATE - INTERVAL '60 days'
FROM matriculas m
    JOIN modalidades mo ON mo.nome = 'Jiu-Jitsu'
    JOIN planos p ON p.modalidade_id = mo.id AND p.nome = 'Mensal'
WHERE m.aluno_id = 3;

-- Faturas
-- Fatura Paga 1 (Aluno 2)
INSERT INTO faturas_matriculas(
    matricula_id,
    data_vencimento,
    valor,
    data_pagamento,
    status
)
SELECT
    m.id,
    CURRENT_DATE - INTERVAL '60 days',
    120.00,
    CURRENT_TIMESTAMP - INTERVAL '58 days',
    'PAGA'
FROM matriculas m
WHERE m.aluno_id = 2;

-- Fatura Paga 2 (Aluno 2)
INSERT INTO faturas_matriculas(
    matricula_id,
    data_vencimento,
    valor,
    data_pagamento,
    status
)
SELECT
    m.id,
    CURRENT_DATE - INTERVAL '30 days',
    120.00,
    CURRENT_TIMESTAMP - INTERVAL '29 days',
    'PAGA'
FROM matriculas m
WHERE m.aluno_id = 2;

-- Fatura Aberta Atual (Aluno 2)
INSERT INTO faturas_matriculas(
    matricula_id,
    data_vencimento,
    valor,
    status
)
SELECT
    m.id,
    CURRENT_DATE - INTERVAL '10 days',
    120.00,
    'ABERTA'
FROM matriculas m
WHERE m.aluno_id = 2;

-- Fatura Paga (Aluno 3)
INSERT INTO faturas_matriculas(
    matricula_id,
    data_vencimento,
    valor,
    data_pagamento,
    status
)
SELECT
    m.id,
    CURRENT_DATE - INTERVAL '30 days',
    180.00,
    CURRENT_TIMESTAMP - INTERVAL '28 days',
    'PAGA'
FROM matriculas m
WHERE m.aluno_id = 3;

-- Fatura Aberta (Aluno 3 - Corrigido para não conflitar)
INSERT INTO faturas_matriculas(
    matricula_id,
    data_vencimento,
    valor,
    status
)
SELECT
    m.id,
    CURRENT_DATE + INTERVAL '15 days',
    180.00,
    'ABERTA'
FROM matriculas m
WHERE m.aluno_id = 3;