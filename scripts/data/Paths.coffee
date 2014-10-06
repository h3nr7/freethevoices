THREE = require '../lib/Three.js'

class Paths

    constructor: () ->
        @paths = []
        @paths.push(
            [
                new THREE.Vector3( 0, 0, 0 ),
                new THREE.Vector3( -22.494, 15.894, 0 ),
                new THREE.Vector3( -22.63, -19.924, 0 ),
                new THREE.Vector3( -10.888, -31.55, 0 ),
                new THREE.Vector3( 5.059, -30.598, 0 ),
                new THREE.Vector3( 21.875, -15.068, 0 ),
                new THREE.Vector3( 30.38, 26.973, 0 ),
                new THREE.Vector3( 48.551, 61.895, 0 ),
                new THREE.Vector3( 67.006, 68.709, 0 ),
                new THREE.Vector3( 92.559, 71.265, 0 )
            ]
        )

    getPaths: () ->
        return @paths

module.exports = Paths;