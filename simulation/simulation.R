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

## Pour faire une petite vérification, on va tracer
## l'histogramme de l'échantillon et y superposer la véritable
## densité d'une exponentielle de paramètre lambda. Les deux
## graphiques devraient concorder.

## Tracé de l'histogramme. Il faut spécifier l'option 'prob =
## TRUE' pour que l'axe des ordonnées soit gradué en
## probabilités plutôt qu'en nombre de données. Sinon, le
## graphique de la densité que l'on va ajouter dans un moment
## n'apparaîtra pas sur le graphique.
hist(x, prob = TRUE) # histogramme gradué en probabilités

## Pour ajouter la densité, on a la très utile fonction
## curve() pour tracer une fonction f(x) quelconque. Avec
## l'option 'add = TRUE', le graphique est ajouté au graphique
## existant.
curve(dexp(x, rate = lambda), add = TRUE)

###
### EXEMPLE 2.4
###

## On trouvera ci-dessous une mise en oeuvre de l'algorithme
## d'acceptation-rejet pour simuler des observations d'une
## distribution Bêta(3, 2). La procédure est intrinsèquement
## itérative, alors nous devons utiliser une boucle. Il y a
## diverses manières de faire, j'ai ici utilisé une boucle
## 'repeat'; une autre mise en oeuvre est présentée dans les
## exercices.
##
## On remarque que le vecteur contenant les résultats est
## initialisé au début de la fonction pour éviter l'écueil de
## la «boîte à biscuits» expliqué à la section 4.5 du document
## de référence de la partie I.
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
## aléatoires. On peut en changer avec la fonction 'RNGkind'.
RNGkind("Wichmann-Hill")   # générateur de Excel
runif(10)                  # rien de particulier à voir
RNGkind("default")         # retour au générateur par défaut

## La fonction 'set.seed' est très utile pour spécifier
## l'amorce d'un générateur. Si deux simulations sont
## effectuées avec la même amorce, on obtiendra exactement les
## mêmes nombres aléatoires et, donc, les mêmes résultats.
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

## On peut échantillonner avec remise.
sample(1:10, 10, replace = TRUE)

## On peut aussi spécifier une distribution de probabilités
## non uniforme.
x <- sample(c(0, 2, 5), 1000, replace = TRUE,
            prob = c(0.2, 0.5, 0.3))
table(x)                   # tableau de fréquences

###
### MODÈLES ACTUARIELS COURANTS
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
hist(x, prob = TRUE)       # histogramme
curve(0.55 * dlnorm(x, 3.6, 0.6) +
      0.45 * dlnorm(x, 4.5, 0.3),
      add = TRUE, lwd = 2, col = "red3") # densité théorique

## Simulation d'un mélange de deux exponentielles (de moyennes
## 1/3 et 1/7) avec poids égal.
rmixture(10, 0.5, expression(rexp(3), rexp(7)))


## MÉLANGES CONTINUS

## Un mélange continu de deux variables aléatoires est créé
## lorsque l'on suppose qu'un paramètre d'une distribution f
## est une réalisation d'une autre variable aléatoire avec
## densité u, comme ceci:
##
## X|Theta = theta ~ f(x|theta)
##           Theta ~ u(theta)
##
## Ce genre de modèle est fréquent en analyse bayesienne et
## souvent utilisé en actuariat. Certaines lois de probabilité
## sont aussi uniquement définies en tant que mélanges.
##
## L'intérêt, ici, est d'obtenir des observations de la
## variable aléatoire non conditionnelle X. L'algorithme de
## simulation est simple:
##
## 1. Simuler un nombre theta de la distribution de Theta.
## 2. Simuler une valeur x de la distribution de
##    X|Theta = theta.
##
## Ce qu'il importe de remarquer dans l'algorithme ci-dessus,
## c'est que le paramètre de mélange (theta) change pour
## chaque observation simulée. Autrement il n'y a juste pas de
## mélange, on obtient simplement un échantillon de la
## distribution f(x|theta).
##
## Les mélanges continus sont simples à faire en R puisque les
## fonctions de simulation sont vectorielles. Par exemple,
## simulons 1000 observations du mélange
##
## X|Theta = theta ~ Poisson(theta)
##           Theta ~ Gamma(5, 4)
theta <- rgamma(1000, 5, 4) # 1000 paramètres de mélange...
x <- rpois(1000, theta)     # ... pour 1000 Poisson différentes

## On peut écrire le tout en une seule expression.
x <- rpois(1000, rgamma(1000, 5, 4))

## On peut démontrer que la distribution non conditionnelle de
## X est une binomiale négative de paramètres 5 et 4/(4 + 1) =
## 0,8. Faisons une vérification empirique. On calcule d'abord
## le tableau de fréquences des observations de l'échantillon
## avec la fonction 'table'. Il existe une méthode de 'plot'
## pour les tableaux de fréquences.
(p <- table(x))            # tableau de fréquences
plot(p/length(x))          # graphique

## On ajoute au graphique les masses de probabilités théoriques.
(xu <- unique(x))          # valeurs distinctes de x
points(xu, dnbinom(xu, 5, 0.8), pch = 21, bg = "red3")


## CONVOLUTIONS

## Une convolution est la somme de deux variables aléatoires
## indépendantes. De manière générale, une convolution est
## très compliquée à évaluer, même numériquement. Certaines
## convolutions sont toutefois bien connues:
##
## 1. une somme de Bernoulli est une binomiale;
## 2. une somme de géométriques est une binomiale négative;
## 3. une somme d'exponentielles est une gamma;
## 4. une somme de Poisson est une Poisson;
## 5. une somme de normales est une normale, etc.
##
## On peut utiliser ces résultats pour simuler des
## observations de certaines lois.
##
## Par exemple, pour simuler une observation d'une
## distribution Gamma(alpha, lambda), on peut sommer alpha
## observations d'une Exponentielle(lambda). Ces dernières
## sont obtenues par la méthode de l'inverse.
alpha <- 5
lambda <- 2
- sum(log(runif(alpha)))/lambda # une observation de la gamma

## Pour simuler un échantillon de taille n de la gamma, il
## faut simuler n * alpha observations de l'exponentielle. Il
## existe des algorithmes plus efficaces pour simuler d'une
## loi gamma.
n <- 1000                  # taille de l'échantillon
x <- - rowSums(matrix(log(runif(n * alpha)),
                      nrow = n))/lambda
hist(x, prob = TRUE)       # histogramme
curve(dgamma(x, alpha, lambda),
      add = TRUE, lwd = 2, col = "red3") # densité théorique

## La simulation peut aussi servir à estimer des
## caractéristiques de la distribution d'une convolution
## difficiles à calculer explicitement. Par exemple, supposons
## que l'on a
##
## X ~ Gamma(3, 4)
## Y ~ Gamma(5, 2)
##
## et que l'on souhaite calculer le 95e centile de X + Y. Il
## n'y a pas de solution explicite pour la distribution de X +
## Y puisque les deux lois gamma n'ont pas le même paramètre
## d'échelle (lambda). Procédons donc par simulation pour
## obtenir une approximation du résultat.
x <- rgamma(10000, 3, 4)   # échantillon de la première loi
y <- rgamma(10000, 5, 2)   # échantillon de la deuxième loi
quantile(x + y, 0.95)      # 95e centile de la convolution

## Il est laissé en exercice de faire le même calcul avec Excel.
