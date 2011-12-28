#==============================================================================
# lib/logger.js module
#==============================================================================
describe 'logger', ->
  logger = require '../../lib/logger'

  beforeEach ->
    spyOn console, 'log'
    logger.setLevel 3 # set to DEBUG

  it 'should have error method', ->
    logger.create('FAKE').error 'whatever'
    expect(console.log).toHaveBeenCalledWith 'error (FAKE):', 'whatever'


  it 'should have warn method', ->
    logger.create('OBJECT').warn 'whatever', 'more'
    expect(console.log).toHaveBeenCalledWith 'warn (OBJECT):', 'whatever', 'more'


  it 'should have info method', ->
    logger.create('OBJECT').info 'some', 'info'
    expect(console.log).toHaveBeenCalledWith 'info (OBJECT):', 'some', 'info'


  it 'should have debug method', ->
      logger.create('OBJECT').debug 'some', 'info'
      expect(console.log).toHaveBeenCalledWith 'debug (OBJECT):', 'some', 'info'


  it 'should allow global configuration', ->
    log = logger.create 'OBJ'

    logger.setLevel 3 # DEBUG
    log.debug 'ok'
    expect(console.log).toHaveBeenCalledWith 'debug (OBJ):', 'ok'

    console.log.reset()
    logger.setLevel 0 # ERROR
    log.debug 'should be ignored'
    expect(console.log).not.toHaveBeenCalled()


  it 'per instance configuration should override global configuration', ->
    logger.setLevel 0 # ERROR
    instance = logger.create('OBJ', 3) # DEBUG

    instance.debug 'message'
    expect(console.log).toHaveBeenCalledWith 'debug (OBJ):', 'message'

    console.log.reset()
    another = logger.create('ANOTHER') # use global
    another.debug 'should be ignored'
    expect(console.log).not.toHaveBeenCalled()


  it 'per instance conf should override global even if its 0', ->
    logger.setLevel 3 # DEBUG
    instance = logger.create('OBJ', 0) # ERROR

    instance.debug 'should be ignored'
    instance.info 'should be ignored'
    instance.warn 'should be ignored'
    expect(console.log).not.toHaveBeenCalled()