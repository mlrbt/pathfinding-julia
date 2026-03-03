# Expériences – Étude comparative des algorithmes de recherche

## 1. Protocole expérimental

Les algorithmes BFS, Dijkstra, A* et Greedy Best-First Search ont été testés sur une carte réelle issue du dossier `street-map`.

- Carte : Paris_2_256.map
- Taille : 256 × 256
- Point de départ : (10,10)
- Point d’arrivée : (240,240)
- Coût des déplacements : uniforme (coût = 1 par mouvement)
- Heuristique utilisée (A* et Greedy) : distance de Manhattan

Les métriques observées sont :
- Distance du chemin trouvé
- Nombre d’états évalués
- Temps CPU

---

## 2. Résultats obtenus

### BFS

- Distance : 488
- États évalués : 41 308
- Temps CPU : 0.051 s

BFS trouve un chemin optimal puisque tous les coûts sont uniformes.  
Cependant, il explore une grande partie de l’espace de recherche.

---

### Dijkstra

- Distance : 488
- États évalués : 41 392
- Temps CPU : 3.887 s

Dijkstra trouve également le chemin optimal.  
Dans un graphe à coût uniforme, son comportement est similaire à BFS.  
Cependant, il est significativement plus lent en raison de l’utilisation d’une file de priorité.

---

### A*

- Distance : 488
- États évalués : 14 219
- Temps CPU : 1.386 s

A* trouve un chemin optimal.  
Grâce à l’heuristique (distance de Manhattan), il réduit fortement le nombre d’états explorés (environ 3 fois moins que BFS/Dijkstra).

---

### Greedy Best-First Search

- Distance : 572
- États évalués : 1 953
- Temps CPU : 0.0013 s

Greedy est extrêmement rapide et explore très peu d’états.  
Cependant, il ne garantit pas l’optimalité et produit ici un chemin plus long.

---

## 3. Analyse comparative

- BFS et Dijkstra garantissent l’optimalité mais explorent un grand nombre d’états.
- Dijkstra est plus coûteux en temps que BFS en raison de la gestion de la file de priorité.
- A* réduit considérablement l’espace exploré tout en conservant l’optimalité.
- Greedy est le plus rapide mais ne garantit pas un chemin optimal.

---

## 4. Conclusion

Sur une carte réelle avec des coûts uniformes :

- A* offre le meilleur compromis entre performance et optimalité.
- Dijkstra n’apporte pas d’avantage par rapport à BFS dans ce contexte.
- Greedy est efficace en temps de calcul mais non fiable si l’on exige une solution optimale.

L’algorithme A* apparaît donc comme le plus adapté pour ce type de problème.