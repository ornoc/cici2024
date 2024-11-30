-- RESPOSTA QUESTÃO 1
CREATE DATABASE EcommerceDB;

USE EcommerceDB;

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
('Bruna Soares', 'bruna@email.com', '2023-02-10');

INSERT INTO Produtos (NomeProduto, Categoria, Preco, Estoque) VALUES 
('Produto A', 'Categoria 1', 50.00, 100),
('Produto B', 'Categoria 2', 30.00, 50),
('Produto C', 'Categoria 3', 40.00, 180),
('Produto D', 'Categoria 4', 100.00, 50);

INSERT INTO Pedidos (ClienteID, DataPedido, Status) VALUES 
(1, '2023-03-01', 'Enviado'),
(2, '2023-03-05', 'Cancelado'),
(3, '2023-03-08', 'Enviado'),
(4, '2023-03-04', 'Cancelado');

INSERT INTO ItensPedido (PedidoID, ProdutoID, Quantidade, PrecoUnitario) VALUES 
(1, 1, 2, 50.00),
(2, 3, 1, 40.00),
(3, 4, 4, 100.00),
(4, 2, 1, 30.00);

INSERT INTO Pagamentos (PedidoID, ValorPago, DataPagamento, MetodoPagamento) VALUES 
(3, 400.00, '2023-03-08', 'Cartão'),
(1, 100.00, '2023-03-02', 'Cartão');

-- RESPOSTA QUESTÃO 2
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

-- RESPOSTA QUESTÃO 3
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

-- RESPOSTA QUESTÃO 4
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

-- RESPOSTA QUESTÃO 5
SELECT 
    P.NomeProduto, 
    P.Categoria, 
    P.Estoque
FROM 
    Produtos P
WHERE 
    P.Estoque < 100;

-- RESPOSTA QUESTÃO 6
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

-- RESPOSTA QUESTÃO 7
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

-- RESPOSTA QUESTÃO 8
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