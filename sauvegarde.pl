:- dynamic je_suis_a/1.

je_suis_a(salle1).

:- dynamic il_y_a/2.

il_y_a(torche, salle1).
il_y_a(laissez-passer_W-51, salle2) :-
	il_y_a(cle, en_main).
il_y_a(gourde, salle2) :-
	il_y_a(cle, en_main).
il_y_a(laissez-passer_R-24, salle6).
il_y_a(laissez-passer_A-38, salle8).
il_y_a(cle, en_main).

:- dynamic je_possede/1.

je_possede(1).

:- dynamic est_signe/1.


:- dynamic est_remis/1.


:- dynamic avec/1.


:- dynamic est_present/2.

est_present(secretaire, salle3).
est_present(directeur, salle5).
est_present(gardien, salle7).

:- dynamic je_monte/1.

je_monte(0).

:- dynamic correct/1.


:- dynamic essai/1.

essai(0).

