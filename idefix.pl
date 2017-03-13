/* Prérequis */

% Prédicats dynamiques

:- dynamic je_suis_a/1, il_y_a/2, je_possede/1.
:- retractall(il_y_a(_, _)), retractall(je_suis_a(_)), retractall(je_possede(_)).

% Point de départ du joueur

je_suis_a(entree).
je_possede(0).

/* Définition de l'environnement */

% Rez-de-chaussée

chemin(entree, n, croisementRdc).

chemin(croisementRdc, e, couloirDroitRdc).
chemin(croisementRdc, o, couloirGaucheRdc).
chemin(croisementRdc, n, escalierRdc).
chemin(croisementRdc, s, entree).

chemin(couloirDroitRdc, n, salle2).
chemin(couloirDroitRdc, s, salle4).
chemin(couloirDroitRdc, o, croisementRdc).

chemin(couloirGaucheRdc, n, salle1).
chemin(couloirGaucheRdc, s, salle3).
chemin(couloirGaucheRdc, e, croisementRdc).

chemin(salle1, s, couloirGaucheRdc).
chemin(salle2, s, couloirDroitRdc).
chemin(salle3, n, couloirGaucheRdc).
chemin(salle4, n, couloirDroitRdc).

chemin(escalierRdc, s, croisementRdc).
chemin(escalierRdc, m, escalierEtage).

% Étage

chemin(escalierEtage, s, croisementEtage).
chemin(escalierEtage, d, escalierRdc).

chemin(croisementEtage, e, couloirDroitEtage).
chemin(croisementEtage, o, couloirGaucheEtage).
chemin(croisementEtage, n, escalierEtage).
chemin(croisementEtage, s, balcon).

chemin(couloirDroitEtage, n, salle6).
chemin(couloirDroitEtage, s, salle8).
chemin(couloirDroitEtage, o, croisementEtage).

chemin(couloirGaucheEtage, n, salle5).
chemin(couloirGaucheEtage, s, salle7).
chemin(couloirGaucheEtage, e, croisementEtage).

chemin(salle5, s, couloirGaucheEtage).
chemin(salle6, s, couloirDroitEtage).
chemin(salle7, e, balcon).
chemin(salle8, o, balcon).

chemin(balcon, o, salle7).
chemin(balcon, e, salle8).
chemin(balcon, n, croisementEtage).

/* Définition des objets et des NPC */

il_y_a(cle, salle1).
il_y_a(torche, salle1).

il_y_a(formulaireYYY, salle2).
il_y_a(gourde, salle2).

il_y_a(secretaire, salle3).

il_y_a(directeur, salle5).

il_y_a(formulaireZZZ, salle6).

il_y_a(gardien, salle7).

il_y_a(formulaireXXX, salle8).

/* Définition des directions */

n :- aller(n).
s :- aller(s).
e :- aller(e).
o :- aller(o).
d :- aller(d).
m :- aller(m).

/* Règle pour se déplacer dans une direction donnée */

aller(Direction) :-
        je_suis_a(Ici),
        chemin(Ici, Direction, Labas),
        retract(je_suis_a(Ici)),
        assert(je_suis_a(Labas)),
        regarder, !.

aller(_) :-
        write('Vous ne pouvez pas aller dans cette direction...').

/* Règle pour regarder autour de soi */

regarder :-
        je_suis_a(Endroit),
        decrire(Endroit),
        nl,
        lister_objets(Endroit),
        nl.

/* Règles pour afficher la ou les description(s) de l'environnement */

% Rez-de-chaussée

decrire(entree) :-
        write('Vous vous trouvez à l''entrée du bâtiment, au rez-de-chaussée.'), nl,
        write('Au nord se trouve le croisement de 2 couloirs.'), nl,
        write('Votre objectif est de récupérer le formulaire XXX'), nl,
        write('et de revenir ici en vie.'), nl.
		
decrire(entree) :-
        il_y_a(formulaireXXX, en_main),
		write('Bravo ! Vous avez gagné ! Vous allez afin pouvoir sortir de ce bâtiment de fous !'), nl.
		terminer, !.

decrire(croisementRdc) :-
        write('Vous êtes au croisement du rez-de-chaussée.'), nl,
        write('Au nord se trouve un escalier gardé par un méchant sphinx.'), nl,
        write('À l''est comme à l''ouest, vous pouvez vous engader dans un sombre couloir'), nl.

decrire(couloirGaucheEtage) :-
        write('Vous êtes dans un couloir sombre.'), nl,
        write('Deux salles s''ouvrent à vous au sud et au nord.'), nl,
        write('À l''est se trouve le croisement.'), nl.

decrire(couloirDroitEtage) :-
        write('Vous êtes dans un couloir sombre.'), nl,
        write('Deux salles s''ouvrent à vous au sud et au nord.'), nl,
        write('À l''ouest se trouve le croisement.'), nl.

decrire(salle1) :- 
        write('Vous êtes dans une sombre salle.'), nl,
        write('La sortie se trouve au sud.'), nl.

decrire(salle2) :- 
        write('Vous êtes dans un salle dans laquelle sont posées au sol'), nl,
        write('deux coffres fermés à clé.'), nl,
        write('La porte de sortie se trouve au sud.'), nl.

decrire(salle2) :- 
		il_y_a(cle, en_main),
        write('Vous êtes dans un salle dans laquelle sont posées au sol'), nl,
        write('deux coffres contenant des objets qui seront peut-être utiles !'), nl,
        write('La porte de sortie se trouve au sud.'), nl.

decrire(salle3) :- 
        write('Vous avez trouvé l''accueil !'), nl,
        write('Pour partir par la porte qui se trouve au nord.'), nl.

decrire(salle3) :- 
		il_y_a(formulaireZZZ, en_main),
        write('Vous avez trouvé l''accueil !'), nl,
		write('Vous pouvez faire signer ici le formulaire ZZZ.'), nl,
        write('Pour partir par la porte qui se trouve au nord.'), nl.

decrire(salle4) :- 
        write('Vous êtes entré dans la cage des lions !'), nl,
        write('Vous mourrez dans d''atroces souffrances...'), nl,
		mourir, !.

decrire(escalierRdc) :-
		write('Vous vous trouvez dans un majestueux escalier vraiment très haut.'), nl,
		write('Vous pouvez monter à l''étage à vos riques et périls,'), nl,
		write('ou aller au rez-de-chaussée au sud'), nl.

% Étage

decrire(croisementEtage) :-
        write('Vous vous trouvez au croisement du première étage.'), nl,
        write('Au nord se trouve l''escalier qui conduit au rez-de-chaussée.'), nl,
        write('À l''est se trouve le couloir de droite'), nl,
        write('À l''ouest se trouve le couloir de gauche.'), nl,
		write('Au sud, se trouve le balcon.'), nl.
		
decrire(couloirDroitEtage) :-
        write('Vous êtes au niveau du couloir droit du premier étage.'), nl,
        write('Au nord se trouve la bibliothèque.'), nl,
        write('Au sud se trouve la salle des archives.'), nl,
        write('À l''ouest se trouve le croisement des couloirs du premier étage.'), nl.
		
		
decrire(couloirGaucheEtage) :-
        write('Vous vous trouvez au niveau du couloir gauche du premier étage.'), nl,
        write('Au nord se trouve le bureau du directeur.'), nl,
        write('Au sud se trouve la loge du gardien.'), nl,
        write('À l''est se trouve le croisement des couloirs du premier étage.'), nl.
		
decrire(balcon) :-
        write('Vous êtes sur le balcon.'), nl,
        write('Au nord se trouve le croisement des couloirs du premier étage.'), nl,
        write('À l''est, se trouve la salle des archives.'), nl,
		write('À l''ouest, se trouve la loge du gardien.'), nl.
		

decrire(salle5):-
        write('Vous vous trouvez dans le bureau du directeur.'), nl,
        write('Vous pouvez le quitter par la porte qui est au sud.'), nl.
      

decrire(salle6):-
        write('Vous êtes dans la bibliothèque.'), nl,
        write('Vous pouvez partir par la porte qui se trouve au sud.'), nl.

decrire(salle7):-
        write('Vous vous trouvez dans la loge du gardien.'), nl,
        write('À l''est vous pouvez revenir sur le balcon.'), nl.
		
decrire(salle8):-
        write('Vous vous trouvez dans la salle des archives'), nl,
        write('À l''ouest vous pouvez revenir sur le balcon.'), nl.
		
decrire(escalierEtage):-		
        write('Vous vous trouvez au niveau de l''escalier du premier étage.'), nl,
        write('Vous pouvez descendre au rez-de-chaussée ou'), nl.
		write('aller à l''étage au sud.'), nl.

/* Règles pour indiquer tous les objets autour du joueur */

lister_objets(Endroit) :-
        il_y_a(X, Endroit),
        write('Il y a un(e) '), write(X), write(' ici.'), nl,
        fail.

lister_objets(_).

% Règles pour ramasser un objet

ramasser(X) :-
        il_y_a(X, en_main),
        write('Vous le tenez déjà !'),
        nl, !.

ramasser(cle) :-
		il_y_a(X, Endroit),
        retract(il_y_a(X, Endroit)),
        assert(il_y_a(X, en_main)),
		je_possede(N),
		M is N+1,
		retract(je_possede(N)),
		assert(je_possede(M)),
        write('OK.'), nl,
		write('Si vous déposez la clé, vous ne pourrez plus la récupérer par la suite !'),
        nl, !.

ramasser(X) :-
        je_suis_a(Endroit),
        il_y_a(X, Endroit),
        retract(il_y_a(X, Endroit)),
        assert(il_y_a(X, en_main)),
		je_possede(N),
		M is N+1,
		retract(je_possede(N)),
		assert(je_possede(M)),
        write('OK.'),
        nl, !.

ramasser(_) :-
        write('Je ne vois rien ici.'),
        nl.

% Règles pour déposer un objet

deposer(cle) :-
        il_y_a(cle, en_main),
        retract(il_y_a(X, en_main)),
		je_possede(N),
		M is N-1,
		retract(je_possede(N)),
		assert(je_possede(M)),
        write('Vous ne pourrez plus récupérer la clé...'),
        !, nl.

deposer(X) :-
        il_y_a(X, en_main),
        je_suis_a(Endroit),
        retract(il_y_a(X, en_main)),
        assert(il_y_a(X, Endroit)),
		je_possede(N),
		M is N-1,
		retract(je_possede(N)),
		assert(je_possede(M)),
        write('OK.'),
        !, nl.

deposer(_) :-
        write('Vous ne le tenez pas !'),
        nl.

/* Règle qui définit la mort */

mourir :-
        !, terminer.

/* Règle pour afficher un message final */

terminer :-
        nl,
        write('La partie est terminée. Tapez la commande "halt."'),
        nl, !.

% Fin