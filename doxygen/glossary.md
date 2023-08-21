Glossary  {#glossary}
========

# Active elements  {#active_elements}
A certain part of data structure where computation needs to be done. For example, if graph is the data structure of interest, then an active element can be a node, an edge or a subgraph.

# Operator  {#glossary_operator}
The action applied to each [active element](#active_elements) at each point during the execution of an algorithm.

# Neighborhood  {#glossary_neighborhood}
The set of elements that are read or written while applying an operator, which may not be the [active elements](#active_elements). 

# Topology-driven algorithm  {#topo_driven_algo}
An algorithm whose active elements are all the elements in the involved data structures. Bellman-Ford algorithm for solving single-source shortest path (SSSP) problem is an example: all edges in the input graph are active in rounds.

# Data-driven algorithm  {#data_driven_algo}
An algorithm whose active elements depend on previously processed work items. Dijkstra's SSSP algorithm is an example: active nodes in the priority queue are neighbors of previously processed nodes.

-# Pull-style algorithm: an algorithm whose operator reads from the neighborhood of an active element and updates the active element itself.
-# Push-style algorithm: an algorithm whose operator reads from the active element itself and updates the neighborhood of the active element.