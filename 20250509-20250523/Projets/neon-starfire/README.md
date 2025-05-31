# Neon Starfire

## Présentation

![Capture d'écran du jeu](https://github.com/jasonchampagne/GameJam/blob/main/20250509-20250523/Projets/neon-starfire/screenshot.png)

S'inspirant de Hotline Miami à Balatro, en passant par toutes les perles que peut compter la scène indépendante dont je suis friand. Adepte du pixel art et de l'esthétique SNES (haaa ces sprites de Final Fantasy), j'ai aussi tenté de trouver un jeu à "système" et aussi un jeu que l'on peut "casser" car c'est un vrai plaisir en tant que joueur de comprendre le système et de pouvoir le dépasser (certains RPG ou deckbuilders ont cette caractéristique).

### Principe

Chaque niveau est un labyrinthe généré aléatoirement. Pour passer le niveau il suffit d'amener le personnage de son point de départ à son point d'arrivée. Autant que possible, pas de violence (mais pas trop cosy pour autant).

### Score

Chaque case contient des points qui seront utilisés par la suite pour débloquer des objets.

### Cartes

Il en existe 11 dans cette version, il faut toutes les attraper. Vous pouvez vérifier votre avancement dans le menu "Collection de cartes". Pour débloquer une carte, il suffit qu'elle ait été placée dans votre deck au moins une fois (en général à la boutique).

Il existe 4 types de cartes, on peut faire la distinction à l'aide de la couleur de la bordure autour durant le jeu. Chaque type agit sur un objet particulier de l'ensemble.

Voici les types et leur couleur :

+ MOVE : bouge le personnage - Electric Blue
+ AMPLIFICATEUR : amplifie l'effet de la carte suivante - Acid Yellow
+ MAZE : change l'état du labyrinthe de différente manière - Neon Pink
+ SCORE : agit sur le score - Purple Pulse

### Système de cartes

À la suite de la sélection de votre personnage, un deck vous est automatiquement attribué. Pour des soucis de jouabilité pour le moment, aucune contrainte n'est mise sur la rotation du deck, ainsi vous êtes sûr de pouvoir finir le labyrinthe.

Après un niveau réussi, vous arrivez sur une boutique où vous pouvez utiliser les points récoltés durant le niveau pour acheter de nouvelles cartes qui s'ajouteront automatiquement à votre deck existant. Les points qui ne sont pas utilisés à la boutique ne sont pas perdus, ils persistent au prochain niveau.

Au bout de 3 labyrinthes, vous affronterez un boss qui a un (1) pouvoir qui vous embêtera (mais en vrai pas trop, c'est juste histoire de mettre un boss de fin).

### Interface et navigation

Pour le moment les interactions sont essentiellement prévues à la souris, mais il est à noter que la barre d'espace (ou entrée) est utilisée pour faire un retour en arrière de carte durant un labyrinthe.

Vous choisissez une carte dans votre main et elle fera (si c'est une carte de déplacement) déplacer votre personnage dans la direction actuelle. Si la carte ne peut pas fonctionner (sortie du labyrinthe par exemple), elle ne pourra pas arriver sur un slot, elle sera automatiquement bloquée.

Lorsque vous n'avez plus de slots dispo, vous devez libérer des slots en validant la main, et libérer ainsi des slots, mais par contre une fois cette action faite il n'est plus possible de faire de rollback sur les cartes qui ne sont plus sur un slot. Les touches directionnelles permettent de donner la direction du personnage et de selectionner automatiquement la premiere carte de mouvement diponible (pour fluidifier les déplacements)

### Niveau

<details>
<summary>Afficher/masquer</summary>
Les niveaux dans cette version s'enchainent de cette manière
    - labyrinthe
    - boutique
    - labyrinthe
    - boutique
    - boss
</details>
