THREE = require '../../lib/Three.js'
Particle = require './Particle.coffee'

class ParticleEmitter
    constructor: ( @frequency=1, @maxParticles=500, settings={} ) ->
        @particles = []
        @active = false
        @time = Date.now()
        @timeout = 1000/@frequency
        @position = settings.position || new THREE.Vector3()
        @destination = settings.destination || new THREE.Vector3()
        @offset = settings.offset || 10
        @speed = {
            min: settings.minSpeed || 10,
            max: settings.maxSpeed || 50
        }
        @friction = {
            min:  settings.minFriction || .7,
            max:  settings.maxFriction || .9
        }

        @god = settings.god || null
        @pathId = settings.pathId || 0

    start: () ->
        if !@active
            @time = Date.now()
            @active = true

    stop: () ->
        if @active
            @active = false

    addParticle: () ->
        if @particles.length < @maxParticles
            p = new Particle( @getOrigin(), @getDestination(), @getSpeed(), @getFriction() )
            @particles.push p

    getOrigin: () ->
        return @position.clone().add( new THREE.Vector3( -@offset + 2 * @offset * Math.random(), -@offset + 2 * @offset * Math.random(), 0 ) )

    getDestination: () ->
        return @destination.clone()#.add( new THREE.Vector3( -@offset + 2 * @offset * Math.random(), -@offset + 2 * @offset * Math.random(), 0 ) )

    getSpeed: () ->
        return @speed.min + ( @speed.max - @speed.min ) * Math.random()

    getFriction: () ->
        return @friction.min + ( @friction.max - @friction.min ) * Math.random()

    setFrequency: ( f ) ->
        @frequency = f
        @timeout = 1000/@frequency

    update: ( boids, R, ctx ) ->
        if @active
            d = Date.now() - @time
            if d >= @timeout
                @addParticle()
                @time = Date.now()
        k = 0
        for p in @particles
            #uv = p.trail.uv
            #col = ctx.getImageData uv.x, uv.y, 1, 1
            p.update( null )
            ###if !p.attracted
                for b in boids
                    if b.position.clone().sub( p.position ).length() < R
                        p.attracted = true
                        p.destination = b.position
                        p.boid = b
                        break###
            if p.dead and !p.attracted
                    p.attracted = true
                    p.dead = false
                    if @god != null and @pathId > -1
                        p.boid = @god.addBoid @pathId
                        p.destination = p.boid.position
            
            if p.dead and p.attracted and !p.trail.positions.length
                @particles.splice( k, 1)
                return
            
            k++

module.exports = ParticleEmitter;