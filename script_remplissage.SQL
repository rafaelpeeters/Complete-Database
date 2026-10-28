/*
 ----------------------------------------------------------------------------
            Script de remplissage de base de données pour 
                        SQL Server 2005
                       (13/1/2026 14:48:42)
 ----------------------------------------------------------------------------
     Nom de la base : S1D_SARRAZAIN_CARPENTIER
     Projet : SAE S1.04 : Création d'une base de données
     Auteur : Rafael Sarrazain-Peeters et Antonin Carpentier
     Date de dernière modification : 13/1/2026 14:47:29
 ----------------------------------------------------------------------------
*/
SET DATEFORMAT ymd; --Permet la conversion de varchar en datetime pour l'insertion de dates
-- On supprime tout afin de pouvoir proprement insérer les données
DELETE FROM joue_dans;
DELETE FROM Client;
DELETE FROM Concert;
DELETE FROM Festival;
DELETE FROM Lieu;
DELETE FROM Artiste;
DELETE FROM Ville;
/* -----------------------------------------------------------------------------
      INSERTION DES VILLES
----------------------------------------------------------------------------- */

INSERT INTO Ville (nomVille, codePostal) VALUES 
('Paris', '75000'), -- pas besoin d'id car type compteur
('Marseille', '13000'), -- donc les numéros sont incrémentés par SQL server
('Bordeaux', '33000'),
('Los Angeles', '90001'),
('New York', '10001');

/* -----------------------------------------------------------------------------
      INSERTION DES ARTISTES
----------------------------------------------------------------------------- */

INSERT INTO Artiste (nomArtiste) VALUES 
('Jul'),           
('Ninho'),           
('Vald'),  
('Travis Scott'), 
('Taylor Swift'), 
('Kendrick Lamar'), 
('Ariana Grande');        

/* -----------------------------------------------------------------------------
      INSERTION DES LIEUX (dépend de ville)
----------------------------------------------------------------------------- */
-- capacité pas forcément référencée donc peut être NULL

INSERT INTO Lieu (nomLieu, adresse, capacité, idVille) VALUES 
('Stade de France', 'ZAC du Cornillon', NULL, (SELECT idVille FROM Ville WHERE nomVille = 'Paris')),
('Orange Vélodrome', '3 Bd Michelet', 67000, (SELECT idVille FROM Ville WHERE nomVille = 'Marseille')),
('Arkéa Arena', '87 Quai de la Souys', NULL, (SELECT idVille FROM Ville WHERE nomVille = 'Bordeaux')),
('SoFi Stadium', '1001 Stadium Dr', 70000, (SELECT idVille FROM Ville WHERE nomVille = 'Los Angeles')),
('Madison Square Garden', '4 Pennsylvania Plaza', 20000, (SELECT idVille FROM Ville WHERE nomVille = 'New York'));

/* -----------------------------------------------------------------------------
      INSERTION DES FESTIVAL
----------------------------------------------------------------------------- */

INSERT INTO Festival (nomFestival, dateDébut, dateFin) VALUES 
('Coachella', '2026-04-10', '2058-04-10'),
('Lollapalooza Paris', '2026-07-18', '2026-07-20'),
('Marsatac', '2026-06-12', '2026-06-14');

/* -----------------------------------------------------------------------------
      INSERTION DES CONCERTS (dépend de lieu et festival) 
----------------------------------------------------------------------------- */
-- (idFestival peut être NULL si concert indépendant)

INSERT INTO Concert (nomConcert, date, horaire, idLieu, idFestival) VALUES 
('The Eras Tour NY', '2026-05-22', '20:00', 
    (SELECT idLieu FROM Lieu WHERE nomLieu = 'Madison Square Garden'), NULL),

('Utopia Tour Stadium', '2026-07-19', '21:00', 
    (SELECT idLieu FROM Lieu WHERE nomLieu = 'Stade de France'), 
    (SELECT idFestival FROM Festival WHERE nomFestival = 'Lollapalooza Paris')),

('Le Classico Organisé', '2026-06-13', '20:30', 
    (SELECT idLieu FROM Lieu WHERE nomLieu = 'Orange Vélodrome'), 
    (SELECT idFestival FROM Festival WHERE nomFestival = 'Marsatac')),

('The Pop Show LA', '2026-04-12', '21:00', 
    (SELECT idLieu FROM Lieu WHERE nomLieu = 'SoFi Stadium'), 
    (SELECT idFestival FROM Festival WHERE nomFestival = 'Coachella')),

('Ninho à Bordeaux', '2026-09-15', '20:00', 
    (SELECT idLieu FROM Lieu WHERE nomLieu = 'Arkéa Arena'), NULL);

/* -----------------------------------------------------------------------------
      ASSOCIATION DES CONCERTS ET ARTISTES (table joue_dans) 
----------------------------------------------------------------------------- */

INSERT INTO joue_dans (idConcert, idArtiste) VALUES 
((SELECT idConcert FROM Concert WHERE nomConcert = 'The Eras Tour NY'), (SELECT idArtiste FROM Artiste WHERE nomArtiste = 'Taylor Swift')),
((SELECT idConcert FROM Concert WHERE nomConcert = 'Utopia Tour Stadium'), (SELECT idArtiste FROM Artiste WHERE nomArtiste = 'Travis Scott')),
((SELECT idConcert FROM Concert WHERE nomConcert = 'Le Classico Organisé'), (SELECT idArtiste FROM Artiste WHERE nomArtiste = 'Jul')),
((SELECT idConcert FROM Concert WHERE nomConcert = 'The Pop Show LA'), (SELECT idArtiste FROM Artiste WHERE nomArtiste = 'Ariana Grande')),
((SELECT idConcert FROM Concert WHERE nomConcert = 'Ninho à Bordeaux'), (SELECT idArtiste FROM Artiste WHERE nomArtiste = 'Ninho'));


/* -----------------------------------------------------------------------------
      INSERTION DES CLIENTS
----------------------------------------------------------------------------- */
--(mail ou telephone peut être NULL, tant que l'autre est renseigné)

INSERT INTO Client (login, motDePasse, numéroDeTéléphone, email) VALUES 
('rafpts', 'fandecode123', '0612345678', 'rafael.peeters@bordeaux.fr'),
('antcarpent', 'sqlpro675', NULL, 'antonin.carpentier@bordeaux.fr'),
('kendrickfan375', 'kendrickWin', '0788990011', 'kdot@usa.com'),
('valdgoat33', 'valda33131', '0647381412', NULL);

-- Alertes Artistes :
INSERT INTO alerte_artiste (idArtiste, idClient) VALUES 
((SELECT idArtiste FROM Artiste WHERE nomArtiste = 'Jul'), (SELECT idClient FROM Client WHERE login = 'rafpts')), -- Raf suit Jul
((SELECT idArtiste FROM Artiste WHERE nomArtiste = 'Kendrick Lamar'), (SELECT idClient FROM Client WHERE login = 'kendrickfan375')); --  Kendrickfan suit Kendrick Lamar

-- Alertes Lieux :
INSERT INTO alerte_lieu (idLieu, idClient) VALUES 
((SELECT idLieu FROM Lieu WHERE nomLieu = 'Orange Vélodrome'), (SELECT idClient FROM Client WHERE login = 'antcarpent')); --  Antonin veut savoir quand il y a un concert au Vélodrome

-- Alertes Villes : 
INSERT INTO alerte_ville (idVille, idClient) VALUES 
((SELECT idVille FROM Ville WHERE nomVille = 'Bordeaux'), (SELECT idClient FROM Client WHERE login = 'valdgoat33')); -- Vald suit l'actualité à Bordeaux