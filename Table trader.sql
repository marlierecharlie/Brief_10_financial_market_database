
CREATE DATABASE finance;

CREATE TABLE finance.transaction
(
    Nom VarChar(50),
    NomEquipe VarChar(50),
    Date VarChar(10),
    Lieu VarChar(50),
    Prix Float
)

CREATE TABLE finance.Equipe
(
    nom VarChar(50),
    style VarChar(200),
    chef VarChar(50)
)

CREATE TABLE finance.trader
(
    nom VarChar(50), 
    classe_actif VarChar(50),
    anneesExperience Float, 
    nomEquipe VarChar(20)
)



INSERT INTO finance.transaction (Nom, NomEquipe, Date, Lieu, Prix)
 VALUES
 ('AXA SA', 'equipe1', '2021-06-15', 'PARIS', 26),
 ('TotalEnergies', 'equipe2', '2004-09-03', 'PARIS', 57),
 ('Apple Inc', 'equipe1', '2014-09-05', 'USA', 150),
 ('Dubai Elec', 'equipe3', '2020-11-22', 'DUBAI', 1),
 ('Amazon', 'equipe3', '2010-07-12', 'USA', 100),
 ('Naspers', 'equipe2', '1997-08-16', 'SOUTH AFRICA', 120),
 ('PetroChina', 'equipe5', '2019-04-20', 'HONG KONG', 10),
 ('ETF Vanguard', 'equipe7', '2015-02-22', 'LA', 200),
 ('Dassault Aviation', 'equipe6', '2016-01-01', 'PARIS', 140);

INSERT INTO finance.trader (nom, classe_actif, anneesExperience, nomEquipe)
VALUES
('Yannick', 'fixed income', 10, 'equipe1'),
('Patrick', 'action', 10, 'equipe1'),
('Cedrick', 'commodities', 10, 'equipe1'),
('Jordan', 'change', 2, 'equipe2'),
('Gaelle', 'exotic', 4, 'equipe3'),
('Georges', 'CDS', 20, 'equipe6');

INSERT INTO finance.equipe (nom, style, chef)
VALUES
('equipe1', 'market making', 'leonardo'),
('equipe2', 'arbitrage', 'michaelgelo'),
('equipe3', 'trading de volatilite', 'raphael'),
('equipe4', 'trading haute frequence', 'donatello'),
('equipe5', 'arbitrage statistique', 'Smith'),
('equipe6', 'arbitrage statistique', 'Smith'),
('equipe7', 'strategie fond de fond', 'Ray');


ALTER TABLE finance.equipe 
ADD PRIMARY KEY (`nom`)

ALTER TABLE finance.trader
ADD PRIMARY KEY (`nom`)

ALTER TABLE finance.transaction
ADD PRIMARY KEY (`nom`)
 

ALTER TABLE finance.transaction
ADD FOREIGN KEY (nomEquipe)REFERENCES finance.nomEquipe(nom)

ALTER TABLE finance.trader
ADD FOREIGN KEY (nomEquipe)REFERENCES finance.nomEquipe(nom)

-- mf01 Donner la liste des noms des jeunes trader et leurs classe actifs ; 
-- o?? jeune si moins de 5 ans d'exp??rience.
SELECT nom FROM finance.trader WHERE anneesExperience < 5;

-- mf02 Donner la liste des diff??rentes classes d???actifs de l?????quipe 1
SELECT classe_actif FROM finance.trader WHERE nomEquipe = 'equipe1';

-- mf03 Donner toutes les informations sur les traders commodities
SELECT * FROM finance.trader WHERE classe_actif = 'commodities';

-- mf04 Donner la liste des classes d???actifs des traders de  plus de 20 ans d'exp??rience.
SELECT classe_actif FROM finance.trader WHERE anneesExperience > 20;

-- mf05 Donner la liste des noms des traders ayant entre 5 et 10 ans d'exp??rience (bornes incluses).
SELECT nom FROM trader WHERE anneesExperience >= 5 AND anneesExperience <=10

-- mf06 Donner la liste des classes d???actifs commen??ant par ?? ch ?? (e.g. change...)
SELECT classe_actif FROM trader WHERE classe_actif LIKE 'ch%'

-- mf07 Donner la liste des noms des ??quipes utilisant l???arbitrage statistique
SELECT nom FROM equipe WHERE style = 'arbitrage statistique'

-- mf08 Donner la liste des noms des ??quipes dont le chef est Smith.
SELECT nom FROM equipe WHERE chef = 'Smith'

-- mf09 Donner la liste des transactions  tri??s par ordre alphab??tique.
SELECT nom FROM transaction ORDER BY nom

-- mf10 Donner la liste des transactions se d??roulant le 20 Avril 2019  ?? Hong Kong 
SELECT nom FROM transaction WHERE date = '2019-04-20'

-- mf11 Donner la liste des march??s ( lieux) o?? le prix est sup??rieur ?? 150 euros.
SELECT Lieu FROM transaction WHERE Prix > 150

-- mf12 Donner la liste des transactions se d??roulant ?? Paris pour moins de 50 euros.
SELECT Nom FROM transaction WHERE Lieu = 'PARIS' AND Prix < 50

-- mf13 Donner la liste des march??s ( lieux)  ayant eu lieu en 2014.
SELECT Nom FROM transaction WHERE Date LIKE '2014%';

-- mmtj01 Donner la liste des noms et classes d???actifs des traders ayant plus de 3 ans d'exp??rience
--  et faisant partie d'une ??quipe de style arbitrage statisque. On affichera par ordre alphab??tique 
--  sur les noms.
-- ATTENTION : utilisation de sous-requ??te ou de produit cart??sien non autoris??s.
SELECT t.nom, t.classe_actif, t.anneesExperience, t.nomEquipe, e.chef, e.style 
FROM trader t
INNER JOIN equipe e ON t.nomEquipe = e.nom
WHERE t.anneesExperience > 3 AND e.style ='arbitrage statistique' ORDER BY t.nom;

-- mmtj02 Donner les diff??rents march??s(lieux), tri??s par ordre alphab??tique, des transactions 
-- effectu??es dans  l'??quipe du chef Smith avec un prix inf??rieur ?? 20. 
-- ATTENTION : utilisation de sous-requ??te ou de produit cart??sien non autoris??s.
SELECT lieu
FROM transaction
INNER JOIN equipe ON transaction.nomEquipe = equipe.nom
WHERE chef = 'Smith' AND prix<20
ORDER BY lieu ASC

-- mmtj03 Donner le nombre de march??s sur lesquels intervenaient les traders  de style Market Making 
--  en 2021.
-- ATTENTION : utilisation de sous- requ??te ou de produit cart??sien non autoris??s.
SELECT COUNT(tran.Lieu)
FROM transaction tran
LEFT JOIN equipe e ON tran.NomEquipe = e.nom
WHERE e.style= 'market making' AND tran.Date LIKE '2021%'

-- mmtj04 Donner le prix moyen des actifs des trait??s par les traders market maker  par zone g??ographique de transaction 
-- ATTENTION : utilisation de sous-requ??te ou de produit cart??sien non autoris??s.
SELECT AVG(tran.Prix)
FROM transaction tran 
INNER JOIN equipe e ON tran.NomEquipe = e.nom
WHERE e.style = 'market making'
GROUP BY tran.lieu



-- mmtj05 Donner la liste des classes d???actifs des traders qui ont effectu?? des transactions le 1ER Janvier 2016 sous le management de monsieur Smith
SELECT trader.classe_actif, e.chef,tran.Date
FROM trader 
JOIN equipe e 
ON trader.nomEquipe = e.nom
JOIN transaction tran
ON tran.NomEquipe = trader.nomEquipe
WHERE date = '2016-01-01' AND 
e.chef = 'Smith';

-- mmtj21 Donner le nombre moyen d'ann??es d'exp??rience des traders d???action par style  de strat??gie d?????quipe 
-- ATTENTION : utilisation de sous-requ??te ou de produit cart??sien non autoris??s.
SELECT AVG(t.anneesExperience)
FROM trader t 
INNER JOIN equipe e ON t.nomEquipe=e.nom
WHERE T.classe_actif = 'action'
GROUP BY e.style

-- ___________________________________Multi-tables, sans jointures

-- mmts01 Donner la liste des noms et classes d???actifs des traders ayant plus de 3 ans d'exp??rience et faisant partie d'une ??quipe de style arbitrage statistique. On affichera par ordre alphab??tique sur les noms.
-- ATTENTION : utilisation de jointure (y compris le produit cart??sien) non autoris??e.
SELECT nom, classe_actif
FROM trader
WHERE  anneesExperience > 3 AND nomEquipe IN (
    SELECT nom FROM equipe WHERE style = 'arbitrage statistique') ORDER BY nom ASC

-- mmts02 Donner les diff??rents march??s(lieux), tri??s par ordre alphab??tique, des transactions effectu??es dans  l'??quipe du chef Smith avec un prix inf??rieur ?? 20.
-- ATTENTION : utilisation de jointure (y compris le produit cart??sien) non autoris??e.
SELECT Lieu
FROM transaction
WHERE Prix < 20 AND NomEquipe IN (SELECT nom FROM equipe WHERE chef='Smith') ORDER BY Lieu ASC

-- mmts03 Donner le nombre de march??s sur lesquels sont intervenus les traders de volatilite en 2015. 
-- ATTENTION : utilisation de jointure (y compris le produit cart??sien) non autoris??e.
SELECT Lieu
FROM transaction 
WHERE Date LIKE '2015%' AND NomEquipe IN (SELECT nom FROM equipe WHERE style = 'trading de volatilite')

-- mmts04 Donner le prix moyen des actifs des trait??s par les traders market maker  par zone g??ographique de transaction
--  ATTENTION : utilisation de jointure (y compris le produit cart??sien) non autoris??e.
SELECT AVG(Nom)
FROM transaction
GROUP BY Lieu
AND NomEquipe IN (SELECT nom FROM equipe WHERE style = 'market making')

-- mmts05 Donner la liste des classes d???actifs des traders qui ont effectu?? des transactions le 1ER Janvier 2016 sous le management de monsieur Smith
-- ATTENTION: utilisation de jointure (y compris le produit cart??sien) non autoris??e.
SELECT classe_actif
FROM trader
WHERE nomEquipe IN (SELECT nom FROM equipe WHERE chef='Smith'
AND nom IN (SELECT NomEquipe FROM transaction WHERE Date='2016-01-01'))
