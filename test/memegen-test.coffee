chai = require "chai"
sinon = require "sinon"
chai.use require "sinon-chai"

expect = chai.expect

describe "memegen", ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require("../src/memegen")(@robot)

  it "registers a respond listener", ->
    expect(@robot.respond).to.have.been.calledWith(/meme create/i)
    expect(@robot.respond).to.have.been.calledWith(/meme cancel/i)

  it "registers a hear listener", ->
    expect(@robot.hear).to.have.been.calledWith(/(.+)/i)
