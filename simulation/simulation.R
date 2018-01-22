### Emacs: -*- coding: utf-8; fill-column: 62; comment-column: 27; -*-
##
## Copyright (C) 2018 Vincent Goulet
##
## Ce fichier fait partie du projet
## "Méthodes numériques en actuariat avec R"
## https://github.com/vigou3/methodes-numeriques-en-actuariat
##
## Cette création est mise à disposition selon le contrat
## Attribution-Partage dans les mêmes conditions 4.0
## International de Creative Commons.
## http://creativecommons.org/licenses/by-sa/4.0/

###
### EXEMPLE 2.1
###

## Simulation un échantillon aléatoire d'une distribution
## exponentielle par la méthode de l'inverse.
lambda <- 5
x <- -log(runif(1000))/lambda

## Pour faire une petite vérification, nous allons tracer
## l'histogramme de l'échantillon et y superposer la véritable
## densité d'une exponentielle de paramètre lambda. Les deux
## graphiques devraient concorder.

## Tracé de l'histogramme. Il faut spécifier l'option 'prob =
## TRUE' pour que l'axe des ordonnées soit gradué en
## probabilités plutôt qu'en nombre de données. Sinon, le
## graphique de la densité que nous allons ajouter dans un
## moment n'apparaîtra pas sur le graphique.
hist(x, prob = TRUE) # histogramme gradué en probabilités

## Ajoutons maintenant la densité à l'aide de la très utile
## fonction 'curve' qui permet de tracer une fonction f(x)
## quelconque. Avec l'option 'add = TRUE', le graphique est
## ajouté au graphique existant.
curve(dexp(x, rate = lambda), add = TRUE)

###
### EXEMPLE 2.4
###

## Nous effectuons une mise en oeuvre de l'algorithme
## d'acceptation-rejet pour simuler des observations d'une
## distribution Bêta(3, 2). La procédure est intrinsèquement
## itérative, alors nous devons utiliser une boucle. Il y a
## diverses manières de faire, j'ai ici utilisé une boucle
## 'repeat'; une autre mise en oeuvre est présentée dans les
## exercices.
##
## Remarquez que le vecteur contenant les résultats est
## initialisé au début de la fonction pour éviter le Syndrôme
## de la plaque à biscuits expliqué au chapitre 6 de
## Goulet, V. «Programmer avec R», 2017.
rbeta.ar <- function(n)
{
    x <- numeric(n)        # initialisation du contenant
    g <- function(x)       # fonction enveloppante
        ifelse(x < 0.8, 2.5 * x, 10 - 10 * x)
    Ginv <- function(x)    # l'inverse de son intégrale
        ifelse(x < 0.8, sqrt(0.8 * x), 1 - sqrt(0.2 - 0.2 * x))

    i <- 0                 # initialisation du compteur
    repeat
    {
        y <- Ginv(runif(1))
        if (1.2 * g(y) * runif(1) <= dbeta(y, 3, 2))
            x[i <- i + 1] <- y # assignation et incrément
        if (i > n)
            break          # sortir de la boucle repeat
    }
    x                      # retourner x
}

## Vérification empirique pour voir si ça marche.
x <- rbeta.ar(1000)
hist(x, prob = TRUE)
curve(dbeta(x, 3, 2), add = TRUE)

###
### FONCTIONS DE SIMULATION DANS R
###

## La fonction de base pour simuler des nombres uniformes est
## 'runif'.
runif(10)                  # sur (0, 1) par défaut
runif(10, 2, 5)            # sur un autre intervalle
2 + 3 * runif(10)          # équivalent, moins lisible

## R est livré avec plusieurs générateurs de nombres
## aléatoires. Nous pouvons en changer avec la fonction
## 'RNGkind'.
RNGkind("Wichmann-Hill")   # générateur de Excel
runif(10)                  # rien de particulier à voir
RNGkind("default")         # retour au générateur par défaut

## La fonction 'set.seed' est très utile pour spécifier
## l'amorce d'un générateur. Si deux simulations sont
## effectuées avec la même amorce, nous obtiendrons exactement
## les mêmes nombres aléatoires et, donc, les mêmes résultats.
## Très utile pour répéter une simulation à l'identique.
set.seed(1)                # valeur sans importance
runif(5)                   # 5 nombres aléatoires
runif(5)                   # 5 autres nombres
set.seed(1)                # réinitialisation de l'amorce
runif(5)                   # les mêmes 5 nombres que ci-dessus

## Plutôt que de devoir utiliser la méthode de l'inverse ou un
## autre algorithme de simulation pour obtenir des nombres
## aléatoires d'une loi de probabilité non uniforme, R fournit
## des fonctions de simulation pour bon nombre de lois. Toutes
## ces fonctions sont vectorielles. Ci-dessous, P == Poisson
## et G == Gamma pour économiser sur la notation.
n <- 10                    # taille des échantillons
rbinom(n, 5, 0.3)          # Binomiale(5, 0,3)
rbinom(n, 1, 0.3)          # Bernoulli(0,3)
rnorm(n)                   # Normale(0, 1)
rnorm(n, 2, 5)             # Normale(2, 25)
rpois(n, c(2, 5))          # P(2), P(5), P(2), ..., P(5)
rgamma(n, 3, 2:11)         # G(3, 2), G(3, 3), ..., G(3, 11)
rgamma(n, 11:2, 2:11)      # G(11, 2), G(10, 3), ..., G(2, 11)

## La fonction 'sample' sert pour simuler d'une distribution
## discrète quelconque. Le premier argument est le support de
## la distribution et le second, la taille de l'échantillon
## désirée. Par défaut, l'échantillonnage se fait avec remise
## et avec des probabilités égales sur tout le support.
sample(1:49, 7)            # numéros pour le 7/49
sample(1:10, 10)           # permutation des nombres de 1 à 10
sample(1:10)               # idem, plus simple
sample(10)                 # idem, encore plus simple!

## Échantillonnage avec remise.
sample(1:10, 10, replace = TRUE)

## Distribution de probabilités non uniforme.
x <- sample(c(0, 2, 5), 1000, replace = TRUE,
            prob = c(0.2, 0.5, 0.3))
table(x)                   # tableau de fréquences

###
### MODÈLES ACTUARIELS
###

## Le paquetage actuar contient plusieurs fonctions de
## simulation de modèles actuariels. Nous allons fournir des
## exemples d'utilisation de ces fonctions dans la suite.
library(actuar)            # charger le paquetage

## MÉLANGES DISCRETS

## La clé pour simuler facilement d'un mélange discret en R
## consiste à réaliser que l'ordre des observations est sans
## importance et, donc, que l'on peut simuler toutes les
## observations de la première loi, puis toutes celles de la
## seconde loi.
##
## Reste à déterminer le nombre d'observations qui provient de
## chaque loi. Pour chaque observation, la probabilité qu'elle
## provienne de la première loi est p. Le nombre
## d'observations provenant de la première loi suit donc une
## distribution binomiale de paramètres n et p, où n est le
## nombre total d'observations à simuler.
##
## Voici un exemple de simulation d'observations du mélange
## discret de deux lois log-normales présenté dans le
## chapitre. Les paramètres de la première loi sont 3,6 et
## 0,6; ceux de la seconde loi sont 4,5 et 0,3. Le paramètre de
## mélange est p = 0,55.
n <- 10000                   # taille de l'échantillon
n1 <- rbinom(1, n, 0.55)     # quantité provenant de la loi 1
x <- c(rlnorm(n1, 3.6, 0.6),     # observations de la loi 1
       rlnorm(n - n1, 4.5, 0.3)) # observations de la loi 2
hist(x, prob = TRUE)             # histogramme
curve(0.55 * dlnorm(x, 3.6, 0.6) +
      0.45 * dlnorm(x, 4.5, 0.3),
      add = TRUE, lwd = 2, col = "red3") # densité théorique

## La fonction 'rmixture' du paquetage actuar offre une
## interface conviviale pour simuler des observations de
## mélanges discrets (avec un nombre quelconque de
## distributions).
##
## La fonction compte trois arguments:
##
## 'n': nombre d'observations à simuler;
## 'probs': vecteur de poids relatif de chaque modèle dans le
##          mélange (normalisé pour sommer à 1);
## 'models': vecteur d'expressions contenant les modèles
##           formant le mélange.
##
## La méthode de formulation des modèles est commune à toutes
## les fonctions de simulations de actuar. Il s'agit de
## fournir, sous forme d'expression non évaluée, des appels à
## des fonctions de simulation en omettant le nombre de
## valeurs à simuler.
##
## Pour illustrer, reprenons l'exemple ci-dessus avec
## 'rmixture'.
x <- rmixture(10000, probs = c(0.55, 0.45),
              models = expression(rlnorm(3.6, 0.6),
                                  rlnorm(4.5, 0.3)))

## Vérifions la validité de la fonction en superposant à
## l'histogramme de l'échantillon la densité théorique du
## mélange.
hist(x, prob = TRUE)                     # histogramme
curve(0.55 * dlnorm(x, 3.6, 0.6) +
      0.45 * dlnorm(x, 4.5, 0.3),
      add = TRUE, lwd = 2, col = "red3") # densité théorique

## Simulation d'un mélange de deux exponentielles (de moyennes
## 1/3 et 1/7) avec poids égal. Le vecteur de poids est
## recyclé automatiquement par 'rmixture'.
rmixture(10, 0.5, expression(rexp(3), rexp(7)))

## MÉLANGES CONTINUS

## La simulation des mélanges continus est simple à faire en R
## puisque les fonctions r<loi> sont vectorielles. Il suffit
## de simuler autant de paramètres de mélange que nous
## souhaitons obtenir d'observations de la distribution
## marginale.
##
## Reprenons ici l'exemple du texte, soit:
##
##   X|Theta = theta ~ Poisson(theta)
##             Theta ~ Gamma(5, 4)
##
## D'abord en deux étapes.
theta <- rgamma(1000, 5, 4) # 1000 paramètres de mélange...
x <- rpois(1000, theta)     # ... pour 1000 lois de Poisson

## Nous pouvons écrire le tout en une seule expression.
x <- rpois(1000, rgamma(1000, 5, 4))

## On peut démontrer (faites-le en exercice!) que la
## distribution non conditionnelle de X est une binomiale
## négative de paramètres 5 et 4/(4 + 1) = 0,8.
##
## Vérifions ce résultat empiriquement en calculant d'abord le
## tableau de fréquences des observations de l'échantillon
## avec la fonction 'table', puis en traçant le graphique des
## résultats. Il existe une méthode de 'plot' pour les
## tableaux de fréquences.
(p <- table(x))            # tableau de fréquences
plot(p/length(x))          # graphique (fréquences relatives)

## Ajoutons au graphique les masses de probabilités
## théoriques.
(xu <- unique(x))          # valeurs distinctes de x
points(xu, dnbinom(xu, 5, 0.8), pch = 21, bg = "red3")

## DISTRIBUTIONS COMPOSÉES

## La simulation des distributions composées S = X_1 + ... +
## X_N est une procédure intrinsèquement itérative puisque
## pour chaque observation de la variable aléatoire S, il faut
## d'abord connaitre le nombre d'observations à simuler de la
## variable aléatoire X, nombre obtenu de la distribution de
## la variable aléatoire N.
##
## Nous présentons deux techniques «manuelles» avant
## d'illustrer les fonctions 'rcomppois' et 'rcompound' du
## paquetage actuar.
##
## Considérons le cas d'une Poisson composée. Le paramètre de
## Poisson vaut 2 et la distribution de la variable aléatoire
## X est une Gamma(2, 1).
##
## Une première approche repose sur la fonction 'sapply'. Elle
## applique pour chaque observation de la loi de Poisson une
## fonction anonyme qui, elle, génère les observations x_1,
## ..., x_n et calcule la somme s = x_1 + ... + x_n.
sapply(rpois(10, 2), function(n) sum(rgamma(n, 2, 1)))

## Une approche alternative consiste à générer les
## observations de la loi de Poisson et toutes les
## observations de la loi gamma, à séparer ces dernières en
## catégories à l'aide de facteurs et à effectuer les sommes
## par catégorie. Il faut explicitement tenir compte, dans
## cette procédure, des cas où N = 0.
s <- numeric(10)               # contenant avec des 0
N <- rpois(10, 2)              # échantillon loi de Poisson
x <- rgamma(sum(N), 2, 1)      # échantillon loi gamma
f <- rep.int(seq_len(10), N)   # facteurs
s[which(N != 0)] <- tapply(x, f, sum) # sommes par catégorie
s                                       # résultats

## La seconde approche est moins intuitive que la première,
## mais elle s'avère plus simple à programmer de manière
## générale et, de plus, elle est un peu plus rapide.
n <- 1e6
system.time(sapply(rpois(n, 2), function(n) sum(rgamma(n, 2, 1))))
system.time({
    s <- numeric(n)
    N <- rpois(n, 2)
    x <- rgamma(sum(N), 2, 1)
    f <- rep.int(seq_len(n), N)
    s[which(N != 0)] <- tapply(x, f, sum);
    s})

## C'est l'approche utilisée par les fonctions 'rcomppois' et
## 'rcompound' de actuar.
rcomppois

## Nous pouvons simuler une Poisson composée de manière plus
## intuitive avec la fonction 'rcomppois'. Nous spécifions le
## modèle de variable aléatoire X comme dans 'rmixture'.
## Puisqu'il n'y a qu'un modèle à spécifier, il n'est pas
## nécessaire de le placer dans 'expression'.
rcomppois(10, 2, rgamma(2, 1))

## La fonction 'rcompound' permet de simuler des distributions
## composées générales où la distribution de fréquence est
## autre que la Poisson. Voici un exemple de binomiale
## négative composée.
rcompound(10, rnbinom(2, 0.2), rgamma(2, 1))
