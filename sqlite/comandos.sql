-- Gere o script DDL de cria��o das 4 tabelas;
CREATE TABLE IF NOT EXISTS clientes (
	id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_cliente VARCHAR(100),
	sexo VARCHAR(10),
	data_nascimento TIMESTAMP,
	endereco VARCHAR(100),
	cidade VARCHAR(50),
	estado VARCHAR (50),
	email VARCHAR (100),
	telefone_residencial VARCHAR (20),
	telefone_celular VARCHAR (20)
);


CREATE TABLE IF NOT EXISTS funcionario (
	id_funcionario INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_funcionario VARCHAR(100),
	sexo VARCHAR(10),
	data_nascimento TIMESTAMP,
	endereco VARCHAR(100),
	cidade VARCHAR(100),
	estado VARCHAR (50),
	email VARCHAR (100),
	telefone_residencial VARCHAR (20),
	telefone_celular VARCHAR (20),
	id_gestor INTEGER,
	FOREIGN KEY (id_gestor) REFERENCES funcionario(id_funcionario)
);


CREATE TABLE IF NOT EXISTS produtos (
	id_produto INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_produto VARCHAR(100),
	categoria_produto VARCHAR(100),
	preco_base FLOAT,
	lote_minimmo INTEGER
);


CREATE TABLE IF NOT EXISTS vendas (
	id_venda INTEGER PRIMARY KEY AUTOINCREMENT,
	id_cliente INTEGER,
	id_produto INTEGER,
	id_vendedor INTEGER,
	data_venda TIMESTAMP,
	quantidade INTEGER,
	valor_venda FLOAT,
	FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
	FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
	FOREIGN KEY (id_vendedor) REFERENCES funcionario(od_funcionario)
);


-- Gere um script DML que execute um INSERT na tabela produtos
INSERT INTO produtos (nome_produto, categoria_produto, preco_base, lote_minimmo) VALUES ('Smartphone Samsung S23 U Ultra', 'Telefonia', 9000.50, 1)

INSERT INTO clientes (nome_cliente, sexo, data_nascimento, endereco, cidade, estado, email, telefone_residencial, telefone_celular) VALUES ('Victor Sales', 'Masculino', '1990-05-14 10:50:00', 'Belo Horizonte', 'Belo Horizonte', 'Minas Gerais', 'email@dataway.com.br', '(31) 0000000', '(31) 00000000'  )


INSERT INTO funcionario (nome_funcionario, sexo, data_nascimento, endereco, cidade, estado, email, telefone_residencial, telefone_celular, id_gestor) VALUES 
('funcionario1', 'Masculino', '1985-05-17', 'Rua XPTO', 'Belo Horizonte', 'Minas Gerais', 'funcionaria1@teste.com.br', '3131313050', '31995555555', null ),
('funcionario2', 'Masculino', '1998-09-12', 'Rua Flor de Liz', 'Contagem', 'Minas Gerais', 'funcionario2@teste.com.br', '3140405555', '31997755555', null ),
('funcionario3', 'Feminino', '1994-12-01', 'Rua dos Caet�s', 'Belo Horizonte', 'Minas Gerais', 'funcionario3@teste.com.br', '3130503050', '31975757575', null )



SELECT *
FROM funcionario f 

SELECT nome_funcionario email
FROM funcionario f 

SELECT COUNT(*) 
FROM funcionario f 

SELECT cidade, COUNT(*) as qtde
FROM funcionario f 
GROUP BY cidade 

-- Retorne a quantidade e a soma de todas as vendas por usuario
SELECT id_cliente, 
	COUNT(*) AS quantidade,
	SUM(quantidade) AS soma_vendas
FROM vendas
GROUP BY id_cliente 

-- Retorne o total de vendas realizadas por funcionario
SELECT id_vendedor,
	COUNT(*) AS qtd_vendas
FROM vendas
GROUP BY id_vendedor 

-- Retorne o nome e a quantidade de vendas realizadas dos usuarios cuja soma das vendas � maior pi igual � 150000.00
SELECT 	nome_cliente,
		COUNT(*) AS quantidade
FROM 	vendas
	INNER JOIN clientes
		ON vendas.id_cliente = clientes.id_cliente 
GROUP BY nome_cliente
HAVING	SUM(valor_venda) >= 150000.00

-- Retorne, ordenando poelo maior valor de venda, o nome, email e o maior valor pago dos usuarios que j� realizaram alguma compra
SELECT	nome_cliente,
		email,
		valor_venda
FROM vendas
	INNER JOIN clientes
		ON vendas.id_cliente = clientes.id_cliente 
ORDER BY vendas.valor_venda DESC 


-- Retorne o nome do funcionario, o nome do cliente, o nome do produto, a data da venda, a quantidade compra e o valor da compra dos clientes que j� fizeram alguma compra
SELECT	funcionario.nome_funcionario,
		clientes.nome_cliente,
		produtos.nome_produto,
		vendas.data_venda,
		vendas.quantidade,
		vendas.valor_venda 
FROM 	vendas
	INNER JOIN clientes
		ON vendas.id_cliente = clientes.id_cliente 
	INNER JOIN produtos
		ON vendas.id_produto = produtos.id_produto
	INNER JOIN funcionario
		ON vendas.id_vendedor = funcionario.id_funcionario 


-- Retorne o nome dos funcionarios que j� atenderam o mesmo cliente em mais de uma compra
SELECT 		DISTINCT funcionario.nome_funcionario
FROM 		(
				SELECT		id_vendedor,
							id_cliente,
							COUNT(*)
				FROM		vendas
				GROUP BY	id_vendedor,
							id_cliente
				HAVING		COUNT(*) > 1
			) AS compras
	INNER JOIN funcionario
		ON compras.id_vendedor = funcionario.id_funcionario 


-- Retorne os dados dos clientes que nunca realizaram nenhuma compra
SELECT	*
FROM 	clientes
WHERE 	id_cliente NOT IN (SELECT DISTINCT id_cliente FROM vendas);	
	
-- Retorne quais s�o os produtos mais comprados pelos clientes
SELECT		nome_produto,
			(
				SELECT		COUNT(*)
				FROM 		vendas
				WHERE 		id_produto = P.id_produto
			) AS qtd_compras
FROM 		produtos P
ORDER BY 	qtd_compras DESC
		
-- Retorne quem sao os clientes que realizaram mais de 3 compras nos ultimos 2 meses
SELECT 		*
FROM 		clientes
WHERE		id_cliente IN 	(
								SELECT 		id_cliente 
								FROM 		vendas
								WHERE 		data_venda >= '2023-10-01'
								GROUP BY 	id_cliente
								HAVING 		COUNT(*) > 3
							)
							
							






