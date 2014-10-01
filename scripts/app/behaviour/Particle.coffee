
THREE = require '../../lib/Three.js'
Trail = require './Trail.coffee'
PathSteeringBoid = require './PathSteeringBoid.coffee'

class Particle
    constructor: ( @position, @destination, @speed, @friction ) ->
        @velocity = new THREE.Vector3()
        #@oDestination = @destination.clone()
        @rotation = 0
        @dead = false
        @attracted = false
        @trail = new Trail @
        @offset = Math.random() * 5
        @force = new THREE.Vector2( 1 + 1 * Math.random(), 1 + 1 * Math.random() )
        @fspeed = .001 + Math.random()*.01
        @head = new PathSteeringBoid [ @position.clone(), @destination.clone() ], 5 + 10 * Math.random()
        @boidOffset = new THREE.Vector2 -20 + 40 * Math.random(), -20 + 40 * Math.random()

    update: ( col ) ->
        d = @destination.clone().sub( @position )

        if @attracted
            d = @destination.clone().add( @boidOffset ).sub( @position )
        
        if ( !@attracted )
            @head.update()
            @velocity = @head.velocity

            if d.length() < 10
                @dead = true
        else
            @velocity = d.clone().multiplyScalar( @speed/100 )
            if !@boid || @boid.finished
                #@attracted = false
                #@destination = @oDestination.clone()
                @dead = true

        if !@attracted && !@dead
            @velocity.add( new THREE.Vector3( @force.x * Math.sin( Date.now() * @fspeed + @offset ), @force.y * Math.sin( Date.now() * @fspeed + @offset ), 0 ) )
            @force = new THREE.Vector2( 1 + 1 * Math.random(), 1 + 1 * Math.random() )
        
        @velocity.multiplyScalar( @friction )

        @position.add @velocity

        @rotation = Math.atan2 @velocity.y, @velocity.x

        @trail.update col

module.exports = Particle