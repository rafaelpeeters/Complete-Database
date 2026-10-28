/*
 ----------------------------------------------------------------------------
             Génération d'une base de données pour 
                        SQL Server 2005
                       (13/1/2026 14:48:42)
 ----------------------------------------------------------------------------
     Nom de la base : S1D_SARRAZAIN_CARPENTIER
     Projet : SAE S1.04 : Création d'une base de données
     Auteur : Rafael Sarrazain-Peeters et Antonin Carpentier
     Date de dernière modification : 13/1/2026 14:47:29
 ----------------------------------------------------------------------------
*/

-- On supprime la base de données si elle existe déjà.
drop database if exists S1D_SARRAZAIN_CARPENTIER
go

/* -----------------------------------------------------------------------------
      OUVERTURE DE LA BASE S1D_SARRAZAIN_CARPENTIER ET GESTION DES ACCÈS
----------------------------------------------------------------------------- */

-- On crée la base de données.
create database S1D_SARRAZAIN_CARPENTIER
go

-- On se positionne sur sa base de données.
use S1D_SARRAZAIN_CARPENTIER
go

-- On crée les utilisateurs qui vont consulter la base.
CREATE USER [IUTBX\antcarpentie]

-- On leur donne les droits voulus (opérations autorisées) sur toutes les tables de la base.
GRANT view definition, select, update, insert, delete TO [IUTBX\antcarpentie]

/* =============================================================================
     CREATION DES TABLES PRINCIPALES
============================================================================= */

/* -----------------------------------------------------------------------------
      TABLE : Lieu -> Établissements accueillant les concerts
----------------------------------------------------------------------------- */

-- Création de la table.
create table Lieu
  (
     idLieu int identity (1, 1)   , -- (int identity (1,1) signifiant un attribut compteur qui va s'incrémenter automatiquement)
     idVille int  not null  , --(not null signifiant un attribut obligatoire)
     nomLieu char(32)  not null  ,
     adresse char(32)  not null  ,
     capacité int null  
     ,
	 -- On définit idLieu en tant que clé primaire.
     constraint PK_Lieu primary key (idLieu)
  ) 
go



/* -----------------------------------------------------------------------------
      TABLE : Artiste -> Répertoire des musiciens/groupes participant aux concerts
----------------------------------------------------------------------------- */

-- Création de la table.
create table Artiste
  (
     idArtiste int identity (1, 1)   ,
     nomArtiste char(32)  not null   
     ,
	 -- On définit idArtiste en tant que clé primaire.
     constraint PK_Artiste primary key (idArtiste)
  ) 
go



/* -----------------------------------------------------------------------------
      TABLE : Ville -> Référence géographique pour situer les lieux et les alertes
----------------------------------------------------------------------------- */

-- Création de la table.
create table Ville
  (
     idVille int identity (1, 1)   ,
     nomVille char(32)  not null  ,
     codePostal char(32)  not null  
     ,
	 -- On définit idVille en tant que clé primaire.
     constraint PK_Ville primary key (idVille)
  ) 
go



/* -----------------------------------------------------------------------------
      TABLE : Festival -> Regroupement de plusieurs concerts sous un même événement
----------------------------------------------------------------------------- */

-- Création de la table.
create table Festival
  (
     idFestival int identity (1, 1)   ,
     nomFestival char(32)  not null  ,
     dateDébut datetime  not null  ,
     dateFin datetime  not null  
     ,
	 -- On définit idFestival en tant que clé primaire.
     constraint PK_Festival primary key (idFestival)
  ) 
go



/* -----------------------------------------------------------------------------
      TABLE : Client -> Utilisateurs du système souhaitant recevoir des notifications
----------------------------------------------------------------------------- */

-- Création de la table.
create table Client
  (
     idClient int identity (1, 1)   ,
     login char(32)  not null  ,
     motDePasse char(32)  not null  ,
     numéroDeTéléphone int  null  ,
     email char(32)  null  
     ,
	  -- On définit idClient en tant que clé primaire.
     constraint PK_Client primary key (idClient)
  ) 
go



/* -----------------------------------------------------------------------------
      TABLE : Concert -> Événement liant un Lieu, une date et potentiellement un Festival
----------------------------------------------------------------------------- */

-- Création de la table.
create table Concert
  (
     idConcert int identity (1, 1)   ,
     idLieu int  not null  ,
     idFestival int  null  ,
     nomConcert char(32)  not null  ,
     date datetime  not null  ,
     horaire datetime  null  
     ,
	 -- On définit idConcert en tant que clé primaire.
     constraint PK_Concert primary key (idConcert)
  ) 
go

/* =============================================================================
     CREATION DES TABLES DE LIAISON
============================================================================= */

/* -----------------------------------------------------------------------------
      TABLE : alerte_ville -> Permet à un client de suivre une ville précise
----------------------------------------------------------------------------- */

-- Création de la table.
create table alerte_ville
  (
     idClient int  not null  ,
     idVille int  not null  
     ,
	  -- On définit idClient et idVille en tant que clé primaire.
     constraint PK_alerte_ville primary key (idClient, idVille)
	 -- (La clé primaire est composée des deux identifiants pour garantir qu'un client ne puisse
	 --pas s'abonner deux fois à la même ville)
  ) 
go



/* -----------------------------------------------------------------------------
      TABLE : alerte_artiste -> Permet à un client de suivre un artiste précis
----------------------------------------------------------------------------- */

-- Création de la table.
create table alerte_artiste
  (
     idArtiste int  not null  ,
     idClient int  not null  
     ,
	 -- On définit idArtiste et idClient en tant que clé primaire.
     constraint PK_alerte_artiste primary key (idArtiste, idClient)
  ) 
go



/* -----------------------------------------------------------------------------
      TABLE : joue_dans -> Table d'association entre Concert et Artiste
----------------------------------------------------------------------------- */

-- Création de la table.
create table joue_dans
  (
     idConcert int  not null  ,
     idArtiste int  not null  
     ,
	 -- On définit idConcert et idArtiste en tant que clé primaire.
     constraint PK_joue_dans primary key (idConcert, idArtiste)
  ) 
go



/* -----------------------------------------------------------------------------
      TABLE : alerte_lieu -> Permet à un client de suivre un lieu précis
----------------------------------------------------------------------------- */

-- Création de la table.
create table alerte_lieu
  (
     idLieu int  not null  ,
     idClient int  not null  
     ,
	 -- On définit idLieu et idClient en tant que clé primaire.
     constraint PK_alerte_lieu primary key (idLieu, idClient)
  ) 
go



/* =============================================================================
      RÉFÉRENCES SUR LES TABLES ET CONTRAINTES D'INTÉGRITÉ 
============================================================================= */

/* -----------------------------------------------------------------------------
      RÉFÉRENCES SUR LES TABLES -> Les liens logiques pour que les données soient cohérentes
----------------------------------------------------------------------------- */


-- Un Lieu appartient forcément à une Ville existante.
alter table Lieu 
     add constraint FK_Lieu_Ville foreign key (idVille) 
               references Ville (idVille)
go



-- Un Concert est rattaché à un Lieu.
alter table Concert 
     add constraint FK_Concert_Lieu foreign key (idLieu) 
               references Lieu (idLieu)
go


-- Un Concert peut être lié à un Festival
alter table Concert 
     add constraint FK_Concert_Festival foreign key (idFestival) 
               references Festival (idFestival)
go




-- Tables d'alertes : Ces liens permettent de savoir quel Client suit quelle Ville/Artiste/Lieu.

alter table alerte_ville 
     add constraint FK_alerte_ville_Client foreign key (idClient) 
               references Client (idClient)
go




alter table alerte_ville 
     add constraint FK_alerte_ville_Ville foreign key (idVille) 
               references Ville (idVille)
go




alter table alerte_artiste 
     add constraint FK_alerte_artiste_Artiste foreign key (idArtiste) 
               references Artiste (idArtiste)
go




alter table alerte_artiste 
     add constraint FK_alerte_artiste_Client foreign key (idClient) 
               references Client (idClient)
go




alter table joue_dans 
     add constraint FK_joue_dans_Concert foreign key (idConcert) 
               references Concert (idConcert)
go




alter table joue_dans 
     add constraint FK_joue_dans_Artiste foreign key (idArtiste) 
               references Artiste (idArtiste)
go




alter table alerte_lieu 
     add constraint FK_alerte_lieu_Lieu foreign key (idLieu) 
               references Lieu (idLieu)
go




alter table alerte_lieu 
     add constraint FK_alerte_lieu_Client foreign key (idClient) 
               references Client (idClient)
go




/* -----------------------------------------------------------------------------
      CONTRAINTES D'INTÉGRITÉ -> Ces contraintes empêchent les erreurs humaines.
----------------------------------------------------------------------------- */



-- Contrainte ajoutée : La capacité d'un lieu doit être un entier strictement positif.
alter table Lieu
      add constraint capacité_cohérente check (capacité > 0)
go



-- Contrainte ajoutée : La combinaison nomVille et codePostal doit être unique.
alter table Ville
      add constraint ville_cohérente unique (nomVille, codePostal)
go



-- Contrainte ajoutée : La date de fin d'un festival ne peut pas être antérieure à sa date de début.
alter table Festival
     add constraint dates_cohérentes check (dateFin > dateDébut)
go



-- Contrainte ajoutée : Le login d'un client doit être unique.
alter table Client 
     add constraint login_unique unique (login)
go



-- Contrainte ajoutée : L'email doit forcément contenir le caractère "@".
alter table Client
     add constraint email_valide check (email LIKE '%@%')
go



-- Contrainte ajoutée : Le client doit obligatoirement renseigner soit un n° de téléphone soit un mail.
alter table Client 
     add constraint contact_obligatoire check (email IS NOT NULL OR numéroDeTéléphone IS NOT NULL)
go




-- Contrainte ajoutée : L'heure de début d'un concert doit être comprise entre 8h et 22h.
alter table Concert   
      add constraint heures_cohérentes check (horaire >= '08:00' and horaire <= '22:00')
go



/*
 -----------------------------------------------------------------------------
               FIN DE GENERATION
 -----------------------------------------------------------------------------
*/