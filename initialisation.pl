/* Prérequis */

% Prédicats dynamiques

:- dynamic je_suis_a/1, il_y_a/2, je_possede/1, est_signe/1, est_remis/1, avec/1, est_present/2,
        je_monte/1, correct/1, essai/1.

:- retractall(il_y_a(_, _)), retractall(je_suis_a(_)), retractall(je_possede(_)), retractall(est_present(_,_)),
        retractall(je_monte(_)), retractall(correct(_)), retractall(essai(_)).

% Point de départ du joueur

je_suis_a(entree).
je_possede(0).
je_monte(0).
essai(0).


/* Définition des objets et des NPC */

% Objets

il_y_a(cle, salle1).
il_y_a(torche, salle1).
il_y_a(laissez-passer_W-51, salle2) :- il_y_a(cle, en_main).
il_y_a(gourde, salle2) :- il_y_a(cle, en_main).
il_y_a(laissez-passer_R-24, salle6).
il_y_a(laissez-passer_A-38, salle8).

% NPC

est_present(secretaire, salle3).
est_present(directeur, salle5).
est_present(gardien, salle7).
