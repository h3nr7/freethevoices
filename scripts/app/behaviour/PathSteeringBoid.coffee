THREE = require '../../lib/Three.js'

class PathSteeringBoid
    constructor: ( pts, @speed=5, @mass=1, isSpline=false ) ->
        if !isSpline
            @path = pts
        else 
            @path = []
            for t in [0..1] by .005
                @path.push pts.getPoint( t )
        @reset()

    reset: () ->
        @finished = false
        @index = 0
        @velocity = new THREE.Vector3()
        @position = @path[0].clone()
        @rotation = 0

    update: () ->
        @position.add @velocity
        @rotation = Math.atan2 @velocity.y, @velocity.x
        @steer()
    
    steer: () ->
        if ( @index >= @path.length )
            @velocity.multiplyScalar .9
            
            if ( @velocity.length() < @speed && !@finished )
                @finished = true
            
            return

        waypoint = @path[ @index ]
        d = waypoint.distanceTo @position

        if ( d < 10 )
            @index++
            return

        @seek waypoint
    
    seek: ( target ) ->
        desiredVelocity = target.clone().sub @position
        desiredVelocity.normalize()
        desiredVelocity.multiplyScalar @speed
        
        steeringForce = desiredVelocity.clone().sub @velocity
        steeringForce.divideScalar @mass
        @velocity.add steeringForce


module.exports = PathSteeringBoid;