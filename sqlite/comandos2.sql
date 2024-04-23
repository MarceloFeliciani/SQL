/* ###### DESAFIO 01 ######
 Registros do campo Email da tabela Customers onde o dom�nio seja da apple*/
/*O operador LIKE usa caracteres curingas para localizar strings numa coluna*/
SELECT Email FROM Customer WHERE Email LIKE '%@apple%' 



/* ###### DESAFIO 02 ######
 registros onde o primeiro caracter seja o "A" e o terceiro "e" da coluna FirstName */
/* O m�todo SUBSTRING() est� comparando os �ndices inicial e final da coluna FirstName, e retornando a string encontrada */
SELECT FirstName FROM Customer WHERE SUBSTRING(FirstName, 1, 1) = 'A' AND SUBSTRING(FirstName, 3, 1) = 'e' 



/* ###### DESAFIO 03 ######
Contagem distinta dos dados da coluna Customer.City, onde a contagem � >= a 2 linhas e por ordem alfabetica. */
SELECT City, COUNT(City) AS numero_de_linhas FROM Customer GROUP BY City HAVING COUNT(City) > 1 ORDER BY City



/* ###### DESAFIO 04 ######
Campos numericos dos dados da coluna Customer.PostalCode de 8 posi��es e do tipo inteiro */
/* REPLACE - Substitui todas as inst�ncias de uma cadeia de caracteres especificada por uma nova cadeia de caracteres. LENGTH - Utilizada para obter o comprimento de uma cadeia. 
 * CAST - Transforma um ou mais valores de um tipo de dado para outro. AS INT - Como tipo de dado inteiro */
SELECT CustomerId, Address, State, Country, REPLACE(PostalCode, "-", "") AS Postal_Code
FROM Customer
WHERE LENGTH(CAST(REPLACE(PostalCode, "-", "") AS INT)) = 8



/* ###### DESAFIO 05 ######
1.concatene as colunas Customer.FirstName com Customer.LastName e gere uma coluna com a descri��o nome onde apenas a primeira letra do nome seja Mai�scula.
2.concatene as colunas Customer.City com Customer.State e gere uma coluna com a descri��o cidade onde apenas a coluna Customer.State seja Mai�scula. exemplo: bel�m-PA.
3.crie uma nova coluna denominada cep a partir da coluna Customer.PostalCode removendo todos os caracteres e convertendo o a coluna para o tipo de dados Integer.
4.a filtragem da tabela precisa pegar apenas os dados da pa�s "BRAZIL" e o cep <> 0
 */
/*
 || - Concate 2 colunas. 
 LOWER - Minusculas
 UPPER - Maiusculas
 */
SELECT CustomerId AS codigo,
       FirstName || ' ' || LOWER(LastName) AS nome,
       LOWER(Address) AS endereco,
       LOWER(City) || '-' || State AS cidade,
       UPPER(Country) AS pais,
       CAST(REPLACE(PostalCode, "-", "") AS INT) AS cep,
       REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Phone,"+",""),"(",""),")",""),"-","")," ","") AS telefone,
       Email
FROM Customer
WHERE UPPER (Country) == 'BRAZIL'
AND REPLACE(PostalCode, "-", "") <> 0



/* ###### DESAFIO 06 ######
  Idade das pessoas da tabela Employee use a coluna BithDate para a transforma��o.
 */
SELECT LastName,
       SUBSTRING(BirthDate,1,4) AS ano_de_nascimento,
       CAST(SUBSTRING(DATE(),1,4) AS INT) - CAST(SUBSTRING(BirthDate,1,4) AS INT) AS idade
 FROM Employee

 
 
/* ###### DESAFIO 07 ######
 /* Criar uma nova tabela chamada Track2 oriunda da transforma��o das tabelas: Track, Album, Artist e Genre. A tabela que vai mandar
 no relacionamento � a tabela da esquerda Track aqui tu vai usar JOIN */
create table Track2 
AS 
    select tr.TrackId                 as TrackId,
           at.Name                    as artista,
           tr.Name                    as musica,
           CASE 
                WHEN tr.Composer is null THEN ''      
           ELSE tr.Composer
           END                        as compositor,
           ge.Name                    as genero,
           CAST(tr.bytes AS INT)/1024 as size_mb
      from track as tr
     inner join genre as ge
        on tr.GenreId = ge.GenreId    
     inner join album as al
        on tr.AlbumId = al.AlbumId
     inner join Artist as at
        on al.ArtistId = at.ArtistId;
  
       
 SELECT * FROM Track2 LIMIT 10
 
 
 
 /* ###### DESAFIO 08 ######
 /* Agrupar os dados da tabela Invoice e exibir apenas os valores maiores por Customer.CustomerId apenas do Brazil utilizando
  fun��es como: ROW_NUMBER e PARTITION */
 
 -- Sub Select

select CustomerId,
       FirstName,
       LastName,
       country,
       total  
  from (
        select ROW_NUMBER() OVER(PARTITION BY country ORDER BY total DESC) AS Row,   
               iv.CustomerId as CustomerId,
               ct.FirstName  as FirstName,
               ct.LastName   as LastName,
               country       as country,
              round(total,2) as total        
          from invoice as iv
         inner join customer as ct
            on iv.CustomerId = ct.CustomerId
         where country = 'Brazil'    
        )  limit 5
        
 
 -- CTE (Common Table Expression)

With customer_table 
AS
    (
      select ROW_NUMBER() OVER(PARTITION BY country ORDER BY total DESC) AS Row,   
             iv.CustomerId as CustomerId,
             ct.FirstName  as FirstName,
             ct.LastName   as LastName,
             country       as country,
             round(total,2) as total        
        from invoice as iv
       inner join customer as ct
          on iv.CustomerId = ct.CustomerId
       where country = 'Brazil' 
    )
  
select CustomerId,
       FirstName,
       LastName,
       country,
       total  
  from customer_table
 limit 5
 
 
 
/* ###### DESAFIO 09 ###### 
 /* Opera��o de UPDATE na coluna Customer.Company onde o campo Customer.Company nullo recebe o valor "xxxxxxxxxxxx" */
 UPDATE Customer
   SET Company = "xxxxxxxxxxxx"
 WHERE Company IS NULL
 
 SELECT CustomerId,
       FirstName,
       LastName,
       Company,
       Address
  FROM Customer
 
  

/* ###### DESAFIO 10 ######  
/* Criar uma VIEW com as colunas AlbumId,Title,ArtistId da tabela Album */
 CREATE TEMP VIEW IF NOT EXISTS vw_album
AS
   SELECT AlbumId,
          Title,
          ArtistId
     FROM Album

SELECT * FROM vw_album
 
