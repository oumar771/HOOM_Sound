Application Flutter pour recommandations musicales, intégrant l’API Spotify pour la musique et Mistral AI pour les anecdotes et suggestions.

HOOM_Sound

Bienvenue sur le dépôt HOOM_Sound. Ce projet consiste à développer une application mobile avec (Flutter) permettant :

1.  Authentification Spotify : Se connecter à son compte Spotify pour récupérer ses playlists, artistes, albums.
2.  Lecture d’extraits audio: Pouvoir écouter un court aperçu (30s) de chaque piste (si preview_url disponible).
3.  Mistral AI : Obtenir des anecdotes sur la vie des artistes ou des suggestions d’albums similaires via l’IA.
4.  UI/UX : Une interface fluide et agréable, avec un minimum de tests unitaires pour garantir la fiabilité.

                                      tech Stack
-Flutter (Dart) : pour le développement cross-plateforme (Android / iOS).
-Spotify Web API : pour l’authentification OAuth et la récupération des données musicales.
-Mistral AI : pour la génération de texte (anecdotes artistes, suggestions de musique).
-Notion: pour la planification, docs.
-GitHub Projects : Kanban pour organiser le développement.
                                   Configuration requise

Flutter SDK >= 3.29.0 a. Android Studio avec plugins Dart & Flutter b. Compte Spotify Developer (client_id, client_secret) c. Clé API Mistral (Bearer token) d. Un téléphone ou un émulateur Android/iOS pour tester Installation & Lancement.
