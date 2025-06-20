Feature: Escenarios de prueba para Marvel Characters API

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api'
    * header Content-Type = 'application/json'
    * def randomNum = Math.floor(Math.random() * 10000)
    * def nombre = 'Iron Man ' + randomNum
    * def personajeInicial =
      """
      {
        "name": "#(nombre)",
        "alterego": "Tony Stark",
        "description": "Genius billionaire",
        "powers": ["Armor","Flight"]
      }
      """
    Given path 'characters'
    And request personajeInicial
    When method post
    Then status 201
    * def idCreado = response.id

  Scenario: Obtener personaje por ID (exitoso)
    Given path 'characters', idCreado
    When method get
    Then status 200
    And match response.id == idCreado
    And match response.name == 'Iron Man ' + randomNum

  Scenario: Obtener personaje por ID (no existe)
    Given path 'characters', 999
    When method get
    Then status 404
    And match response.error == 'Character not found'

  Scenario: Crear personaje con nombre duplicado
    * def duplicado = { name: 'Iron Man', alterego: 'Otro', description: 'Otro', powers: ['Armor'] }
    Given path 'characters'
    And request duplicado
    When method post
    Then status 400
    And match response.error == 'Character name already exists'

  Scenario: Crear personaje con campos requeridos faltantes
    * def incompleto = { name: '', alterego: '', description: '', powers: [] }
    Given path 'characters'
    And request incompleto
    When method post
    Then status 400
    And match response.name == 'Name is required'
    And match response.alterego == 'Alterego is required'
    And match response.description == 'Description is required'
    And match response.powers == 'Powers are required'

  Scenario: Actualizar personaje exitosamente
    * def actualizado = { name: nombre, alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }
    Given path 'characters', idCreado
    And request actualizado
    When method put
    Then status 200
    And match response.description == 'Updated description'

  Scenario: Actualizar personaje (no existe)
    * def actualizado = { name: 'nombre', alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }
    Given path 'characters', 999
    And request actualizado
    When method put
    Then status 404
    And match response.error == 'Character not found'

  Scenario: Eliminar personaje exitosamente
    Given path 'characters', idCreado
    When method delete
    Then status 204

  Scenario: Eliminar personaje (no existe)
    Given path 'characters', 999
    When method delete
    Then status 404
    And match response.error == 'Character not found'
