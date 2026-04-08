# Pathfinding Algorithms in Julia

Projet réalisé dans le cadre du projet d'informatique.

L’objectif est d’implémenter et d’étendre des algorithmes de recherche de chemin sur des cartes , puis de gérer plusieurs robots (AMR) en évitant les collisions.

---

# Phase 1 — Pathfinding classique

Algorithmes implémentés :

- BFS (Breadth-First Search)
- Dijkstra
- A*
- Greedy Best-First Search

Ces algorithmes permettent de calculer un chemin optimal entre deux points sur une grille.

---

# Optimisation A*

Avant la phase 2, l’implémentation de A* a été améliorée :

- passage d’une recherche linéaire → PriorityQueue
- complexité fortement réduite
- comportement conforme à l’implémentation théorique

---

# Phase 2 — Multi-AMR

Extension du projet pour gérer **plusieurs robots simultanément**.

## Objectif

Planifier des missions :
- sans collision (même case au même temps)
- sans swap (échange de position simultané)
- avec un coût minimal

---

## Approche

Utilisation d’un **A* spatio-temporel** :

- état = (i, j, t)
- le temps est intégré dans la recherche
- contraintes dynamiques

---

## Contraintes

Deux types de contraintes sont utilisés :

### Node constraint
Interdit une position à un instant donné  
→ évite les collisions directes

### Edge constraint
Interdit un mouvement à un instant donné  
→ évite les swaps (A ↔ B)

---

## Attente

Une action d’attente est introduite :

- permet d’éviter des détours inutiles
- coût volontairement faible (0.5)
- améliore la faisabilité dans les zones congestionnées

---

## Stratégie Multi-AMR

Planification **séquentielle** :

1. planifier AMR 1
2. transformer son chemin en contraintes
3. planifier AMR 2 avec contraintes
4. etc.

- simple  
- robuste  
mais dépend de l’ordre → pas optimal globalement

---

## Structures principales

- `AMR` : robot
- `Quai` : point logique sur la carte
- `Mission` : déplacement entre quais
- `Constraint` : contrainte de position
- `EdgeConstraint` : contrainte de mouvement

---

## Pipeline global

1. A* spatio-temporel
2. reconstruction du chemin
3. ajout du temps (`pathWithTime`)
4. génération des contraintes
5. planification du robot suivant

---

# Scénarios disponibles

Plusieurs scénarios permettent de tester différents comportements :

### 1 — Demo (conflits)
- collisions frontales
- congestion

### 2 — Goulot strict
- passage étroit
- forte contention

### 3 — Swap demo
- démontre l’interdiction de swap

### 4 — No collision
- aucun conflit
- comportement nominal

### 5 — Wait demo
- montre que l’attente est nécessaire

### 6 — Sequential demo
- montre l’impact de l’ordre de planification

---

# Structure du projet

- `dat/`
  - `crossdock/` : maps de la phase 2
    - `demo_oral.map`
    - `goulot_strict.map`
    - `swap_demo.map`
    - `no_collision.map`
    - `wait_demo.map`
    - `sequential_demo.map`
    - `crossdock.map`
    - `crossdock14.map`
    - `crossdock_simple.map`
  - `street-map/` : maps MovingAI de benchmark
  - `didactic.map`

- `src/`
  - `utils.jl`
  - `bfs.jl`
  - `dijkstra.jl`
  - `astar.jl`
  - `astar_phase1.jl`
  - `greedy.jl`
  - `multi_amr.jl`

- `scenarios.jl` : définition des scénarios AMR
- `main.jl` : point d’entrée de la phase 2
- `main_phase1.jl` : point d’entrée de la phase 1
- `doc/rapport.md` : rapport
- `res/experiments.md` : résultats expérimentaux
- `test/` : fichiers de test

---

# Dépendances

Installer le package nécessaire :

```julia
import Pkg
Pkg.add("DataStructures")
---

# Exécution

## Phase 1

Lancer Julia puis :

include("main_phase1.jl")

Puis utiliser :

runAlgo("Astar", "dat/street-map/Paris_2_256.map", (10,10), (200,200))

---

## Phase 2 — Multi-AMR

Lancer :

include("main.jl")

Puis choisir un scénario :

1 - Demo (conflits)  
2 - Goulot strict  
3 - Swap demo  
4 - No collisions  
5 - Wait demo  
6 - Sequential demo  

---

# Description des modules

## utils.jl

Fonctions utilitaires :

- lecture des maps (.map)
- récupération des voisins
- coût de déplacement
- heuristique de Manhattan

---

## bfs.jl

Algorithme BFS :

- exploration par niveaux
- optimal si coût uniforme

---

## dijkstra.jl

Algorithme de Dijkstra :

- gère les coûts pondérés
- garantit un chemin optimal

---

## astar_phase1.jl

A* classique :

- heuristique de Manhattan
- optimisation avec PriorityQueue

---

## astar.jl

A* spatio-temporel :

- état = (position + temps)
- gestion des contraintes
- gestion de l’attente
- évite collisions et swaps

---

## multi_amr.jl

Gestion multi-robots :

- planification séquentielle
- génération des contraintes
- simulation visuelle
- gestion des missions

---

## scenarios.jl

Définit les scénarios de test :

- conflits
- goulots
- swap
- attente
- ordre de planification

---

# Limites du projet

- dépend de l’ordre des AMR  
- solution non optimale globalement  
- pas de replanification globale  
- approche séquentielle simplifiée  

---

# Améliorations possibles

- priorisation intelligente des AMR  
- replanification dynamique  
- CBS (Conflict-Based Search)  
- parallélisation  
- optimisation des coûts  

---

# Conclusion

Projet combinant :

- pathfinding classique  
- gestion multi-robots  
- contraintes spatio-temporelles  

Avec plusieurs scénarios permettant d’illustrer :

- les collisions  
- les swaps  
- l’importance de l’attente  
- l’impact de la planification séquentielle  

Le projet montre bien le passage d’un problème simple (1 robot) à un problème complexe (multi-agents contraints).