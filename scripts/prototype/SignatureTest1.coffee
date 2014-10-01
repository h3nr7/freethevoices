
# EXTERNAL LIBS
THREE = require '../lib/Three.js'

# 
Preset = require '../app/preset/Preset.coffee'
Paths = require '../data/Paths.coffee'
PathSteeringBoid = require '../app/behaviour/PathSteeringBoid.coffee'
ParticleEmitter = require '../app/behaviour/ParticleEmitter.coffee'

class SignatureTest1 extends Preset

    constructor: ( @container, settings ) ->


        super @container, settings


        @createPaths()
        @initParticles()
        @startEmitters()


    createPaths: ()->

        @paths = new Paths().getPaths()

        @lines = []
        @linesCanvas = document.createElement 'canvas'
        @linesCanvas.width = @width
        @linesCanvas.height = @height
        @linesCtx = @linesCanvas.getContext '2d'

        @boidsCanvas = document.createElement 'canvas'
        @boidsCanvas.width = @width
        @boidsCanvas.height = @height
        @boidsCtx = @boidsCanvas.getContext '2d'


        for path in @paths
            for p in path
                p.multiply new THREE.Vector3( 1, -1, 1 )

        tl = @getPathsTopLeft()

        tl.multiplyScalar -1

        for path in @paths
            # center to 0,0 for scaling
            #@displace path, c
            #scale path
            @scale path, 4.5

            @displace path, new THREE.Vector3( -400, 0, 0 )

        @createLine @paths[0], '#cccccc'


    initParticles: () ->
        @boids = []
        @cPath = 0
        @ready = false
        @uv = new THREE.Vector2 0, 0


        @sprite = new Image()

        @sprite.onload = () =>
            can = document.createElement 'canvas'
            can.width = @sprite.width
            can.height = @sprite.height
            @spriteCtx = can.getContext '2d'
            @spriteCtx.drawImage @sprite, 0, 0
            # @createColorTable()
            @shadowCount = 0
            @ready = true

        @sprite.src = 'images/brush5.png'
        
        @particlesCanvas = document.createElement 'canvas'
        @particlesCanvas.width = @width
        @particlesCanvas.height = @height
        @particlesCtx = @particlesCanvas.getContext '2d'
        console.log @particlesCtx

        @boidsCanvas = document.createElement 'canvas'
        @boidsCanvas.width = @width
        @boidsCanvas.height = @height
        @boidsCtx = @boidsCanvas.getContext '2d'

        @trailsCanvas = document.createElement 'canvas'
        @trailsCanvas.width = @width
        @trailsCanvas.height = @height
        @trailsCtx = @trailsCanvas.getContext '2d'
        @trailsCtx.lineWidth = 5 #@settings.trailsWidth

        @shadowCanvas = document.createElement 'canvas'
        @shadowCanvas.width = Math.floor @width/4
        @shadowCanvas.height = Math.floor @height/4
        @shadowCtx = @shadowCanvas.getContext '2d'


    startEmitters: () ->

        @emitters = []
        @emitters.push new ParticleEmitter( 1, 1, { position: new THREE.Vector3( Math.random() * @width/2, 0, 0 ), destination: @lines[0].points[0].clone(), colors: '#3300ff', pathId: 0, god: @ } )

        console.log @emitters
        for e in @emitters
            e.start()


    addBoid: ( pId ) ->

        console.log 'addBoid', pId
        path = @lines[pId]
        boid = new PathSteeringBoid path, 5 + ( 1 + Math.random() ) * 0/100, 1, true
        boid.pathId = pId
        @boids.push boid

        return boid


    createLine: (opts, col='#333333') ->

        pts = []
        startPoint = opts[0].clone().add( new THREE.Vector3( @width/2, @height/2, 0 ) )
        for p in opts
            pts.push p.clone().add( new THREE.Vector3( @width/2, @height/2, 0 ) )

        spline = new THREE.SplineCurve3 pts
        @lines.push spline

        console.log 'spline', spline
        @linesCtx.strokeStyle = col
        @linesCtx.beginPath()
        @linesCtx.moveTo pts[0].x, pts[0].y

        for t in [0..1] by .001
            p = spline.getPoint t
            @linesCtx.lineTo p.x, p.y

        @linesCtx.stroke()

        console.log @linesCtx

    getPathsTopLeft: () ->
        c = new THREE.Vector3( 900, 900, 0 )

        for path in @paths
            for pt in path
                if pt.x < c.x
                    c.x = pt.x
                if pt.y < c.y
                    c.y = pt.y

        return c
 
    displace: ( pts, d ) ->
        for p in pts
            p.add d

    scale: ( pts, s ) ->
        for p in pts
            p.multiplyScalar s          


    update: () ->

        super
        ###if @boids.length < @settings.nBoids
            @addBoid()###

        k = 0

        for boid in @boids
            boid.update()

            if boid.finished
                @boids.splice( k, 1 )
                return
            else
                k++

        for e in @emitters
            e.update @boids, 5 , null


    render: () ->
        super()

        if !@ready 
            return

        @ctx.drawImage @linesCanvas, 0, 0

        @boidsCtx.clearRect 0, 0, @width, @height
        @boidsCtx.fillStyle = "#ff3333"
        @boidsCtx.strokeStyle = "#ff3333"

        TP = Math.PI * 2

        # col = @spriteCtx.getImageData 0, 0, 100, 100
        @particlesCtx.globalCompositeOperation = 'darker'
        for boid in @boids
            p = boid.position
            r = boid.rotation + Math.PI/2

            @boidsCtx.save()
            @boidsCtx.translate p.x, p.y
            @boidsCtx.rotate r

            @boidsCtx.beginPath()
            @boidsCtx.arc 0, 0, 2, 0, TP
            @boidsCtx.closePath()
            @boidsCtx.fill()

            @boidsCtx.beginPath()
            @boidsCtx.arc 0, 0, 5, 0, TP
            @boidsCtx.closePath()
            @boidsCtx.stroke()

            @boidsCtx.restore()

            @particlesCtx.save()
            @particlesCtx.translate p.x, p.y
            @particlesCtx.rotate r*Math.random()
            tmpScale = Math.random()
            @particlesCtx.scale tmpScale, tmpScale
            @particlesCtx.drawImage @sprite, -42, -42
            # @particlesCtx.beginPath()
            # @particlesCtx.arc 0, 0, 2, 0, TP
            # @particlesCtx.closePath()
            # @particlesCtx.fill()

            @particlesCtx.restore()

            

        @ctx.drawImage @particlesCanvas, 0, 0
        @ctx.drawImage @boidsCanvas, 0, 0


    resize: ( w, h ) ->
        @width = w
        @height = h
        @container.style.width = w + 'px'
        @container.style.height = h + 'px'
        @canvas.style.width = w + 'px'
        @canvas.style.height = h + 'px'





module.exports = SignatureTest1