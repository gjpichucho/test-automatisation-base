@REQ_HU-PRU-001 @HU001 @marvel_characters_management @marvel_characters_api @Agente2 @E2 @iniciativa_prueba
Feature: Test de API súper simple

  Background:
    * configure ssl = true
    * def urlBase = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/gpichuch'
    * path '/api/characters'
    * def generarHeaders =
      """
      function() {
        return {
          "Content-Type": "application/json"
        };
      }
      """
    * def headers = generarHeaders()
    * headers headers

  @id:1 @obtenerPersonajes @solicitudExitosa200
  Scenario: T-API-HU-PRU-001-CA01-Obtener todos los personajes exitosamente 200 - karate
    Given url urlBase
    When method GET
    Then status 200
   And match response != null
  # And match response == '#array'

  @id:2 @obtenerPersonajePorId @solicitudExitosa200
  Scenario: T-API-HU-PRU-001-CA02-Obtener personaje por ID exitosamente 200 - karate
    Given url urlBase
    * path '/4'
    When method GET
    Then status 200
    And match response != null
    And match response.id == 4
    * match response.alterego == '#string'
    * match response.powers[0] == '#string'

  @id:3 @obtenerPersonajePorId @personajeNoEncontrado404
  Scenario: T-API-HU-PRU-001-CA03-Obtener personaje por ID inexistente 404 - karate
    Given url urlBase
    * path '/7474'
    When method GET
    Then status 404
    And match response.error == 'Character not found'
  # And match response == { error: 'Character not found' }

  @id:4 @crearPersonaje @solicitudExitosa201
  Scenario: T-API-HU-PRU-001-CA04-Crear personaje exitosamente 201 - karate
    Given url urlBase
    * def randomNumber = function(){ return Math.floor(Math.random() * 100) + 1 }
    * def number = randomNumber()
    * print 'Número aleatorio generado:', number
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_character.json')
    * set jsonData.name = jsonData.name + number
    * print 'Nombre del personaje:', jsonData.name
    And request jsonData
    When method POST
    Then status 201
    * def responseId = response.id
    And match response.id != null
    And match response.name == jsonData.name
    * print response
    * print 'Response ID: ' + responseId


  @id:5 @crearPersonaje @nombreDuplicado400
  Scenario: T-API-HU-PRU-001-CA05-Crear personaje con nombre duplicado 400 - karate
    Given url urlBase
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_duplicate_name.json')
    And request jsonData
    When method POST
    Then status 400
    And match response == { error: 'Character name already exists' }

  @id:6 @crearPersonaje @datosInvalidos400
  Scenario: T-API-HU-PRU-001-CA06-Crear personaje con datos inválidos 400 - karate
    Given url urlBase
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_character_invalid.json')
    And request jsonData
    When method POST
    Then status 400
    And match response.name == 'Name is required'
  # And match response.alterego == 'Alterego is required'

  @id:7 @actualizarPersonaje @solicitudExitosa200
  Scenario: T-API-HU-PRU-001-CA07-Actualizar personaje exitosamente 200 - karate
    Given url urlBase
    * path '/3'
    * def jsonData = read('classpath:data/marvel_characters_api/request_update_character.json')
    And request jsonData
    When method PUT
    Then status 200
    * print response
    And match response.description == 'Updated description'
    And match response.id == 3

  @id:8 @actualizarPersonaje @personajeNoEncontrado404
  Scenario: T-API-HU-PRU-001-CA08-Actualizar personaje inexistente 404 - karate
    Given url urlBase
    * path '/999'
    * def jsonData = read('classpath:data/marvel_characters_api/request_update_character.json')
    And request jsonData
    When method PUT
    Then status 404
    And match response.error == 'Character not found'
    And match response == { error: 'Character not found' }

  @id:9 @eliminarPersonaje @solicitudExitosa204
  Scenario: T-API-HU-PRU-001-CA09-Eliminar personaje exitosamente 204 - karate
    Given url urlBase
    * path '/1'
    When method DELETE
    Then status 204
    * print response
    And match response == ''
  # And assert responseTime < 1000

  @id:10 @eliminarPersonaje @personajeNoEncontrado404
  Scenario: T-API-HU-PRU-001-CA10-Eliminar personaje inexistente 404 - karate
    Given url urlBase
    * path '/999'
    When method DELETE
    Then status 404
   And match response.error == 'Character not found'
  # And match response == { error: 'Character not found' }