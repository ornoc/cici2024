-- RESPOSTA QUESTÃO 1
CREATE DATABASE E_commerceDB;

USE E_commerceDB;

CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100),
    Email VARCHAR(100),
    DataCadastro DATE
);

CREATE TABLE Produtos (
    ProdutoID INT PRIMARY KEY AUTO_INCREMENT,
    NomeProduto VARCHAR(100),
    Categoria VARCHAR(50),
    Preco DECIMAL(10, 2),
    Estoque INT
);

CREATE TABLE Pedidos (
    PedidoID INT PRIMARY KEY AUTO_INCREMENT,
    ClienteID INT,
    DataPedido DATE,
    Status VARCHAR(20),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

CREATE TABLE ItensPedido (
    ItemID INT PRIMARY KEY AUTO_INCREMENT,
    PedidoID INT,
    ProdutoID INT,
    Quantidade INT,
    PrecoUnitario DECIMAL(10, 2),
    FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID),
    FOREIGN KEY (ProdutoID) REFERENCES Produtos(ProdutoID)
);

CREATE TABLE Pagamentos (
    PagamentoID INT PRIMARY KEY AUTO_INCREMENT,
    PedidoID INT,
    ValorPago DECIMAL(10, 2),
    DataPagamento DATE,
    MetodoPagamento VARCHAR(20),
    FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID)
);

INSERT INTO Clientes (Nome, Email, DataCadastro) VALUES 
('Caio Silva', 'caio@email.com', '2023-01-15'),
('Rodrigo Amarante', 'amarante@email.com', '2023-05-23'),
('Anna Julia', 'annaju@email.com', '2023-01-04'),
('Bruna Soares', 'bruna@email.com', '2023-02-10'),
('Miguel Peixoto', 'miguel@email.com', '2024-09-14'),
('Maria Oliveira', 'maria@email.com', '2024-11-13'),
('Elisa Barbosa', 'elisa@email.com', '2024-09-12'),
('Belchior Borba', 'belchior@email.com', '2024-08-11');


INSERT INTO Produtos (NomeProduto, Categoria, Preco, Estoque) VALUES 
('Chinelo', 'Calçados', 20.00, 100),
('Casaco', 'Roupas', 80.00, 50),
('joias', 'Acessórios', 40.00, 180),
('Geladeira', 'Eletrodomesticos', 3500.00, 150),
('Camiseta', 'Roupas', 49.99, 100),
('Notebook', 'Eletrônicos', 2999.99, 50),
('Smartphone', 'Eletrônicos', 1999.99, 30),
('Tênis', 'Calçados', 199.99, 200);

INSERT INTO Pedidos (ClienteID, DataPedido, Status) VALUES 
(1, '2023-03-01', 'Enviado'),
(2, '2023-03-05', 'Cancelado'),
(3, '2023-03-08', 'Enviado'),
(4, '2023-03-04', 'Cancelado'),
(5, '2024-09-14', 'Pendente'),
(6, '2024-09-13', 'Enviado'),
(7, '2024-09-13', 'Enviado'),
(8, '2024-09-12', 'Cancelado');

INSERT INTO ItensPedido (PedidoID, ProdutoID, Quantidade, PrecoUnitario) VALUES 
(1, 1, 5, 20.00),
(2, 3, 1, 40.00),
(3, 4, 4, 3500.00),
(4, 2, 1, 80.00),
(5, 5, 2, 49.99),
(6, 8, 1, 199.99),
(7, 6, 1, 2999.99),
(8, 7, 2, 1999.99);

INSERT INTO Pagamentos (PedidoID, ValorPago, DataPagamento, MetodoPagamento) VALUES 
(1, 100.00, '2023-03-01', 'Cartão'),
(3, 14000.00, '2023-03-08', 'Cartão'),
(6, 199.99, '2024-09-13', 'Boleto'),
(7, 2999.99, '2024-09-13', 'Transferência');

-- RESPOSTA QUESTAO 2
SELECT 
    P.NomeProduto, 
    SUM(IP.Quantidade) AS QuantTotalVendida, 
    SUM(IP.Quantidade * IP.PrecoUnitario) AS ValorTotal
FROM 
    ItensPedido IP
JOIN 
    Produtos P ON IP.ProdutoID = P.ProdutoID
GROUP BY 
    P.NomeProduto
ORDER BY 
    QuantTotalVendida DESC
LIMIT 5;

-- RESPOSTA QUESTAO 3
SELECT 
    C.Nome, 
    COUNT(P.PedidoID) AS TotalPedidos, 
    SUM(PG.ValorPago) AS ValorTotalGasto
FROM 
    Clientes C
JOIN 
    Pedidos P ON C.ClienteID = P.ClienteID
JOIN 
    Pagamentos PG ON P.PedidoID = PG.PedidoID
GROUP BY 
    C.Nome
ORDER BY 
    ValorTotalGasto DESC;

-- RESPOSTA QUESTAO 4
SELECT 
    YEAR(PG.DataPagamento) AS Ano, 
    MONTH(PG.DataPagamento) AS Mes, 
    SUM(PG.ValorPago) AS ReceitaTotal
FROM 
    Pagamentos PG
GROUP BY 
    Ano, Mes
ORDER BY 
    Ano DESC, Mes DESC;

-- RESPOSTA QUESTAO 5
SELECT 
    P.NomeProduto, 
    P.Categoria, 
    P.Estoque
FROM 
    Produtos P
WHERE 
    P.Estoque < 100;

-- RESPOSTA QUESTAO 6
SELECT 
    YEAR(P.DataPedido) AS Ano, 
    MONTH(P.DataPedido) AS Mes, 
    COUNT(P.PedidoID) AS PedidosCancelados
FROM 
    Pedidos P
WHERE 
    P.Status = 'Cancelado' 
    AND P.DataPedido >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY 
    Ano, Mes
ORDER BY 
    Ano DESC, Mes DESC;

-- RESPOSTA QUESTAO 7
SELECT 
    PG.MetodoPagamento, 
    COUNT(PG.PagamentoID) AS TotalTransacoes
FROM 
    Pagamentos PG
GROUP BY 
    PG.MetodoPagamento
ORDER BY 
    TotalTransacoes DESC
LIMIT 1;

-- RESPOSTA QUESTAO 8
SELECT 
    C.Nome, 
    MAX(P.DataPedido) AS UltimoPedido
FROM 
    Clientes C
JOIN 
    Pedidos P ON C.ClienteID = P.ClienteID
GROUP BY 
    C.Nome
HAVING 
    MAX(P.DataPedido) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);
