THREE = require '../../lib/Three.js'

class Preset

    constructor: ( @container, settings) ->

        @width = settings.width || 960
        @height = settings.height || 600

        @canvas = document.createElement 'canvas'
        @canvas.width = @width
        @canvas.height = @height
        @ctx = @canvas.getContext '2d'
        @renderer = new THREE.CanvasRenderer()
        @renderer.setSize @width, @height
        @renderer.autoClear = false

        @scene = new THREE.Scene()
        @camera = new THREE.PerspectiveCamera 45, @width/@height, 1, 5000
        @camera.position.set 0, 0, 200

        #@container.appendChild @renderer.domElement
        @container.appendChild @canvas

    update: () ->


    render: () ->
        @ctx.clearRect 0, 0, @width, @height

    resize: ( w=960, h=600 ) ->

        @width = w
        @height = h
        @renderer.setSize w, h
        @camera.aspect = w/h
        @camera.updateProjectionMatrix()
        @canvas.width = @width
        @canvas.height = @height

module.exports = Preset;