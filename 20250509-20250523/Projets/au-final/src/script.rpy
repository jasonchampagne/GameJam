# Conventions
# Choice name : major_route_minor

# Transitions
define slowFade = Fade( 1.0, 1.0, 1.0 )

# Images
image bg journal = "journal.jpg"
image bg cemetery = "cemetery.jpg"
image bg college = "college.jpg"
image bg class = "class.jpg"
image bg corpo = "corpa.jpg"
image bg road = "road.jpg"
image bg landscape = "landscape.jpg"

image homie = "homie.png"
image boss = "boss.png"

# Charaters
define mc = Character( 'Moi', color = "#AAAAAA" )
define homie = Character( 'Un bon ami', color = "#FFF200" )
define boss = Character( 'Boss', color = "#00AA00" )
define random = Character( 'Gros enculé', color = "#FF0000" )

# Game
label start :
    
    # Scene 1
    scene bg journal
    with dissolve
    "Un journal est posé devant vous."

menu :
    "Le lire" :
        jump game

    "Le contempler" :
        pause 5.0
        jump start

label game :

    # Scene 2
    play music "missingTheTimeWeHad.mp3"

    "\"Je ne comprends personne. Moi inclus.\""
    "\"Je vois le monde, comme presque tout le monde d'ailleurs. Mais je ne le comprends pas.\""
    "\"Comme tout le monde.\""
    "\"C'est peut-être pour ça qu'on a tous des points de vue différents.\""
    "\"J'aimerais tant partager ma vision du monde; ma vie. Mais c'est impossible.\""
    "\"Je ne peux faire entrer personne dans ma tête. Personne ne peut partager mes yeux, mes sensations, mes pensées.\""
    "\"Il n'y a que pour moi que le mot 'moi' me désigne. Personne d'autre.\""
    "\"Alors je griffone des mots sur une page blanche. Pour que, par je ne sais quel miracle, ces mots permettent d'entrevoir un semblant de ma vie à un inconnu qui passait son chemin."
    "\"Et plus j'écris, et moins je comprends. Plus je me questionne, moins j'ai de réponses.\""
    "\"L'univers me contemple, et je ne peux soutenir son regard.\""
    "\"Etait-ce pour cela que tu n'as jamais pris le temps d'écrire cette note d'adieu ?\""

    scene bg cemetery
    with Fade( 2.0, 0.0, 2.0 )
    pause 1.0

    mc "Je comprends toujours pas pourquoi tu as sauté..."
    mc "Pour rejoindre mon père ? Tu l'as perdu il y a bien longtemps, pourquoi maintenant ?"
    mc "Je suis censé faire quoi après ça ? Sauter à mon tour ? Faire comme si rien de tout cela ne s'est jamais passé ? Que tu n'as jamais existé ?"
    mc "..."
    mc "Je suppose que je suis seul maintenant."
    mc "Je commence à me demander si tu as pensé à moi au moins quelques secondes."

    # Scene 3
    stop music fadeout 1.0

    scene bg college
    with slowFade

    mc "J'ai vraiment pas la force d'aller en CM..."

menu :
    "Se forcer à aller en cours" :
        jump vision_route

    "Sècher" :
        jump blind_route

label vision_route :

    # Scene 4
    scene bg class
    with dissolve

    play sound "hall.mp3"
    pause 0.5

    show homie

    homie "J'ai bien cru que t'allais jamais arriver. Comment ça va ?"
    homie "Mec, écoute. J'ai un plan de fou."
    mc "Je ne t'ai même pas encore répondu. Détends-toi"
    mc "Et il faut en effet être fou pour suivre tes \"plans\"."
    homie "Nan, nan. Cette fois je suis sûr que tu vas kiffer."
    mc "Bon, dis-moi tout. De toute façon, c'est impossible que tu fasses pire que la dernière fois."
    homie "Un road trip !"
    mc "C'est pire que la dernière fois..."
    mc "Un road trip ? Vraiment ?"
    mc "On est bientôt diplomés, les examens arrivent à grands pas et le travail arrive juste derrière. Et toi tu veux faire un road trip ?"
    homie "Pas tout de suite, je suis pas si con. Mais justement. C'est notre dernière chance de profiter !"
    homie "Après la fin de nos études, qui sait si on se reverra, ou même si on pourra se revoir."

menu :
    mc "..."

    "La société peut attendre" :

        homie "LET'S GO !"
        mc "Calme tes ardeurs, on est pas encore partis."
        homie "Quoi, j'ai pas le droit d'être content ? Arrête de faire le mec aigri, je t'ai vu sourire."

        hide homie
        jump chill_vision_route
    
    "Le monde ne marche pas comme ça" :

        homie "Bon bah, j'aurai essayé."
        mc "Oui mais il suffit pas d'essayer. Il faut réussir."
        
        hide homie
        jump coprorate_vision_route

label coprorate_vision_route :

    # Scene 5
    stop sound fadeout 1.0

    scene bg corpo
    with slowFade

    show boss
    play music "twistedClowns.mp3"

    boss "Bonne journée à tous ! Et n'oubliez pas, semaine prochaine, même heure."
    mc "Excusez-moi. Patron ?"
    boss "Qu'y a-t-il ?"
    mc "Euh... Est-ce que j'ai droit à des congés ?"
    boss "Pardon, des quoi ?"
    mc "J'aimerais prendre des congés."
    boss "Pardon, des quoi ?"
    mc "Des congés."
    boss "Des quoi ?"
    mc "..."
    boss "..."
    mc "Oubliez ce que je viens de dire. Au revoir."
    boss "Eh bien à demain alors !"

    # Scene 6
    scene black
    with fade

    hide boss

    mc "Quand est-ce que je pourrai enfin me poser ? Quand était la dernière fois que j'ai regardé par la fenêtre, à contempler le ciel bleu ?"
    mc "Je suis toujours en train de me dépêcher, de finir quelque chose. Tout ça dans l'espoir de pouvoir en commencer une autre. Pour la finir elle aussi."
    mc "Puis en recommencer."
    mc "Puis en finir."
    mc "Puis recommencer..."
    mc "Puis finir..."
    mc "Mais y'a-t-il vraiment une fin à cela ? Ce cercle vicieux qui aspire mon âme." 
    mc "Qui me fait planifier des vacances comme une journée de travail." 
    mc "Qui me laisse à vagabonder les bureaux qu'un inconnu m'a assignés."
    mc "Comme un aveugle sans sa canne, tourné en bourique par un petit plaisantin."
    mc "Mais ce plaisantin est bien plus grand que moi."
    mc "Je ne distingue que sa silhouette, sombre et floue. Incapable de voir les fils avec lesquels il se joue de moi."
    mc "Tous les jours, j'essaie de l'apercevoir. Sans succès."
    mc "Tous les jours, j'essaie de l'atteindre. Sans succès."
    mc "Et tous les jours, j'aimerais lui dire, lui hurler de toutes mes forces..."
    mc "Pitié, arrêtez ce cirque !"
    mc "Mais même à travers mes lunettes, je le vois."
    mc "Après la fin, il ne peut y avoir qu'un autre début."
    mc "Au final, on ne peut que continuer."
    mc "Alors je continue."

    # Scene 7
    stop music fadeout 1.0

    scene bg journal
    with slowFade

    "Vous continuez à lire le journal, mais il se répète."
    "Il se répète. Encore."
    "Mais à chaque fois, l'écriture semble de plus en plus tremblante. Les feuilles du journal deviennent de plus en plus froissées. Les tirades de plus en plus violentes."
    "Alors vous posez le journal. Vous prenez une grande inspiration et vous vous redressez sur votre chaise, bien en face de votre bureau."
    jump start

label chill_vision_route :

    # Scene 5
    stop sound fadeout 1.0

    scene bg road
    with slowFade

    play sound "nature.mp3" loop

    mc "Quelques semaines passèrent et nous voilà à la conquête d'aventures que je n'aurais pu imaginer."
    mc "Le voyage dure bien plus longtemps que prévu. Il en devient une partie intégrante de ma vie, de moi."
    mc "Au début, une petite voix dans ma tête me disais que j'allais juste gaspiller du temps. Mais elle s'est volatilisée avec le temps."
    mc "C'est qu'on y prend goût, à ce genre de péripéties."
    mc "Certes, je ne suis pas aussi \"utile\" ou couronné de succès que d'autres. Mais cela ne m'empêchera pas de profiter de la vie."

    # Scene 6
    scene bg landscape
    with fade

    show homie at right

    homie "YO ! Regarde moi ça !"
    mc "C'est magnifique, pour le coup."
    homie "Mec !"
    mc "Ta gueule."
    homie "Hein ? J'ai fait quoi ?"
    mc "Tait toi et contemple le paysage."

    pause 10.0

    homie "C'est vrai que ça fait du bien."
    mc "Je crois que ça fait plus que du bien. Ça rend heureux."

    # Scene 7
    hide homie
    with fade

    mc "C'est peut-être juste ça le bonheur. Pas besoin de gloire éternelle, de réussite, ou d'une vie sans problèmes."
    mc "Juste contempler la vie. De la même manière que quelqu'un de désespéré contemple la mort."
    mc "En commençant ce journal, j'esperais le conclure avec les réponses à toutes mes questions. Des réponses qui auraient pu résonner chez l'inconnu qui lit ces mots. Une tirade qui marquerait les esprits."
    mc "Mais je n'en ai pas. Je n'ai pas de réponses car je n'ai plus de questions."
    mc "Je ne sais pas si Dieu existe. Je ne connais pas la réponse à l'univers et à la vie. Et je ne sais toujours pas pourquoi elle n'a jamais écrit cette note d'adieu."
    mc "Mais je ne me complique pas la vie. J'ai arrêter de m'acharner à comprendre. Je ne fais qu'apprécier maintenant."
    mc "Que l'on soit trop intelligent pour accepter que tout soit si simple, ou que l'on soit trop bête pour réaliser que tout soit si simple. Cela n'a pas d'importance."
    mc "Au final, le plus compliqué et la seule chose à faire, lorsque l'univers vous fixe de son regard perçant..."
    mc "C'est de le regarder en retour. Et de contempler la beauté de ses yeux, parfois cruelle, souvent incompréhensible."
    mc "C'est en cet instant que les sensations me sumberge, et que les mots me manquent. Alors je conclus ce journal."
    mc "Ce n'est qu'après sa fin, que je pourrai contempler ce paysage à sa juste valeur."

    stop sound fadeout 5.0

    scene black
    with Fade( 5.0, 1.0, 0.0 )

    return

label blind_route :

    # Scene 4
    scene black
    with slowFade

    play music "fingerprints.mp3"

    mc "Qu'est-ce que je fous de ma vie ?"
    mc "Je reste à moitié dans le noir, allongé dans mon lit, à fixer le plafond ?"
    mc "Que font les autres ? Ils travaillent, ils s'amusent, ils se reposent."
    mc "..."
    mc "Le repos..."
    mc "Je veux me reposer aussi. Arrêter cette mascarade."
    mc "Mais bon, \"La vie est simple ! Il suffit de faire comme moi !\""
    random "Fait du sport ! Mange sain ! Travail dur comme fer, ton future toi te remerciera."
    random "Regarde vers l'avant."
    mc "Eh bien merci, mais je souhaite être aveugle. Ne plus voir ce monde. Ne plus avoir cette sensation de mal être, continuellement derrière moi."
    mc "J'ai la sensation que le monde entier me fixe, dans l'ombre, et cela m'horripile."
    mc "Je ne peux plus voir ces regards tournés vers moi."
    mc "Laissez-moi fermez les yeux..."
    mc "Mais le monde me force à les ouvrir. A le contempler dans toute sa laideur. Plein de défauts, de mal, de futilité, de souffrances."
    mc "Que faire fasse à cette abomination ? De mon point de vue, pas grand chose."
    mc "Alors je ne fais rien."
    mc "Notre salut viendra peur-être un jour. Peut-être jamais. Je n'ai pas trop d'attentes."
    mc "Au final, on est tous condamné. Autant faire comme si on avait rien vu."

    stop music fadeout 5.0
    scene black
    with Fade( 5.0, 1.0, 0.0 )

    return