﻿/* Prérequis */

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

/* Définition de l’environnement */

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

chemin(escalierEtage, s, croisementEtage) :- je_monte(N), M is N-1, correct(M).
chemin(escalierEtage, s, croisementEtage) :- fail.
chemin(escalierEtage, d, escalierRdc).

chemin(croisementEtage, e, couloirDroitEtage).
chemin(croisementEtage, o, couloirGaucheEtage).
chemin(croisementEtage, n, escalierEtage).
chemin(croisementEtage, s, balcon).

chemin(couloirDroitEtage, n, salle6) :- il_y_a(carte_visiteur, en_main), avec(gardien).
chemin(couloirDroitEtage, n, salle6) :- nl, write("Impossible ! Il faut la carte du visiteur !"), nl, fail.
chemin(couloirDroitEtage, o, croisementEtage).

chemin(couloirGaucheEtage, n, salle5).
chemin(couloirGaucheEtage, e, croisementEtage).

chemin(salle5, s, couloirGaucheEtage).
chemin(salle6, s, couloirDroitEtage).
chemin(salle7, e, balcon).
chemin(salle8, o, balcon).

chemin(balcon, o, salle7).
chemin(balcon, e, salle8) :- il_y_a(passe_directeur, en_main).
chemin(balcon, e, salle8) :- nl, write("Impossible ! Il faut le passe du directeur !"), nl, fail.
chemin(balcon, n, croisementEtage).

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

/* Règles pour afficher l’inventaire */

afficher([T]) :- write("  - "), write(T), nl, !.
afficher([T|Q]) :- write("  - "), write(T), nl, afficher(Q).

inventaire :- findall(X, il_y_a(X, en_main), L),
        nl, write("Voici ce que je porte :"),
        nl, afficher(L),
        nl.

/* Définition des directions */

% Nord, Sud, Est, Ouest

n :- aller(n).
s :- aller(s).
e :- aller(e).
o :- aller(o).

% Monter, Descendre

d :- aller(d).
m :- aller(m),
        nl, write("Si vous voulez continuer, il faut répondre à la question posée pour le Sphinx."),
        nl, write("Vous avez 2 essais pour répondre. En cas d’échec, c’est la mort assurée"),
        nl, je_monte(N), question(N).

/* Règle pour se déplacer dans une direction donnée */

aller(Direction) :-
        je_suis_a(Ici),
        chemin(Ici, Direction, Labas),
        retract(je_suis_a(Ici)),
        assert(je_suis_a(Labas)),
        regarder, !.

aller(_) :-
        nl, write("Vous ne pouvez pas aller dans cette direction..."), nl.

/* Règle pour regarder autour de soi */

regarder :-
        je_suis_a(Endroit),
        decrire(Endroit),
        lister_objets(Endroit),
        lister_NPC(Endroit),
        !.

/* Règles pour afficher la ou les description(s) de l’environnement */

% Rez-de-chaussée

decrire(entree) :-
        nl, write("Vous vous trouvez à l’entrée du bâtiment, au rez-de-chaussée."),
        nl, write("Au nord se trouve le croisement de 2 couloirs."),
        nl.
        
decrire(entree) :-
        il_y_a(laissez-passer_A-38, en_main),
        nl, write("Bravo ! Vous avez gagné ! Vous allez afin pouvoir sortir de ce bâtiment de fous !"),
        nl, terminer, !.

decrire(croisementRdc) :-
        nl, write("Vous êtes au croisement du rez-de-chaussée."),
        nl, write("Au nord se trouve un escalier gardé par un méchant sphinx."),
        nl, write("À l’est comme à l’ouest, vous pouvez vous engader dans un sombre couloir"),
        nl.

decrire(couloirGaucheRdc) :-
        nl, write("Vous êtes dans un couloir minion."),
        nl, write("Deux salles s’ouvrent à vous au sud et au nord."),
        nl, write("À l’est se trouve le croisement."),
        nl.

decrire(couloirDroitRdc) :-
        nl, write("Vous êtes dans un couloir sombre."),
        nl, write("Deux salles s’ouvrent à vous au sud et au nord."),
        nl, write("À l’ouest se trouve le croisement."),
        nl.

decrire(salle1) :- 
        nl, write("Vous êtes dans une sombre salle."),
        nl, write("La sortie se trouve au sud."),
        nl.

decrire(salle2) :- 
        nl, write("Vous êtes dans un salle dans laquelle sont posées au sol"),
        nl, write("deux coffres fermés à clé."),
        nl, write("La porte de sortie se trouve au sud."),
        nl.

decrire(salle2) :- 
        il_y_a(cle, en_main),
        nl, write("Vous êtes dans un salle dans laquelle sont posées au sol"),
        nl, write("deux coffres contenant des objets qui seront peut-être utiles !"),
        nl, write("La porte de sortie se trouve au sud."),
        nl.

decrire(salle3) :- 
        nl, write("Vous avez trouvé l’accueil !"),
        nl, write("Pour partir, prenez la porte qui se trouve au nord."),
        nl.

decrire(salle3) :- 
        il_y_a(laissez-passer_R-24, en_main),
        nl, write("Vous êtes à l’accueil !"),
        nl, write("Vous pouvez faire signer ici le laissez-passer _R-24."),
        nl, write("Pour partir, prenez la porte qui se trouve au nord."),
        nl.

decrire(salle4) :- 
        nl, write("Vous êtes entré dans la cage des lions !"),
        nl, write("Vous mourrez dans d’atroces souffrances..."),
        nl, mourir, !.

decrire(escalierRdc) :-
        nl, write("Vous vous trouvez dans un majestueux escalier vraiment très haut."),
        nl, write("Vous pouvez monter à l’étage à vos riques et périls,"),
        nl, write("ou aller au rez-de-chaussée au sud"),
        nl.

% Étage

decrire(croisementEtage) :-
        nl, write("Vous vous trouvez au croisement du première étage."),
        nl, write("Au nord se trouve l’escalier qui conduit au rez-de-chaussée."),
        nl, write("À l’est se trouve le couloir de droite"),
        nl, write("À l’ouest se trouve le couloir de gauche."),
        nl, write("Au sud, se trouve le balcon."),
        nl.

decrire(couloirDroitEtage) :-
        nl, write("Vous êtes au niveau du couloir droit du premier étage."),
        nl, write("Au nord se trouve la bibliothèque dont l’accès semble réservé au personnel."),
        nl, write("À l’ouest se trouve le croisement des couloirs du premier étage."),
        nl, !.
        
decrire(couloirGaucheEtage) :-
        nl, write("Vous vous trouvez au niveau du couloir gauche du premier étage."),
        nl, write("Au nord se trouve le bureau du directeur."),
        nl, write("Au sud se trouve la loge du gardien."),
        nl, write("À l’est se trouve le croisement des couloirs du premier étage."),
        nl.
        
decrire(balcon) :-
        nl, write("Vous êtes sur le balcon."),
        nl, write("Au nord se trouve le croisement des couloirs du premier étage."),
        nl, write("À l’est, se trouve la salle des archives."),
        nl, write("À l’ouest, se trouve la loge du gardien."),
        nl, !.
    
decrire(salle5) :-
        nl, write("Vous vous trouvez dans le bureau du directeur"),
        nl, write("qui a l’air enjoint à vous recevoir..."),
        nl, write("Vous pouvez le quitter par la porte qui est au sud."),
        nl.
    
decrire(salle6) :-
        avec(gardien),
        nl, write("Vous êtes dans la bibliothèque."),
        nl, write("Vous pouvez partir par la porte qui se trouve au sud."),
        nl, !.

decrire(salle6) :-
        nl, write("Vous êtes dans la bibliothèque."),
        nl, write("Une alarme se déclenche... et le gardien arrive."),
        nl, write("Il vous conduit directement à la cage aux lions"),
        nl, mourir.

decrire(salle7) :-
        il_y_a(torche, en_main),
        est_present(gardien, salle7),
        nl, write("Vous vous trouvez dans la loge du gardien."),
        nl, write("Et si je lui offrait la torche que j’ai en main."),
        nl, !.

decrire(salle7) :-
        est_present(gardien, salle7),
        nl, write("Vous vous trouvez dans la loge du gardien."), 
        nl, write("Il semblerait qu’il ne soit pas commode,"),
        nl, write("mieux voudrait, revenir lorsque j’aurai quelque chose"), 
        nl, write("à lui offrir... Peut-être une torche... ?"),
        nl, !.

decrire(salle7) :-
        nl, write("Vous êtes dans la loge du gardien qui n’est pas ici..."),
        nl, write("Il n’y a rien pour vous ici..."),
        nl, write("mieux vaudrait revenir sur vos pas..."),
        nl.

decrire(salle8) :-
        nl, write("Vous vous trouvez dans la salle des archives"),
        nl, write("À l’ouest vous pouvez revenir sur le balcon."),
        nl.
        
decrire(escalierEtage) :-        
        nl, write("Vous vous trouvez au niveau de l’escalier du premier étage."),
        nl, write("Vous pouvez descendre au rez-de-chaussée ou"),
        nl, write("aller à l’étage au sud."),
        nl.

/* Règles pour indiquer tous les objets et tous les NPC autour du joueur */

% Objets

lister_objets(Endroit) :-
        il_y_a(X, Endroit),
        nl, write("Il y a un(e) "), write(X), write(" ici."),
        nl, fail.

lister_objets(_).

% NPC

lister_NPC(Endroit) :-
        est_present(X, Endroit),
        nl, write("Vous pouvez parler au / à la "), write(X), write(" ici."),
        nl, fail.

lister_NPC(_).

/* Règles pour ramasser un objet */

ramasser(X) :-
        il_y_a(X, en_main),
        nl, write("Ah mais c’est que j’ai déjà ça sur moi !"),
        nl, !.

ramasser(cle) :-
        il_y_a(cle, Endroit),
        retract(il_y_a(cle, Endroit)), assert(il_y_a(cle, en_main)),
        je_possede(N),
        N =< 4, M is N+1,
        retract(je_possede(N)), assert(je_possede(M)),
        nl, write("Désormais, je possède un(e) cle"),
        nl, write("Il faut que je la conserve précieusement"),
        nl, write("car si je la dépose, je ne suis pas sûr(e) de la retrouver..."),
        nl, !.

ramasser(X) :-
        je_suis_a(Endroit),
        il_y_a(X, Endroit),
        retract(il_y_a(X, Endroit)), assert(il_y_a(X, en_main)),
        je_possede(N),
        N =< 4, M is N+1,
        retract(je_possede(N)), assert(je_possede(M)),
        nl, write("Désormais, je possède un(e) "), write(X),
        nl, !.

ramasser(X) :-
        je_suis_a(Endroit),
        il_y_a(X, Endroit),
        retract(il_y_a(X, Endroit) :- il_y_a(cle, en_main)), assert(il_y_a(X, en_main)),
        je_possede(N),
        N =< 4, M is N+1,
        retract(je_possede(N)), assert(je_possede(M)),
        nl, write("Désormais, je possède un(e) "), write(X),
        nl, !.

ramasser(_) :-
        je_possede(N),
        N > 4,
        nl, write("Mince ! J’ai déjà 5 objets dans mon inventaire..."),
        nl, write("Il faut que je dépose quelque chose... Mais quoi ?"),
        nl, !.

ramasser(_) :-
        nl, write("Je suis bête... Il n’y a rien ici."),
        nl.

/* Règles pour déposer un objet */

deposer(cle) :-
        il_y_a(cle, en_main),
        retract(il_y_a(cle, en_main)),
        je_possede(N),
        M is N-1,
        retract(je_possede(N)), assert(je_possede(M)),
        nl, write("Flute, où est-ce qu’elle est tombée ! Elle a disparue !"),
        nl, write("Impossible de la récupérer maintenant..."),
        nl, !.

deposer(X) :-
        il_y_a(X, en_main),
        je_suis_a(Endroit),
        retract(il_y_a(X, en_main)), assert(il_y_a(X, Endroit)),
        je_possede(N),
        M is N-1,
        retract(je_possede(N)), assert(je_possede(M)),
        nl, write("Aaaah enfin, plus besoin de porter cet(tte) "), write(X),
        nl, !.

deposer(_) :-
        nl, write("Mais mais... je n’ai pas encore ça sur moi !"),
        nl.

/* Règles pour parler à un NPC */

% Avec la secretaire

parler :-
        je_suis_a(salle3),
        il_y_a(laissez-passer_R-24, en_main),
        est_signe(laissez-passer_R-24),
        nl, write("J’ai déjà signé le laissez-passer R-24..."),
        nl, write("Vous pouvez dès à présent aller voir le directeur !"),
        nl, !.
  
parler :-
        je_suis_a(salle3),
        il_y_a(laissez-passer_R-24, en_main),
        assert(est_signe(laissez-passer_R-24)),
        nl, write("Voilà ! Le laissez-passer R-24 est signé."),
        nl, write("Vous pouvez dès à présent aller voir le directeur !"),
        nl, !.

parler :-
        je_suis_a(salle3),
        est_remis(laissez-passer_M-47),
        est_remis(carte_visiteur),
        nl, write("Désolée, je ne peux rien faire pour vous..."),
        nl, !.

parler :-
        je_suis_a(salle3),
        nl, write("Bienvenue. Voici le laissez-passer M-47"),
        nl, write("et la carte du visiteur."),
        nl, write("Cela pourrait vous être utile..."),
        nl,
        assert(il_y_a(laissez-passer_M-47, en_main)),
        assert(il_y_a(carte_visiteur, en_main)),
        je_possede(N),
        N =< 3, M is N+2,
        retract(je_possede(N)), assert(je_possede(M)),        
        assert(est_remis(laissez-passer_M-47)),
        assert(est_remis(carte_visiteur)),
        nl, write("Désormais, je possède un(e) laissez-passer_M-47"),
        nl, write("et un(e) carte_visiteur."),
        nl, !.

parler :-
        je_suis_a(salle3),
        nl, write("Vous êtes bien chargé..."),
        nl, write("Revenez lorsque vous aurez moins de choses..."),
        nl, !.

% Avec le gardien

parler :-
        je_suis_a(salle7),
        il_y_a(laissez-passer_W-51, en_main),
        assert(avec(gardien)),
        retractall(est_present(gardien, salle7)),
        nl, write("Bonjour ! Je vais rester avec vous"),
        nl, write("pour pouvoir vous ouvrir la porte de la bibliothèque."),
        nl, !.

parler :-
        je_suis_a(salle7),
        il_y_a(torche, en_main),
        nl, write("Bonjour ! C’est gentil de m’apporter une torche pour éclairer ma loge."),
        nl, write("Malheureusement je ne peux rien faire pour vous"),
        nl, write("si vous n’avez pas le laissez-passer W-51..."),
        nl, !.

parler :-
        je_suis_a(salle7),
        nl, write("Vous osez me déranger pour rien ! Comment osez-vous ?!!"),
        nl, write("Allez, direction la cage aux lions, et fissa !"),
        nl, mourir.

% Avec le directeur

parler :-
        je_suis_a(salle5),
        est_remis(passe_directeur),
        nl, write("Qu’est-ce que vous me voulez encore ! C’est du harcelement !"),
        nl, write("Gardien, amenez-le à la cage aux lions !"),
        nl, mourir, !.

parler :-
        je_suis_a(salle5),
        il_y_a(laissez-passer_R-24, en_main),
        est_signe(laissez-passer_R-24),
        assert(est_remis(passe_directeur)),
        nl, write("Je vois que vous avez le laissez-passer R-24 signé."),
        nl, write("Je vous remets donc mon passe qui vous donnera accès à la salle des archives"),
        nl, ramasser(passe_directeur), !.

parler :-
        je_suis_a(salle5),
        il_y_a(laissez-passer_R-24, en_main),
        nl, write("Vous débarquez d’où ? Il faut la signature de la secrétaire"),
        nl, write("sur le laissez-passer R-24. Gardien ! Amenez-les à la cage des lions..."),
        nl, mourir.

parler :-
        je_suis_a(salle5),
        nl, write("Alors il va me falloir le laissez-passer R-24 signé par la secrétaire."),
        nl, write("Parce que là, je ne peux rien faire... Au revoir !"),
        nl.

/* Règles pour commencer une partie */

mode_emploi :-
        nl, write("Entrez les commandes avec la syntaxe Prolog standard."),
        nl, write("Les commandes disponibles sont :"),
        nl, write("demarrer.          -- pour commencer une partie"),
        nl, write("n. s. e. o. m. d.  -- pour aller dans une direction"),
        nl, write("ramasser(Objet).   -- pour ramasser un objet"),
        nl, write("deposer(Objet).    -- pour laisser tomber un objet"),
        nl, write("parler.            -- pour parler à un NPC"),
        nl, write("regarder.          -- pour regarder de nouveau autour de vous"),
        nl, write("repondre(Reponse). -- pour répondre aux énigmes du Sphinx"),
        nl, write("inventaire.        -- pour afficher ce que vous portez"),
        nl, write("mode_emploi.       -- pour afficher le mode d’emploi de nouveau"),
        nl, write("consigne.          -- pour afficher l’objectif du jeu de nouveau"),
        nl, write("terminer.          -- pour terminer la partie"),
        nl.

consigne :-
        nl, write("Vous êtes Idéfix, le petit chien d’Obélix."),
        nl, write("Vous, votre maître et Astérix êtes enfermés de nouveau"),
        nl, write("dans la maison qui rend fou des 12 travaux d’Astérix."),
        nl, write("Votre but est de revenir à votre point de départ muni"),
        nl, write("du laissez-passer A-38. Bonne chance !"),
        nl.

demarrer :- mode_emploi, consigne, regarder.

/* Règle qui définit la mort */

mourir :-
        nl, write("Argl ! Des lions affamés ! Au secours !"),
        nl, write("Aaaargl, bluurp, squick ! Je suis mort !!!"),
        nl, terminer.

/* Règle pour afficher un message final */

terminer :-
        nl, write("La partie est terminée. Tapez la commande "halt.""),
        nl, !.

/* Questions, réponses et justifications des énigmes du Sphinx */

% Réponses

reponse(0, a).
reponse(1, b).
reponse(2, c).
reponse(3, a).
reponse(4, d).
reponse(5, b).
reponse(6, d).
reponse(7, c).
reponse(8, c).
reponse(9, a).
reponse(10, b).

% Questions

question(0) :-
        nl, write("Voici la question : Pierre dort à partir de 8h du soir,"),
        nl, write("il a réglé son réveil analogique sur 10h parce qu’il doit se lever le lendemain."),
        nl, write("Pierre va dormir combien d’heures ?"),
        nl, write("  a : 2 heures"),
        nl, write("  b : 12 heures"),
        nl, write("  c : 10 heures"),
        nl, write("  d : 14 heures"),
        nl.

question(1) :-
        nl, write("Une poule et demi pond un œuf et demi en un jour et demi."),
        nl, write("Combien d’œufs pond une poule en trente jours ?"),
        nl, write("  a : 15 œufs"),
        nl, write("  b : 20 œufs"),
        nl, write("  c : 45 œufs"),
        nl, write("  d : 30 œufs"),
        nl.

question(2) :-
        nl, write("Annie a deux enfants, dont l’un est une fille. "),
        nl, write("Combien y a-t-il de chances que l’autre enfant soit un garçon ?"),
        nl, write("  a : 1 chance sur 3"),
        nl, write("  b : 1 chance sur 2"),
        nl, write("  c : 2 chance sur 3"),
        nl, write("  d : 1 chance sur 4"),
        nl.

question(3) :-
        nl, write("Le fils de cet homme est le père de mon fils.")
        nl, write("Sachant que je ne suis pas une femme,"),
        nl, write("quel est le lien de parenté entre cet homme et moi ?"),
        nl, write("  a : Je suis le fils de cet homme"),
        nl, write("  b : Je suis le père de cet homme"),
        nl, write("  c : Je suis le petit-fils de cet homme"),
        nl, write("  d : Je suis le cousin de cet homme"),
        nl.

question(4) :-
        nl, write("Sur une île de 100 habitants vivant le long d’un cercle, tous ont le même discours :"
        nl, write("“Je ne mens jamais mais mon voisin de gauche ment toujours.”"),
        nl, write("combien y-a-t il de menteurs ?"),
        nl, write("  a : 100"),
        nl, write("  b : 99"),
        nl, write("  c : 1"),
        nl, write("  d : 50"),
        nl.

question(5) :-
        nl, write("Un homme s’arrête, sort de son camion et fait 20 pas vers l’ouest,"),
        nl, write("tue un ours avec trois balles de carabine, reprend sa route toujours"),
        nl, write("vers l’ouest et fais 30 pas. Il arrive à son camion."),
        nl, write("De quelle couleur est l’ours ?"),
        nl, write("  a : Brun"),
        nl, write("  b : Blanc"),
        nl, write("  c : Noir"),
        nl, write("  d : Roux"),
        nl.

question(6) :-
        nl, write("Dans l’aquarium, il y a 7 thons, 2 baleines, 6 poissons clown,"),
        nl, write("2 requins bleus, 2 dauphins, 4 maquereaux."),
        nl, write("Combien y a-t-il de poissons en tout ?"),
        nl, write("  a : 23"),
        nl, write("  b : 17"),
        nl, write("  c : 21"),
        nl, write("  d : 19"),
        nl.

question(7) :-
        nl, write("Imaginons que vous ayez énormément d’amis (un nombre infini)."),
        nl, write("Le premier vient vous voir et vous demande 1/2 coupe de champagne."),
        nl, write("Le deuxième vous demande 1/4 de coupe du champagne. Le troisième demande 1/8. Etc"),
        nl, write("Combien devez-vous prévoir de coupe de champagne ?"),
        nl, write("  a : Une infinité"),
        nl, write("  b : 100"),
        nl, write("  c : 1"),
        nl, write("  d : 1/2"),
        nl.

question(8) :-
        nl, write("Dans un étang, il y a un nénuphar qui double de taille chaque jour."),
        nl, write("En sachant que le nénuphar remplit en ce moment 1/4 de la surface de l’étang,"),
        nl, write("dans combien de jours l’étang sera rempli en entier ?"),
        nl, write("  a : 4 jours"),
        nl, write("  b : 1 jour"),
        nl, write("  c : 2 jours"),
        nl, write("  d : 8 jours"),
        nl.

question(9) :-
        nl, write("Quelle est la moitié de 2 + 2 ?"),
        nl, write("  a : 3"),
        nl, write("  b : 2"),
        nl, write("  c : 1"),
        nl, write("  d : 4"),
        nl.

question(10) :-
        nl, write("Un escargot est dans un puits de 10 mètres. Il monte 3 mètres chaque jour"),
        nl, write("et descend 2 mètres chaque nuit. En combien de jours sera-t-il rendu en haut ?"),
        nl, write("  a : 4 jours"),
        nl, write("  b : 8 jours"),
        nl, write("  c : 10 jours"),
        nl, write("  d : 5 jours"),
        nl.

% Justifications

justification(0) :-
        nl, write("Réponse a : C’est un réveil analogique, c’est-à-dire un réveil à aiguilles."),
        nl, write("Ainsi, si Pierre met son réveil à 10h sur son réveil analogique,"),
        nl, write("il n’a pas de différence entre le soir et le matin. C’est donc bien 2h après."),
        nl.

justification(1) :-
        nl, write("Réponse b : En un jour et demi, une poule pond un œuf."),
        nl, write("Donc en 30 jours, elle pondra 30/1,5 = 20 œufs."),
        nl.

justification(2) :-
        nl, write("Réponse c : Soit Annie a une aînée et une benjamine, soit une aînée et un benjamin,"),
        nl, write("soit un aîné et une benjamine, soit un aîné et un benjamin."),
        nl, write("Sachant qu’elle a une fille, il y a 3 cas de figure possible."),
        nl, write("Et il y a deux cas dans lesquels, on a un garçon également."),
        nl, write("Annie a donc 2 chance sur 3 d’avoir un garçon comme deuxième enfant."),
        nl.

/* Règles pour répondre aux questions du Sphinx */

repondre(X) :-
        je_monte(N), reponse(N, X), !,
        nl, write("Réponse correcte, vous pouvez monter !"),
        nl, essai(M), M =< 1, retract(essai(M)), assert(essai(0)), assert(correct(N)),
        O is N+1, !, retract(je_monte(N)), assert(je_monte(O)).

repondre(_) :-
        essai(N), N < 1, !, M is N+1, retract(essai(N)), assert(essai(M)),
        nl, write("Réponse incorrecte... Plus qu’un essai !"), nl.

repondre(_) :-
        essai(N), N > 0,
        nl, write("C’est un échec ! Vous êtes condamné à mourir ! Ha ha ha ha."),
        nl, terminer.

% Fin
