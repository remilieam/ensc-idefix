/* Prérequis */

% Prédicats dynamiques

:- dynamic je_suis_a/1, il_y_a/2, je_possede/1, est_signe/1, est_remis/1.
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

chemin(couloirDroitEtage, n, salle6) :- il_y_a(carte_visiteur, en_main).
chemin(couloirDroitEtage, o, croisementEtage).

chemin(couloirGaucheEtage, n, salle5).
chemin(couloirGaucheEtage, e, croisementEtage).

chemin(salle5, s, couloirGaucheEtage).
chemin(salle6, s, couloirDroitEtage).
chemin(salle7, e, balcon).
chemin(salle8, o, balcon).

chemin(balcon, o, salle7).
chemin(balcon, e, salle8) :- il_y_a(passe_directeur, en_main).
chemin(balcon, n, croisementEtage).

/* Définition des objets et des NPC */

il_y_a(cle, salle1).
il_y_a(torche, salle1).

il_y_a(formulaireYYY, salle2).
il_y_a(gourde, salle2).

est_present(secretaire, salle3).

est_present(directeur, salle5).

il_y_a(formulaireZZZ, salle6).

est_present(gardien, salle7).

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
        nl,
        lister_NPC(Endroit),
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
		il_y_a(carte_visiteur, en_main),
        write('Vous êtes au niveau du couloir droit du premier étage.'), nl,
        write('Au nord se trouve la bibliothèque.'), nl,
        write('À l''ouest se trouve le croisement des couloirs du premier étage.'), nl, !.
		
decrire(couloirDroitEtage) :-
        write('Vous êtes au niveau du couloir droit du premier étage.'), nl,
        write('Au nord se trouve la bibliothèque'), nl,
		write('mais elle n''est pour l''instant pas accessible :.'), nl,
		write('il vous faut la carte du visiteur.'), nl,
        write('À l''ouest se trouve le croisement des couloirs du premier étage.'), nl.
		
decrire(couloirGaucheEtage) :-
        write('Vous vous trouvez au niveau du couloir gauche du premier étage.'), nl,
        write('Au nord se trouve le bureau du directeur.'), nl,
        write('Au sud se trouve la loge du gardien.'), nl,
        write('À l''est se trouve le croisement des couloirs du premier étage.'), nl.
		
decrire(balcon) :-
		il_y_a(passe_directeur, en_main),
        write('Vous êtes sur le balcon.'), nl,
        write('Au nord se trouve le croisement des couloirs du premier étage.'), nl,
        write('À l''est, se trouve la salle des archives.'), nl,
		write('À l''ouest, se trouve la loge du gardien.'), nl, !.
			
decrire(balcon) :-
        write('Vous êtes sur le balcon.'), nl,
        write('Au nord se trouve le croisement des couloirs du premier étage.'), nl,
        write('À l''est, se trouve la salle des archives'), nl,
		write('dans laquelle vous ne pouvez pas eller :'), nl,
		write('il vous faut le passe du directeur'), nl,
		write('À l''ouest, se trouve la loge du gardien.'), nl.
		
decrire(salle5) :-
        write('Vous vous trouvez dans le bureau du directeur.'), nl,
        write('Vous pouvez le quitter par la porte qui est au sud.'), nl.
      

decrire(salle6) :-
        write('Vous êtes dans la bibliothèque.'), nl,
        write('Vous pouvez partir par la porte qui se trouve au sud.'), nl.

decrire(salle7) :-
		il_y_a(torche, en_main),
        write('Vous vous trouvez dans la loge du gardien.'), nl,
		write('Et si je lui offrait la torche que j''ai en main.'), nl,
		write('à lui offrir... Peut-être une torche... ?'), nl, !.

decrire(salle7) :-
        write('Vous vous trouvez dans la loge du gardien.'), nl,
		write('Il semblerait qu''il ne soit pas commode,'), nl,
		write('mieux voudrait, revenir lorsque j''aurai quelque chose'), nl,
		write('à lui offrir... Peut-être une torche... ?'), nl, !.

lister_NPC(salle3) :-
        write('Vous pouvez parler à la secrétaire.'), nl, nl,
		write('Elle a l''air sympathique, allons-y !'), nl, !.

lister_NPC(salle5) :- 
		write('Vous pouvez parler au directeur.'), nl.
        write('À l''est vous pouvez revenir sur le balcon.'), nl.
		
decrire(salle8) :-
        write('Vous vous trouvez dans la salle des archives'), nl,
        write('À l''ouest vous pouvez revenir sur le balcon.'), nl.
		
decrire(escalierEtage) :-		
        write('Vous vous trouvez au niveau de l''escalier du premier étage.'), nl,
        write('Vous pouvez descendre au rez-de-chaussée ou'), nl.
		write('aller à l''étage au sud.'), nl.

/* Règles pour indiquer tous les objets et tous les NPC autour du joueur */

lister_objets(Endroit) :-
        il_y_a(X, Endroit),
        write('Il y a un(e) '), write(X), write(' ici.'), nl,
        fail.

lister_objets(_).

lister_NPC(Endroit) :-
        est_present(X, Endroit),
        write('Vous pouvez parler au / à la '), write(X), write(' ici.'), nl,
        fail.

lister_NPC(_).

/* Règles pour ramasser un objet */

ramasser(X) :-
        il_y_a(X, en_main),
        write('Ah mais c''est que j''ai déjà ça sur moi !'),
        nl, !.

ramasser(cle) :-
		il_y_a(X, Endroit),
        retract(il_y_a(X, Endroit)),
        assert(il_y_a(X, en_main)),
		je_possede(N),
		N =< 4,
		M is N+1,
		retract(je_possede(N)),
		assert(je_possede(M)),
        write('Désormais, je possède un(e) '), write(X), nl,
		write('Il faut que je la conserve précieusement'), nl,
		write('car si je la dépose, je ne suis pas sûr(e) de la retrouver...'),
        nl, !.

ramasser(X) :-
        je_suis_a(Endroit),
        il_y_a(X, Endroit),
        retract(il_y_a(X, Endroit)),
        assert(il_y_a(X, en_main)),
		je_possede(N),
		N =< 4,
		M is N+1,
		retract(je_possede(N)),
		assert(je_possede(M)),
        write('Désormais, je possède un(e) '), write(X),
        nl, !.

ramasser(_) :-
		je_possede(N),
		N > 4,
		write('Mince ! J''ai déjà 5 objets dans mon inventaire...'), nl,
		write('Il faut que je dépose quelque chose... Mais quoi ?'),
        nl, !.

ramasser(_) :-
        write('Je suis bête... Il n''y a rien ici.'),
        nl.

/* Règles pour déposer un objet */

deposer(cle) :-
        il_y_a(cle, en_main),
        retract(il_y_a(X, en_main)),
		je_possede(N),
		M is N-1,
		retract(je_possede(N)),
		assert(je_possede(M)),
        write('Flute, où est-ce qu''elle est tombée ! Elle a disparue !'), nl,
		write('Impossible de la récupérer maintenant...'), nl,
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
        write('Aaaah enfin, plus besoin de porter cet(tte) '), write(X),
        !, nl.

deposer(_) :-
        write('Mais mais... je n''ai pas encore ça sur moi !'),
        nl.

/* Règles pour parler à un NPC */

% Avec la secretaire

parler :-
		je_suis_a(salle3),
		il_y_a(formulaireZZZ, en_main),
		est_signe(formulaireZZZ),
		write('J''ai déjà signé le formulaire ZZZ... Vous pouvez dès à présent aller voir le directeur !'),
		nl, !.
  
parler :-
		je_suis_a(salle3),
		il_y_a(formulaireZZZ, en_main),
		assert(est_signe(formulaireZZZ)),
		write('Voilà ! Le formulaire ZZZ est signé. Vous pouvez dès à présent aller voir le directeur !'),
		nl, !.

parler :-
		je_suis_a(salle3),
		est_remis(formulaireWWW),
		est_remis(carte_visiteur),
		write('Désolée, je ne peux rien faire pour vous...'), nl, !.

parler :-
		je_suis_a(salle3),
		write('Bienvenue. Voici le formulaire WWW et la carte du visiteur. Cela pourrait vous être utile...'), nl,
		assert(est_remis(formulaireWWW)),
		assert(est_remis(carte_visiteur)),
		ramasser(formulaireWWW, en_main),
		ramasser(carte_visiteur, en_main).

% Avec le gardien

parler :-
		je_suis_a(salle7),
		il_y_a(formulaireYYY, en_main),
		write('Bonjour ! Je vais rester avec vous pour pouvoir vous ouvrir la porte de la bibliothèque.'),
		nl, !.

parler :-
		je_suis_a(salle7),
		il_y_a(torche, en_main),
		write('Bonjour ! C''est gentil de m''apporter une torche pour éclairer ma loge.'), nl,
		write('Malheureusement je ne peux rien faire pour vous'), nl,
		write('si vous n''avez pas le formulaire YYY...'),
		nl, !.

parler :-
		je_suis_a(salle7),
		write('Vous osez me déranger pour rien ! Comment osez-vous ?!!'), nl,
		write('Allez, direction la cage aux lions, et fissa !'), nl,
		mourir.

% Avec le directeur

parler :-
		je_suis_a(salle5),
		est_remis(passe_directeur),
		write('Qu''est-ce que vous me voulez encore ! C''est du harcelement !'), nl,
		write('Gardien, amenez-le à la cage aux lions !'), nl,
		mourir, !.

parler :-
		je_suis_a(salle5),
		il_y_a(formulaireZZZ, en_main),
		est_signe(formulaireZZZ),
		assert(est_remis(passe_directeur),
		write('Je vois que vous avez le formulaire ZZZ signé.'), nl,
		write('Je vous remets donc mon passe qui vous donnera accès à la salle des archives'), nl,
		ramasser(passe_directeur), !.

parler :-
		je_suis_a(salle5),
		il_y_a(formulaireZZZ, en_main),
		write('Vous débarquez d''où ? Il faut la signature de la secrétaire'), nl,
		write('sur le formulaire ZZZ. Le gardien va vous amener à la cage des lions...'), nl,
		mourir.

parler :-
		je_suis_a(salle5),
		write('Alors il va me falloir le formulaire ZZZ signé par la secrétaire.')
		write('Parce que là, je ne peux rien faire... Au revoir !'), nl.
		

/* Règle qui définit la mort */

mourir :-
        write('Argl ! Des lions affamés ! Au secours !'), nl,
		write('Aaaargl, bluurp, squick ! Je suis mort !!!'), terminer.

/* Règle pour afficher un message final */

terminer :-
        nl,
        write('La partie est terminée. Tapez la commande "halt."'),
        nl, !.

% Fin