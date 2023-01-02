CREATE DATABASE s6_mvc_btp;

CREATE TABLE client
(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nom Varchar(20),
    anneeNaiss INT, 
    ville VarChar(20)
);

CREATE TABLE commande(
    num INT NOT NULL,
    idC INT NOT NULL,
    labelIP VarChar(20) NOT NULL,
    qte INT,
    FOREIGN KEY (labelIP) REFERENCES produit (label),
    FOREIGN KEY (idC) REFERENCES client (id),
    PRIMARY KEY (num, idC, labelIP)
);

CREATE TABLE fournisseur(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nom Varchar(20),
    age INT, 
    ville VarChar(20)
);

CREATE TABLE produit(
    label VarChar(20) NOT NULL,
    idF INT NOT NULL,
    prix float,
    FOREIGN KEY (idF) REFERENCES fournisseur(id),
    PRIMARY KEY (label, idF)
); 

INSERT INTO client (nom, anneeNaiss, ville)
VALUES
    ('jean', 1965, '75006 Paris'),
    ('Paul', 1953, '75003 Paris'),
    ('Vincent', 1954, '94200 Evry'),
    ('Pierre', 1950, '92400 Courbevoie'),
    ('Daniel', 1963, '44000 Nantes');
    
INSERT INTO commande (num, idC, labelIP, qte)
VALUES
	(1, 1, 'briques', 5), 
    (1, 1, 'ciment', 10),
    (2, 2, 'briques', 12),
    (2, 2, 'sable', 9),
    (2, 2, 'parpaing', 15),
    (3, 3, 'sable', 17),
    (4, 4, 'briques', 8),
    (4, 4, 'tuiles', 17),
    (5, 5, 'parpaing', 10),
    (5, 5, 'ciment', 14),
    (6, 5, 'briques', 21),
    (7, 2, 'ciment', 12),
    (8, 4, 'parpaing', 8),
    (9, 1, 'tuiles', 15);

INSERT INTO fournisseur (nom, age, ville)
VALUES
	('Abounayan', 52, '92190 Meudon'),
    ('Cima', 37, '44150 Nantes'),
    ('Preblocs', 48, '92230 Gennevilliers'),
    ('Samaco', 61, '75018 Paris'),
    ('Damasco', 69, '49100 Angers');
 
 INSERT INTO produit (label, idF, prix)
 VALUES
 	('sable', 1, 300),
    ('briques', 1, 1500),
    ('parpaing', 1, 1500),
    ('sable', 2, 350),
    ('tuiles', 3, 1200),
    ('parpaing', 3, 1300),
    ('briques', 4, 1500),
    ('ciment', 4, 1300),
    ('parpaing', 4, 1450),
    ('briques', 5, 1450),
    ('tuiles', 5, 1100);

    --RECCUPEREZ : --

--1. toutes les informations sur les clients.--
SELECT * FROM s6_mvc_btp.client;

--2. toutes les informations « utiles à l’utilisateur » sur les clients, i.e. sans l’identifiant (servant à lier les relations).--
SELECT nom, anneeNaiss, ville FROM s6_mvc_btp.client;

--3. le nom des clients dont l’âge est supérieur à 50--
SELECT nom FROM s6_mvc_btp.client WHERE anneeNaiss > 2022 - 50;

--4. la liste des produits (leur label), sans doublon !--
SELECT DISTINCT label FROM s6_mvc_btp.produit;

--5. idem, mais cette fois la liste est triée par ordre alphabétique décroissant--
SELECT DISTINCT label FROM s6_mvc_btp.produit ORDER BY label DESC;

--6. Les commandes avec une quantité entre 8 et 18 inclus.--
--une version avec le mot-clé BETWEEN--
SELECT qte FROM s6_mvc_btp.commande WHERE qte BETWEEN 8 AND 18;
--une version sans--
SELECT qte FROM s6_mvc_btp.commande WHERE qte >= 8 AND qte <= 18;

--7. le nom et la ville des clients dont le nom commence par ’P’.--
SELECT nom, ville FROM s6_mvc_btp.client WHERE nom LIKE 'P%';

--8. le nom des fournisseurs situés à PARIS.--
SELECT nom FROM s6_mvc_btp.fournisseur WHERE ville LIKE '%Paris';

-- 9. l’identifiant Fournisseur et le prix associés des "briques" et des "parpaing".--
--une version sans le mot-clé IN--
SELECT f.id, p.prix 
FROM fournisseur f
INNER JOIN produit p ON f.id = p.idF
WHERE p.label = 'briques' OR p.label = 'papraing';
--une version avec le mot-clé IN--
SELECT prix, idF
FROM produit
WHERE idF IN (SELECT id FROM fournisseur) AND label = 'briques' OR label = 'papraing';

-- 10.	la liste des noms des clients avec ce qu’ils ont commandé (label + quantité des produits).--
--version avec jointure (pas de produit cartésien)--
SELECT C2.nom , C1.labelIP , C1.qte
FROM commande AS C1
INNER JOIN client AS C2 ON
C2.id = C1.idC;

-- 11. le produit cartésien entre les clients et les produits (i.e. toutes les combinaisons possibles 
--d’un achat par un client), on affichera le nom des clients ainsi que le label produits.
--Constatez le nombre de réponses (i.e. nombre de lignes du résultat) par rapport à la requête précédente !
SELECT cl.nom, c.labelIP
FROM commande c, client cl
WHERE idC IN (SELECT id FROM client)
GROUP BY nom, labelIP;

--12.	la liste, triée par ordre alphabétique, des noms des clients qui commandent le produit "briques".
SELECT nom
FROM client
INNER JOIN commande ON  idC = id  AND labelIP = 'briques'
ORDER BY nom ASC;

--13.	le nom des fournisseurs qui vendent des "briques" ou des "parpaing".
--une version avec jointure
SELECT nom
FROM fournisseur
INNER JOIN produit ON id = idF
AND (label = 'briques' OR label = 'parpaing')
GROUP BY nom;

--une version avec requête imbriquée
--Attention : aucun produit cartésien
--Constatez que l’ordre d’affichage (et donc l’ordre de traitement) n’est pas le même !
SELECT nom
FROM fournisseur 
WHERE id IN (SELECT idF FROM produit WHERE label = 'briques' OR label = 'parpaing');

--13. le nom des produits fournis par des fournisseurs parisiens (intra muros uniquement).
--en 3 versions différentes (jointure, produit cartésien et requête imbriquée)
--jointure
SELECT label 
FROM produit 
INNER JOIN fournisseur ON idF = id
WHERE ville LIKE '75%';

--requête imbriquée
SELECT label
FROM produit
WHERE idF IN (SELECT id FROM fournisseur WHERE ville LIKE '75%');


--produit cartésien
SELECT label 
FROM produit 
CROSS JOIN fournisseur ON idF = id
WHERE ville LIKE '75%';

--14 les nom et adresse des clients ayant commandé des briques, tel que la quantité commandée soit comprise entre 10 et 15.
SELECT nom, ville
FROM client
WHERE id IN (SELECT idC FROM commande WHERE labelIP = 'briques' AND qte  BETWEEN 10 AND 15);

--15 le nom des fournisseurs, le nom des produits et leur coût, correspondant pour tous les fournisseurs proposant au moins un produit commandé par Jean.
--Attention : utilisez la chaîne "Jean" dans la requête, et pas directement son id (non nécessairement connu).
SELECT f.nom , p.label, p.prix
FROM fournisseur f
INNER JOIN produit p  ON f.id = idF
INNER JOIN commande c ON p.label = c.labelIP
INNER JOIN client cl ON c.idC = cl.id WHERE cl.nom = 'Jean';

--16 idem, mais on souhaite cette fois que le résultat affiche le nom des fournisseurs trié dans l’ordre alphabétique descendant
-- et pour chaque fournisseur le nom des produits dans l’ordre ascendant.
SELECT f.nom , p.label, p.prix
FROM fournisseur f
INNER JOIN produit p  ON f.id = idF
INNER JOIN commande c ON p.label = c.labelIP
INNER JOIN client cl ON c.idC = cl.id WHERE cl.nom = 'Jean'
ORDER BY f.nom DESC, p.label ASC;

--17. 	le nom et le coût moyen des produits.
SELECT label, ROUND(AVG(prix),2)
FROM produit 
GROUP BY label;

--18. le nom des produits proposés et leur coût moyen lorsque celui-ci est supérieur à 1200.
SELECT A.label , A.prix_moyen
FROM
( SELECT label, ROUND(AVG(prix),2) AS prix_moyen
FROM produit 
GROUP BY label ) AS A

WHERE
A.TOTAL >1200
;

--20.	 le nom des produits dont le coût est inférieur au coût moyen de tous les produits.
SELECT label
FROM produit
WHERE prix < ( SELECT AVG(prix) FROM produit);

--21.	le nom des produits proposés et leur coût moyen pour les produits fournis par au moins 3 fournisseurs.
SELECT produit.label, AVG(produit.prix)
FROM produit , (SELECT nbs_fournisseur_par_produits.label
					FROM (SELECT COUNT(P.idF) AS total, P.label 
							FROM produit AS P
							GROUP BY P.label) AS nbs_fournisseur_par_produits

				WHERE nbs_fournisseur_par_produits.total >= 3) AS trois_fournisseurs
WHERE produit.label = trois_fournisseurs.label
GROUP BY produit.label



