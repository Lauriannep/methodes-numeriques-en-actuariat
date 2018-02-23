<!-- Emacs: -*- coding: utf-8; eval: (auto-fill-mode -1); eval: (visual-line-mode t) -*- -->

# Méthodes numériques en actuariat avec R

Ce projet regroupe les notes, le code informatique et les exercices
utilisés dans le cours [ACT-2002 Méthodes numériques en actuariat](https://www.ulaval.ca/les-etudes/cours/repertoire/detailsCours/act-2002-methodes-numeriques-en-actuariat.html)
à l'[École d'actuariat](https://www.act.ulaval.ca) de l'[Université
Laval](https://ulaval.ca).

Le projet compte trois documents de référence:

- Simulation stochastique;
- Analyse numérique;
- Algèbre linéaire.

## Auteur

Vincent Goulet, professeur titulaire, École d'actuariat, Université Laval

## Modèle de développement

Le processus de rédaction et de maintenance du projet se conforme au modèle [*Gitflow Workflow*](https://www.atlassian.com/git/tutorials/comparing-workflows#gitflow-workflow). Seule particularité: la branche *master* se trouve [sur GitHub]((https://github.com/vigou3/methodes-numeriques-en-actuariat)), alors que la branche de développement se trouve dans un [dépôt public](https://projets.fsg.ulaval.ca/git/scm/vg/methodes-numeriques-en-actuariat-develop) de la Faculté des sciences et de génie de l'Université Laval.

Prière de passer par ce dépôt pour proposer des modifications; consulter le fichier `COLLABORATION-HOWTO.md` dans le dépôt pour la marche à suivre.

## Composition du document

La production du document repose sur la programmation lettrée avec LaTeX et
[Sweave](https://stat.ethz.ch/R-manual/R-devel/library/utils/doc/Sweave.pdf). La composition du document, c'est-à-dire la transformation du code source vers le format PDF, requiert les outils suivants.

### LaTeX

LaTeX est l'un des systèmes de mise en page les plus utilisés dans le monde, particulièrement dans la production de documents scientifiques intégrant de multiples équations mathématiques, des graphiques, du code informatique, etc.

La composition d'un document requiert d'abord une distribution du système LaTeX. Nous recommandons la distribution [TeX Live](https://tug.org/texlive) administrée par le [TeX Users Group](https://tug.org/). 

- [Vidéo expliquant l'installation sur Windows](https://youtu.be/7MfodhaghUk)
- [Vidéo expliquant l'installation sur macOS](https://youtu.be/kA53EQ3Q47w)

Ensuite, des connaissances de base sur le fonctionnement de LaTeX sont nécessaires. Consulter [*Rédaction avec LaTeX*](https://vigou3.github.io/formation-latex-ul/), la formation LaTeX de l'Université Laval. 

>  *Rédaction avec LaTeX* est distribué avec TeX Live. 

Le moteur XeLaTeX est utilisé pour composer le document. 

### Polices de caractères

La compilation du document requiert les polices de caractères suivantes:

- [Lucida Bright OT, Lucida Math OT et Lucida Mono DK](https://tug.org/store/lucida/). Ces polices de très grande qualité sont payantes. La Bibliothèque de l'Université Laval détient une licence d'utilisation de cette police. Les étudiants et le personnel de l'Université peuvent s'en procurer une copie gratuitement en écrivant à [mailto:lucida@bibl.ulaval.ca].
- [Myriad Pro](https://fontsup.com/fr/family/myriad+pro.html) en versions *Regular*, *Bold*, *Italic* et *Bold Italic*. Cette police est normalement livrée avec Acrobat Reader.
- [Font Awesome](http://fontawesome.io/). Cette police fournit une multitude d'icônes et de symboles. Télécharger la plus récente version de la distribution et installer la police `fontawesome-webfont.ttf` du dossier `fonts`.

### Outils Unix additionnels

La composition du document de référence est rendue plus facile par l'utilisation de l'outil Unix standard `make`. Celui-ci n'est livré ni avec Windows, ni avec macOS.

#### Installation des outils sous Windows

Il y a différentes manières d'installer des outils Unix sous Windows. Nous recommandons l'environnement de compilation [MSYS2](http://www.msys2.org/).

- [Télécharger MSYS2](http://www.msys2.org/) (Windows seulement)

> Vous devez savoir si vous disposez d'[une version 32 ou 64 bits de Windows](https://support.microsoft.com/fr-ca/help/15056/windows-7-32-64-bit-faq) et choisir la distribution de MSYS2 en conséquence. 

Une fois l'installation de MSYS2 complétée (bien lire les instructions sur la page du projet), démarrer l'invite de commande MSYS et entrer

    pacman -S make

pour installer le paquetage additionnel.

#### Installation des outils sous macOS

Les outils Unix de compilation sont livrés avec XCode sous macOS. Pour pouvoir les utiliser depuis la ligne de commande, il faut installer les *Command Line Tools*. Entrer simplement à l'invite de commande du Terminal

    xcode-select --install

puis suivre les instructions.

### Lancement de la composition

Nous avons automatisé le processus de compilation avec l'outil Unix standard `make`. Le fichier `Makefile` fournit les recettes principales suivantes:

- `pdf` crée les fichiers `.tex` à partir des fichiers `.Rnw` avec Sweave et compile le document maître avec XeLaTeX;

- `zip` crée l'archive contenant le document et le code source des sections d'exemples;

- `release` crée une nouvelle version (*tag*) dans GitHub, téléverse les fichiers PDF et `.zip` et modifie les liens de la page web;

Question d'éviter les publications accidentelles, `make all` est équivalent à `make pdf`.

## Historique des versions

### 2018.02 (2018-02-23)

- Intégration des corrections soumises par les étudiantes et étudiants, principalement dans le document de la première partie.
- Nouveau fichier `COLLABORATEURS` contenant la liste des personnes ayant contribué à l'amélioration des documents.
- Correction du texte du paragraphe suivant l'algorithme 2.3.
- Au chapitre 2, le renvoi vers le code informatique à la fin de l'exemple 2.2 devait plutôt se trouver à la fin de l'exemple 2.5.
- Dans `simulation.R`, le code correspondant à l'exemple 2.5 était identifié à l'exemple 2.4.
- À l'exercice 2.17, parties d) et e), le premier paramètre de la distribution log-normale est changé de 7,1 à 7 pour éviter toute confusion dans l'énoncé, et de log(2000) à 7 dans la solution pour que la solution soit juste, quoi.

### 2018.01-1a (2018-01-24)

Corrections mineures de la version 2018.01-1. Aucun nouveau contenu.

- Correction de l'url de la vidéo sur la méthode d'acceptation-rejet au chapitre 2.
- Réduction de la taille d'une police sur la page frontispice.

### 2018.01-1 (2018-01-22)

Les documents de référence sont basés sur les versions de l'hiver 2016 des documents de référence des parties II à IV du cours ACT-2002 encore disponibles [dans le Portail libre](https://libre.act.ulaval.ca/index.php?id=448) de l'École d'actuariat. 

La présente édition contient une version révisée du document sur la
simulation stochastique. Les autres documents n'ont pas été modifiés.

- Les références à VBA ont à peu près toutes été supprimées du texte.
- Le chapitre 2 contient une nouvelle section sur la simulation de modèles actuariels.
- Le code informatique du chapitre 2 offre des exemples d'utilisation des fonctions de simulation du paquetage actuar.
- Style plus personnel utilisant le «nous» et le «vous» plutôt que le «on».

