-- PASSO 1: Criar o Banco de Dados
CREATE DATABASE ELogiWare;
USE ELogiWare;

-- PASSO 2: Criar Tabelas Básicas (sem dependências)
CREATE TABLE Armazenamento (
    ID_armazenamento INT PRIMARY KEY auto_increment,
    capacidade_total INT,
    capacidade_utilizada INT
);

CREATE TABLE Transportadora (
    ID_transportadora INT PRIMARY KEY auto_increment,
    nome_transportadora VARCHAR(100),
    contato_transportadora VARCHAR(15)
);

CREATE TABLE Fornecedor(
    ID_fornecedor INT PRIMARY KEY auto_increment,
    nome_fornecedor VARCHAR(100),
    contato_fornecedor VARCHAR(15)
);

CREATE TABLE Cliente (
    ID_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome_cliente VARCHAR(100),
    endereco VARCHAR(200),
    contato VARCHAR(15)
);

-- PASSO 3: Criar Tabela Pedido com chaves estrangeiras
CREATE TABLE Pedido (
    ID_pedido INT PRIMARY KEY auto_increment,
    data_pedido DATE,
    status_pedido VARCHAR(30),
    ID_cliente INT,
    ID_transportadora INT,
    FOREIGN KEY (ID_cliente) REFERENCES Cliente(ID_cliente),
    FOREIGN KEY (ID_transportadora) REFERENCES Transportadora(ID_transportadora)
);

-- PASSO 4: Criar Tabela Produto
CREATE TABLE Produto (
    ID_produto INT PRIMARY KEY auto_increment,
    descricao varchar (100),
    qtd_estoque INT,
    local_armazenamento INT,
    FOREIGN KEY (local_armazenamento) REFERENCES Armazenamento(ID_armazenamento)
);

-- PASSO 5: Criar Tabelas Associativas
CREATE TABLE Pedido_Produto (
    ID_pedido_produto INT PRIMARY KEY AUTO_INCREMENT,
    ID_pedido INT,
    ID_produto INT,
    quantidade INT,
    FOREIGN KEY (ID_pedido) REFERENCES Pedido(ID_pedido),
    FOREIGN KEY (ID_produto) REFERENCES Produto(ID_produto)
);

CREATE TABLE Produto_Fornecedor (
    ID_produto INT,
    ID_fornecedor INT,
    PRIMARY KEY (ID_produto, ID_fornecedor),
    FOREIGN KEY (ID_produto) REFERENCES Produto(ID_produto),
    FOREIGN KEY (ID_fornecedor) REFERENCES Fornecedor(ID_fornecedor)
);

-- PASSO 6: Criar Tabela de Histórico
CREATE TABLE Historico_Movimentacao (
    ID_movimentacao INT PRIMARY KEY AUTO_INCREMENT,
    ID_produto INT,
    tipo_movimentacao ENUM('Entrada', 'Saída'),
    quantidade INT,
    data_movimentacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    motivo VARCHAR(100),
    FOREIGN KEY (ID_produto) REFERENCES Produto(ID_produto)
);

-- PASSO 7: Inserir Dados em Armazenamento
INSERT INTO Armazenamento (capacidade_total, capacidade_utilizada)
VALUES 
    (1000, 500),
    (2000, 600),
    (3000, 700),
    (4000, 800),
    (100, 100);

-- PASSO 8: Inserir Dados em Cliente
INSERT INTO Cliente (nome_cliente, endereco, contato)
VALUES 
    ('Construtora ABC', 'Av. Paulista, 1000, São Paulo-SP', '(11) 3456-7890'),
    ('Obras & Reformas Ltda', 'Rua da Consolação, 250, São Paulo-SP', '(11) 2345-6789'),
    ('Engenharia Moderna', 'Av. Brasil, 500, Rio de Janeiro-RJ', '(21) 3456-7890'),
    ('Construções Rápidas', 'Rua Quinze, 100, Curitiba-PR', '(41) 3456-7890');

-- PASSO 9: Inserir Dados em Transportadora
INSERT INTO Transportadora (nome_transportadora, contato_transportadora)
VALUES 
    ('Correios', '(13) 94321-5528'),
    ('MercadoLivre', '(21) 95678-9856'),
    ('TheFlash', '(31) 96789-5322'),
    ('Covre', '(41) 98745-4628');

-- PASSO 10: Inserir Dados em Fornecedor
INSERT INTO Fornecedor (nome_fornecedor, contato_fornecedor)
VALUES 
    ('Bosch', '(11) 91234-5678'),
    ('Makita', '(21) 98765-4321'),
    ('DeWalt', '(31) 99876-5432'),
    ('BlackDecker', '(41) 99123-4567');

-- PASSO 11: Inserir Dados em Pedido
INSERT INTO Pedido (data_pedido, status_pedido, ID_cliente, ID_transportadora)
VALUES 
    ('2025-08-12', 'Pendente', 1, 2),
    ('2025-07-10', 'Enviado', 2, 1),
    ('2025-05-20', 'Enviado', 3, 3),
    ('2025-05-10', 'Entregue', 4, 4),
    ('2025-01-01', 'Pendente', 1, 3);

-- PASSO 12: Inserir Dados em Produto
INSERT INTO Produto (descricao, qtd_estoque, local_armazenamento)
VALUES 
    ('Furadeira', 500, 1),
    ('Esmerilhadeira grande', 600, 2),
    ('Serra marmore', 700, 3),
    ('Vibrador de concreto', 800, 4),
    ('Esmerilhadeira pequena', 100, 5);

-- PASSO 13: Inserir Dados nas Tabelas Associativas
INSERT INTO Pedido_Produto (ID_pedido, ID_produto, quantidade)
VALUES 
    (1, 1, 5),
    (1, 3, 2),
    (2, 2, 10),
    (3, 4, 1),
    (4, 5, 20),
    (5, 1, 3);

INSERT INTO Produto_Fornecedor (ID_produto, ID_fornecedor)
VALUES 
    (1, 1), -- Furadeira da Bosch
    (2, 2), -- Esmerilhadeira grande da Makita
    (3, 3), -- Serra mármore da DeWalt
    (4, 4), -- Vibrador de concreto da BlackDecker
    (5, 2); -- Esmerilhadeira pequena da Makita

-- PASSO 14: Inserir Dados no Histórico de Movimentação
INSERT INTO Historico_Movimentacao (ID_produto, tipo_movimentacao, quantidade, motivo)
VALUES 
    (1, 'Entrada', 500, 'Estoque inicial'),
    (2, 'Entrada', 600, 'Estoque inicial'),
    (3, 'Entrada', 700, 'Estoque inicial'),
    (4, 'Entrada', 800, 'Estoque inicial'),
    (5, 'Entrada', 100, 'Estoque inicial');

-- PASSO 15: Criar Procedimentos Armazenados para Gestão de Pedidos
DELIMITER //
CREATE PROCEDURE registrar_pedido(
    IN p_id_cliente INT,
    IN p_id_transportadora INT,
    IN p_status_pedido VARCHAR(30)
)
BEGIN
    DECLARE novo_id_pedido INT;
    
    -- Inserir novo pedido
    INSERT INTO Pedido (data_pedido, status_pedido, ID_cliente, ID_transportadora)
    VALUES (CURRENT_DATE(), p_status_pedido, p_id_cliente, p_id_transportadora);
    
    SET novo_id_pedido = LAST_INSERT_ID();
    
    SELECT novo_id_pedido AS ID_Pedido_Criado;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE adicionar_item_pedido(
    IN p_id_pedido INT,
    IN p_id_produto INT,
    IN p_quantidade INT
)
BEGIN
    DECLARE estoque_atual INT;
    
    -- Verificar estoque disponível
    SELECT qtd_estoque INTO estoque_atual 
    FROM Produto 
    WHERE ID_produto = p_id_produto;
    
    IF estoque_atual >= p_quantidade THEN
        -- Adicionar item ao pedido
        INSERT INTO Pedido_Produto (ID_pedido, ID_produto, quantidade)
        VALUES (p_id_pedido, p_id_produto, p_quantidade);
        
        -- Atualizar estoque do produto
        UPDATE Produto 
        SET qtd_estoque = qtd_estoque - p_quantidade
        WHERE ID_produto = p_id_produto;
        
        -- Registrar movimentação no histórico
        INSERT INTO Historico_Movimentacao (ID_produto, tipo_movimentacao, quantidade, motivo)
        VALUES (p_id_produto, 'Saída', p_quantidade, CONCAT('Pedido #', p_id_pedido));
        
        SELECT 'Item adicionado com sucesso ao pedido' AS Resultado;
    ELSE
        SELECT 'Erro: Estoque insuficiente' AS Resultado;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE atualizar_status_pedido(
    IN p_id_pedido INT,
    IN p_novo_status VARCHAR(30)
)
BEGIN
    UPDATE Pedido
    SET status_pedido = p_novo_status
    WHERE ID_pedido = p_id_pedido;
    
    SELECT CONCAT('Status do pedido #', p_id_pedido, ' atualizado para: ', p_novo_status) AS Resultado;
END //
DELIMITER ;

-- PASSO 16: Criar Procedimentos para Gestão de Estoque
DELIMITER //
CREATE PROCEDURE receber_produtos(
    IN p_id_produto INT,
    IN p_quantidade INT,
    IN p_id_fornecedor INT
)
BEGIN
    DECLARE capacidade_atual INT;
    DECLARE capacidade_max INT;
    DECLARE local_atual INT;
    
    -- Obter local de armazenamento do produto
    SELECT local_armazenamento INTO local_atual
    FROM Produto
    WHERE ID_produto = p_id_produto;
    
    -- Verificar capacidade
    SELECT capacidade_total, capacidade_utilizada 
    INTO capacidade_max, capacidade_atual
    FROM Armazenamento
    WHERE ID_armazenamento = local_atual;
    
    IF (capacidade_atual + p_quantidade) <= capacidade_max THEN
        -- Atualizar estoque do produto
        UPDATE Produto 
        SET qtd_estoque = qtd_estoque + p_quantidade
        WHERE ID_produto = p_id_produto;
        
        -- Atualizar capacidade utilizada
        UPDATE Armazenamento
        SET capacidade_utilizada = capacidade_utilizada + p_quantidade
        WHERE ID_armazenamento = local_atual;
        
        -- Registrar movimentação no histórico
        INSERT INTO Historico_Movimentacao (ID_produto, tipo_movimentacao, quantidade, motivo)
        VALUES (p_id_produto, 'Entrada', p_quantidade, CONCAT('Recebimento de fornecedor #', p_id_fornecedor));
        
        SELECT 'Produtos recebidos com sucesso' AS Resultado;
    ELSE
        SELECT 'Erro: Capacidade de armazenamento excedida' AS Resultado;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE alocar_produto_armazenamento(
    IN p_id_produto INT,
    IN p_novo_local INT
)
BEGIN
    DECLARE local_antigo INT;
    DECLARE qtd_produto INT;
    DECLARE capacidade_antiga INT;
    DECLARE capacidade_nova INT;
    DECLARE capacidade_max_nova INT;
    
    -- Obter informações atuais
    SELECT local_armazenamento, qtd_estoque INTO local_antigo, qtd_produto
    FROM Produto
    WHERE ID_produto = p_id_produto;
    
    -- Verificar capacidade do novo local
    SELECT capacidade_utilizada, capacidade_total 
    INTO capacidade_nova, capacidade_max_nova
    FROM Armazenamento
    WHERE ID_armazenamento = p_novo_local;
    
    IF (capacidade_nova + qtd_produto) <= capacidade_max_nova THEN
        -- Atualizar capacidade do local antigo
        UPDATE Armazenamento
        SET capacidade_utilizada = capacidade_utilizada - qtd_produto
        WHERE ID_armazenamento = local_antigo;
        
        -- Atualizar capacidade do novo local
        UPDATE Armazenamento
        SET capacidade_utilizada = capacidade_utilizada + qtd_produto
        WHERE ID_armazenamento = p_novo_local;
        
        -- Atualizar local de armazenamento do produto
        UPDATE Produto
        SET local_armazenamento = p_novo_local
        WHERE ID_produto = p_id_produto;
        
        SELECT CONCAT('Produto realocado com sucesso para o armazenamento #', p_novo_local) AS Resultado;
    ELSE
        SELECT 'Erro: Capacidade insuficiente no novo local' AS Resultado;
    END IF;
END //
DELIMITER ;

-- PASSO 17: Criar Procedimentos e Views para Consultas
DELIMITER //
CREATE PROCEDURE verificar_disponibilidade_produto(
    IN p_id_produto INT
)
BEGIN
    SELECT 
        p.ID_produto,
        p.descricao,
        p.qtd_estoque,
        a.ID_armazenamento,
        a.capacidade_total,
        a.capacidade_utilizada,
        (p.qtd_estoque > 0) AS disponivel
    FROM 
        Produto p
    JOIN 
        Armazenamento a ON p.local_armazenamento = a.ID_armazenamento
    WHERE 
        p.ID_produto = p_id_produto;
END //
DELIMITER ;

CREATE VIEW relatorio_estoque AS
SELECT 
    p.ID_produto,
    p.descricao,
    p.qtd_estoque,
    a.ID_armazenamento,
    a.capacidade_total,
    a.capacidade_utilizada,
    ROUND((a.capacidade_utilizada / a.capacidade_total * 100), 2) AS percentual_ocupacao,
    f.nome_fornecedor AS fornecedor_principal
FROM 
    Produto p
JOIN 
    Armazenamento a ON p.local_armazenamento = a.ID_armazenamento
LEFT JOIN 
    Produto_Fornecedor pf ON p.ID_produto = pf.ID_produto
LEFT JOIN 
    Fornecedor f ON pf.ID_fornecedor = f.ID_fornecedor;

CREATE VIEW relatorio_pedidos AS
SELECT 
    pe.ID_pedido,
    pe.data_pedido,
    pe.status_pedido,
    c.nome_cliente,
    c.contato AS contato_cliente,
    t.nome_transportadora,
    t.contato_transportadora,
    COUNT(pp.ID_produto) AS total_itens,
    SUM(pp.quantidade) AS total_produtos
FROM 
    Pedido pe
JOIN 
    Cliente c ON pe.ID_cliente = c.ID_cliente
JOIN 
    Transportadora t ON pe.ID_transportadora = t.ID_transportadora
LEFT JOIN 
    Pedido_Produto pp ON pe.ID_pedido = pp.ID_pedido
GROUP BY 
    pe.ID_pedido, pe.data_pedido, pe.status_pedido, c.nome_cliente, 
    c.contato, t.nome_transportadora, t.contato_transportadora;

CREATE VIEW historico_movimentacoes AS
SELECT 
    h.ID_movimentacao,
    p.descricao AS produto,
    h.tipo_movimentacao,
    h.quantidade,
    h.data_movimentacao,
    h.motivo
FROM 
    Historico_Movimentacao h
JOIN 
    Produto p ON h.ID_produto = p.ID_produto
ORDER BY 
    h.data_movimentacao DESC;

DELIMITER //
CREATE PROCEDURE relatorio_produtos_baixo_estoque(
    IN p_limite_min INT
)
BEGIN
    SELECT 
        p.ID_produto,
        p.descricao,
        p.qtd_estoque,
        f.nome_fornecedor,
        f.contato_fornecedor
    FROM 
        Produto p
    LEFT JOIN 
        Produto_Fornecedor pf ON p.ID_produto = pf.ID_produto
    LEFT JOIN 
        Fornecedor f ON pf.ID_fornecedor = f.ID_fornecedor
    WHERE 
        p.qtd_estoque <= p_limite_min
    ORDER BY 
        p.qtd_estoque ASC;
END //
DELIMITER ;

-- PASSO 18: Criar Triggers para Integridade de Dados
DELIMITER //
CREATE TRIGGER verificar_capacidade_insert
BEFORE INSERT ON Produto
FOR EACH ROW
BEGIN
    DECLARE capacidade_disponivel INT;
    
    SELECT (capacidade_total - capacidade_utilizada) INTO capacidade_disponivel
    FROM Armazenamento
    WHERE ID_armazenamento = NEW.local_armazenamento;
    
    IF NEW.qtd_estoque > capacidade_disponivel THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Capacidade de armazenamento excedida';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER atualizar_capacidade_update
AFTER UPDATE ON Produto
FOR EACH ROW
BEGIN
    IF OLD.qtd_estoque != NEW.qtd_estoque THEN
        -- Atualizar capacidade utilizada
        UPDATE Armazenamento
        SET capacidade_utilizada = capacidade_utilizada + (NEW.qtd_estoque - OLD.qtd_estoque)
        WHERE ID_armazenamento = NEW.local_armazenamento;
    END IF;
END //
DELIMITER ;

-- PASSO 19: Criar Usuários e Conceder Privilégios
CREATE USER IF NOT EXISTS 'admin_armazem'@'localhost' IDENTIFIED BY 'senha_segura_admin';
CREATE USER IF NOT EXISTS 'operador_estoque'@'localhost' IDENTIFIED BY 'senha_segura_operador';
CREATE USER IF NOT EXISTS 'consulta_apenas'@'localhost' IDENTIFIED BY 'senha_segura_consulta';

-- Conceder privilégios ao administrador (acesso total)
GRANT ALL PRIVILEGES ON ELogiWare.* TO 'admin_armazem'@'localhost';

-- Conceder privilégios limitados ao operador de estoque
GRANT SELECT, INSERT, UPDATE ON ELogiWare.Produto TO 'operador_estoque'@'localhost';
GRANT SELECT, INSERT ON ELogiWare.Historico_Movimentacao TO 'operador_estoque'@'localhost';
GRANT SELECT ON ELogiWare.Armazenamento TO 'operador_estoque'@'localhost';
GRANT EXECUTE ON PROCEDURE ELogiWare.receber_produtos TO 'operador_estoque'@'localhost';
GRANT EXECUTE ON PROCEDURE ELogiWare.verificar_disponibilidade_produto TO 'operador_estoque'@'localhost';

-- Conceder privilégios apenas de consulta
GRANT SELECT ON ELogiWare.relatorio_estoque TO 'consulta_apenas'@'localhost';
GRANT SELECT ON ELogiWare.relatorio_pedidos TO 'consulta_apenas'@'localhost';
GRANT SELECT ON ELogiWare.historico_movimentacoes TO 'consulta_apenas'@'localhost';

-- Aplicar alterações de privilégios
FLUSH PRIVILEGES;

-- PASSO 20: Testar o Sistema com Consultas
-- Verificar o estoque atual
SELECT * FROM relatorio_estoque;

-- Verificar os pedidos
SELECT * FROM relatorio_pedidos;

-- Verificar o histórico de movimentações
SELECT * FROM historico_movimentacoes;

-- Criar um novo pedido
CALL registrar_pedido(2, 3, 'Novo');

-- Adicionar um item ao pedido (Substitua 6 pelo ID do pedido criado acima se for diferente)
CALL adicionar_item_pedido(6, 1, 10);

-- Atualizar o status do pedido
CALL atualizar_status_pedido(6, 'Em processamento');

-- Receber produtos de um fornecedor
CALL receber_produtos(1, 100, 1);

-- Verificar produtos com baixo estoque
CALL relatorio_produtos_baixo_estoque(200);

-- Realocar um produto para outro local de armazenamento
CALL alocar_produto_armazenamento(5, 1);