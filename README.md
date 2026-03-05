# Pathfinding Algorithms in Julia

Projet réalisé dans le cadre du cours d’algorithmique.

L’objectif de ce projet est d’implémenter et de comparer plusieurs algorithmes de recherche de chemin sur des cartes au format MovingAI.

Algorithmes implémentés :

- BFS (Breadth-First Search)
- Dijkstra
- A*
- Greedy Best-First Search

---

# Structure du projet

Le projet est organisé de la manière suivante :

```
pathfinding-julia/
│
├── dat/              # cartes au format .map
│
├── src/              # implémentation des algorithmes
│   ├── utils.jl
│   ├── bfs.jl
│   ├── dijkstra.jl
│   ├── astar.jl
│   └── greedy.jl
│
├── doc/              # documentation et rapport
│   ├── rapport.md
│   └── experiments.md
│
├── main.jl           # point d’entrée du programme
│
├── res/              # résultats éventuels
│
└── test/             # fichiers de test
```

---

# Description des modules

## utils.jl

Ce module contient les fonctions utilitaires utilisées par tous les algorithmes :

- lecture des cartes `.map`
- génération des voisins accessibles
- calcul du coût de déplacement
- heuristique de Manhattan

---

## bfs.jl

Implémentation de l’algorithme **Breadth-First Search**.

Caractéristiques :

- exploration par niveaux
- optimal lorsque les coûts sont uniformes

---

## dijkstra.jl

Implémentation de **l’algorithme de Dijkstra**.

Caractéristiques :

- fonctionne avec des coûts pondérés
- garantit un chemin optimal

---

## astar.jl

Implémentation de **l’algorithme A\***.

Caractéristiques :

- utilise une heuristique (distance de Manhattan)
- réduit l’espace de recherche
- garantit un chemin optimal si l’heuristique est admissible

---

## greedy.jl

Implémentation de **Greedy Best-First Search**.

Caractéristiques :

- sélectionne le sommet avec l’heuristique minimale
- très rapide mais ne garantit pas l’optimalité

---

# Exécution du projet

Lancer Julia dans le dossier du projet puis charger le fichier principal :

```julia
include("main.jl")
```

La fonction principale permettant d’exécuter un algorithme est :

```julia
runAlgo(algoName, mapFile, start, goal)
```

Paramètres :

- `algoName` : `"BFS"`, `"Dijkstra"`, `"Astar"` ou `"Greedy"`
- `mapFile` : chemin du fichier `.map` situé dans le dossier `dat`
- `start` : position de départ `(i,j)`
- `goal` : position d’arrivée `(i,j)`

---

# Exemple d'exécution

```julia
runAlgo("Astar", "street-map/Paris_2_256.map", (10,10), (240,240))
```

Sortie typique :

```
Distance D → A : 488
Number of states evaluated : 14219
CPU time (s) : 1.38
```

---

# Résultats expérimentaux

Les comparaisons entre les algorithmes sont présentées dans le fichier :

```
doc/experiments.md
```

