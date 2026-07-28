-- 1. Criação das Tabelas e Índices
CREATE TABLE mesas (
                       id BIGSERIAL PRIMARY KEY,
                       numero INTEGER NOT NULL UNIQUE,
                       descricao VARCHAR(100),
                       capacidade INTEGER NOT NULL DEFAULT 4,
                       status VARCHAR(20) NOT NULL DEFAULT 'LIVRE',
                       CHECK (status IN ('LIVRE', 'OCUPADA', 'RESERVADA', 'INATIVA'))
);

CREATE TABLE categorias_produtos (
                                     id BIGSERIAL PRIMARY KEY,
                                     nome VARCHAR(100) NOT NULL UNIQUE,
                                     ativa BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE produtos (
                          id BIGSERIAL PRIMARY KEY,
                          categoria_id BIGINT NOT NULL REFERENCES categorias_produtos(id),
                          nome VARCHAR(150) NOT NULL,
                          descricao TEXT,
                          preco NUMERIC(10,2) NOT NULL CHECK (preco >= 0),
                          disponivel BOOLEAN NOT NULL DEFAULT TRUE,
                          tempo_preparo_minutos INTEGER,
                          criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          atualizado_em TIMESTAMP
);

CREATE INDEX idx_produtos_nome ON produtos(nome);
CREATE INDEX idx_produtos_categoria ON produtos(categoria_id);

CREATE TABLE pedidos (
                         id BIGSERIAL PRIMARY KEY,
                         mesa_id BIGINT NOT NULL REFERENCES mesas(id),
                         data_abertura TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                         data_fechamento TIMESTAMP,
                         status VARCHAR(30) NOT NULL DEFAULT 'ABERTO',
                         observacao TEXT,
                         CHECK (status IN ('ABERTO', 'EM_PREPARO', 'PRONTO', 'ENTREGUE', 'FECHADO', 'CANCELADO'))
);

CREATE INDEX idx_pedidos_mesa ON pedidos(mesa_id);
CREATE INDEX idx_pedidos_status ON pedidos(status);
CREATE INDEX idx_pedidos_data_abertura ON pedidos(data_abertura);

CREATE TABLE pedido_itens (
                              id BIGSERIAL PRIMARY KEY,
                              pedido_id BIGINT NOT NULL REFERENCES pedidos(id),
                              produto_id BIGINT NOT NULL REFERENCES produtos(id),
                              quantidade INTEGER NOT NULL CHECK (quantidade > 0),
                              preco_unitario NUMERIC(10,2) NOT NULL CHECK (preco_unitario >= 0),
                              observacao TEXT,
                              status VARCHAR(30) NOT NULL DEFAULT 'PENDENTE',
                              data_inicio_preparo TIMESTAMP,
                              data_pronto TIMESTAMP,
                              data_entrega TIMESTAMP,
                              CHECK (status IN ('PENDENTE', 'EM_PREPARO', 'PRONTO', 'ENTREGUE', 'CANCELADO'))
);

CREATE INDEX idx_pedido_itens_pedido ON pedido_itens(pedido_id);
CREATE INDEX idx_pedido_itens_produto ON pedido_itens(produto_id);
CREATE INDEX idx_pedido_itens_status ON pedido_itens(status);

CREATE TABLE pagamentos (
                            id BIGSERIAL PRIMARY KEY,
                            pedido_id BIGINT NOT NULL REFERENCES pedidos(id),
                            valor NUMERIC(10,2) NOT NULL CHECK (valor >= 0),
                            forma_pagamento VARCHAR(30) NOT NULL,
                            status VARCHAR(30) NOT NULL DEFAULT 'PENDENTE',
                            codigo_transacao_externa VARCHAR(100),
                            data_pagamento TIMESTAMP,
                            criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                            CHECK (forma_pagamento IN ('DINHEIRO', 'CARTAO_CREDITO', 'CARTAO_DEBITO', 'PIX')),
                            CHECK (status IN ('PENDENTE', 'APROVADO', 'RECUSADO', 'CANCELADO'))
);

CREATE INDEX idx_pagamentos_pedido ON pagamentos(pedido_id);
CREATE INDEX idx_pagamentos_status ON pagamentos(status);

CREATE TABLE fechamentos_conta (
                                   id BIGSERIAL PRIMARY KEY,
                                   pedido_id BIGINT NOT NULL UNIQUE REFERENCES pedidos(id),
                                   subtotal NUMERIC(10,2) NOT NULL CHECK (subtotal >= 0),
                                   taxa_servico NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (taxa_servico >= 0),
                                   desconto NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (desconto >= 0),
                                   total NUMERIC(10,2) NOT NULL CHECK (total >= 0),
                                   data_fechamento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Inserção de Dados Iniciais (Seeding)
INSERT INTO mesas (numero, descricao, capacidade) VALUES
                                                      (1, 'Mesa próxima à entrada', 4),
                                                      (2, 'Mesa central', 4),
                                                      (3, 'Mesa próxima à janela', 2),
                                                      (4, 'Mesa família', 6),
                                                      (5, 'Mesa externa', 4);

INSERT INTO categorias_produtos (nome) VALUES
                                           ('Entradas'),
                                           ('Pratos Principais'),
                                           ('Bebidas'),
                                           ('Sobremesas');

INSERT INTO produtos (categoria_id, nome, descricao, preco, tempo_preparo_minutos)
SELECT id, 'Batata Frita', 'Porção de batata frita crocante', 28.90, 15
FROM categorias_produtos WHERE nome = 'Entradas';

INSERT INTO produtos (categoria_id, nome, descricao, preco, tempo_preparo_minutos)
SELECT id, 'X-Burger Artesanal', 'Hambúrguer artesanal com queijo e molho especial', 34.90, 20
FROM categorias_produtos WHERE nome = 'Pratos Principais';

INSERT INTO produtos (categoria_id, nome, descricao, preco, tempo_preparo_minutos)
SELECT id, 'Filé com Fritas', 'Filé grelhado acompanhado de batatas fritas', 59.90, 30
FROM categorias_produtos WHERE nome = 'Pratos Principais';

INSERT INTO produtos (categoria_id, nome, descricao, preco, tempo_preparo_minutos)
SELECT id, 'Suco Natural', 'Suco natural da fruta', 12.00, 5
FROM categorias_produtos WHERE nome = 'Bebidas';

INSERT INTO produtos (categoria_id, nome, descricao, preco, tempo_preparo_minutos)
SELECT id, 'Pudim', 'Pudim tradicional da casa', 14.90, 5
FROM categorias_produtos WHERE nome = 'Sobremesas';