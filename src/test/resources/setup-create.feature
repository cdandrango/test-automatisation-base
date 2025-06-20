Feature: Setup único de Marvel Character

  Scenario:
    * def baseUrl = __arg.baseUrl
    * url baseUrl
    * header Content-Type = 'application/json'
    * def randomInt =
    """
    function(){ return Math.floor(Math.random() * 10000000) + 1; }
    """
    * def randomNum = randomInt()
    * def nombre  = 'Iron Man ' + randomNum
    * def nombreActualizacion = nombre
    * def personajeInicial =
    """
    {
      "name": "#(nombre)",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": ["Armor","Flight"]
    }
    """
    * path 'characters'
    * request personajeInicial
    * method post
    * def id = response.id