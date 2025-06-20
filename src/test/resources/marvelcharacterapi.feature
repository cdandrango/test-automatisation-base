@REQ_HCU-3345 @HU3345 @gestion_personajes_marvel @marvel_characters_api @Agente2 @E2 @iniciativa_api_marvel
Feature: HCU-3345 Escenarios de prueba para Marvel Characters API (microservicio para administrar personajes de Marvel)

  Background:
    * def data = karate.callSingle('classpath:setup-create.feature', { baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api'})
    * url data.baseUrl
    * header Content-Type = 'application/json'
    * def idCreado            = data.id
    * def nombre              = data.nombre
    * def nombreActualizacion = data.nombreActualizacion
    * def personajeInicial    = data.personajeInicial
    * def randomInt =
      """
      function(){ return Math.floor(Math.random() * 10000000000) + 1; }
      """

  @id:1 @obtenerPersonajePorId @consultaExitosa200
  Scenario: T-API-HCU-3345-CA01-Obtener personaje por ID exitosamente 200 - karate
    Given path 'characters', idCreado
    When method get
    Then status 200
    And match response.id == idCreado
    And match response.name == nombre

  @id:2 @obtenerPersonajePorId @consultaFallida404
  Scenario: T-API-HCU-3345-CA02-Obtener personaje por ID que no existe 404 - karate
    Given path 'characters', 999
    When method get
    Then status 404
    And match response.error == 'Character not found'

  @id:3 @crearPersonaje @consultaExitosa201
  Scenario: T-API-HCU-3345-CA03-Crear personaje exitosamente 201 - karate
    * def nombreHeroe = 'Iron Man ' + randomInt()
    * def nuevoPersonaje =
      """
      {
        "name": "#(nombreHeroe)",
        "alterego": "Tony Stark",
        "description": "Genius billionaire",
        "powers": ["Armor","Flight"]
      }
      """
    Given path 'characters'
    And request nuevoPersonaje
    When method post
    Then status 201
    And match response.name == nombreHeroe
    And match response.id != null

  @id:4 @crearPersonaje @nombreDuplicado @consultaFallida400
  Scenario: T-API-HCU-3345-CA04-Crear personaje con nombre duplicado 400 - karate
    * def duplicado = { name: 'Iron Man', alterego: 'Otro', description: 'Otro', powers: ['Armor'] }
    Given path 'characters'
    And request duplicado
    When method post
    Then status 400
    And match response.error == 'Character name already exists'

  @id:5 @crearPersonaje @camposRequeridosFaltantes @consultaFallida400
  Scenario: T-API-HCU-3345-CA05-Crear personaje con campos requeridos faltantes 400 - karate
    * def incompleto = { name: '', alterego: '', description: '', powers: [] }
    Given path 'characters'
    And request incompleto
    When method post
    Then status 400
    And match response.name == 'Name is required'
    And match response.alterego == 'Alterego is required'
    And match response.description == 'Description is required'
    And match response.powers == 'Powers are required'

  @id:6 @actualizarPersonaje @consultaExitosa200
  Scenario: T-API-HCU-3345-CA06-Actualizar personaje exitosamente 200 - karate
    * def actualizado = { name: nombre, alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }
    Given path 'characters', idCreado
    And request actualizado
    When method put
    Then status 200
    And match response.description == 'Updated description'

  @id:7 @actualizarPersonaje @consultaFallida404
  Scenario: T-API-HCU-3345-CA07-Actualizar personaje que no existe 404 - karate
    * def actualizado = { name: nombreActualizacion, alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }
    Given path 'characters', 999
    And request actualizado
    When method put
    Then status 404
    And match response.error == 'Character not found'

  @id:8 @eliminarPersonaje @consultaExitosa204
  Scenario: T-API-HCU-3345-CA08-Eliminar personaje exitosamente 204 - karate
    Given path 'characters', idCreado
    When method delete
    Then status 204

  @id:9 @eliminarPersonaje @consultaFallida404
  Scenario: T-API-HCU-3345-CA09-Eliminar personaje que no existe 404 - karate
    Given path 'characters', 999
    When method delete
    Then status 404
    And match response.error == 'Character not found'

  @id:10 @eliminarPersonaje @errorServicio500
  Scenario: T-API-HCU-3345-CA10-Eliminar personaje con error interno 500 - karate
    And request {}
    When method DELETE
    And path '500'
    Then status 500