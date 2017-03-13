
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

% Fin