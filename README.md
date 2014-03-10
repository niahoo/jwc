# jwc

Outils pour la communauté [Jeuweb](http://www.jeuweb.org/)

Les fiches JSON de chaque jeu se trouvent dans le répertoire `priv\games`.

Pour soumettre son jeu le plus simple est de proposer une *pull-request*.

L'identifiant ne doit pas déjà être pris par un autre jeu.

`status` peut être `dev`, `alpha`, `beta`, `open` ou `inactive` pour les jeux abandonnés.

`source` peut être `open` ou `close`. Cela concerne le code source serveur du jeu. Si le jeu est basé sur un moteur opensource type mamafia (C), `engine` doit contenir l'URL vers ce moteur et `source` doit logiquement être `open`.

`author` doit correspondre à un compte Jeuweb.

`humans` doit contenir une liste de contacts à qui l'on peut s'adresser pour avoir plus d'informations sur un jeu. Le format conseillé est `Nom Prénom <adresse@email.net>` mail il est également possible de spécifier un compte Twitter ou une URL Facebook par exemple.

`banners` est un objet qui associe des formats d'image à des URLs.

```json
  {
    "name"   : "Age of Vampires",
    "id"     : "aov",
    "author" : "JC",
    "url"    : "http://beta.age-of-vampires.fr",
    "status" : "beta",
    "techs"  : ["PHP","HTML5","JS","CSS3"],
    "tags"   : ["medfan","sanglant","vampires"],
    "source" : "open",
    "engine" : null,
    "humans" : ["Jean-Claude Überzinsky <jcu@trololo.com>"]
    "banners": { "728x90" : "http://serv.com/aov.jpg"
               , "120x240" : "http://serv.com/aov2.jpg"
               }
  }
```
