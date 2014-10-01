THREE = require '../../lib/Three.js'

class Trail
    constructor: ( @particle, @buffer=200, @weight=5, @steps=100 ) ->
        @positions = []
        @offset = Math.random() * 10
        @uv = new THREE.Vector2( Math.round( 511 * Math.random() ), Math.round( 9 * Math.random() ) )
        @spline = new THREE.SplineCurve3 @positions

    update: ( col ) ->
        if @particle.dead
            if @positions.length
                @positions.pop()
            return

        if !@positions.length or @positions[0].distanceTo( @particle.position ) > 5
            @positions.unshift @particle.position.clone()
            
            if @positions.length > @buffer
                @positions.splice( @buffer, @positions.length - @buffer )
            
            @uv.x += 1
            
            if @uv.x > 511
                @uv.x = 0
                @uv.y += 1

            if @uv.y > 9
                @uv.set 0, 0

    draw: ( ctx, colors ) ->
        if @positions.length > 2
            t = 1
            p = @spline.getPoint t
            step = -1/@steps
            ctx.strokeStyle = @getGradient ctx, colors  
            i = @uv.x * ( @uv.y + 1 )
            #ctx.strokeStyle = colors[i]
            ctx.beginPath()
            ctx.moveTo p.x, p.y
            for t in [1+step..0] by step
                p = @spline.getPoint t
                ctx.lineTo p.x, p.y
            ctx.stroke()

    createSegment: ( k1, k2, ctx, colors, atlas ) ->
        i = @uvs[k1].x * ( @uvs[k1].y + 1 )
        col = colors[i]
        
        ctx.strokeStyle = colors[i]
        ctx.beginPath()
        ctx.moveTo @positions[k1].x, @positions[k1].y
        ctx.lineTo @positions[k2].x, @positions[k2].y
        ctx.stroke()

        ###uv = @uvs[k1]
        p = @positions[k1]
        hs = @weight/2
        #i = uv.x * ( uv.y + 1 )
        ctx.drawImage atlas, uv.x*16, uv.y*16, 16, 16, p.x-hs, p.y-hs, @weight, @weight

        uv = @uvs[k2]
        p = @positions[k2]
        hs = @weight/2
        #i = uv.x * ( uv.y + 1 )
        ctx.drawImage atlas, uv.x*16, uv.y*16, 16, 16, p.x-hs, p.y-hs, @weight, @weight###
        
    getGradient: ( ctx, colors ) ->
        len = @positions.length-1
        grd = ctx.createLinearGradient @positions[0].x, @positions[0].y, @positions[len].x, @positions[len].y
        #grd = ctx.createLinearGradient 0, 0, 1024, 0
        k = 0

        i = @uv.x * ( @uv.y + 1 )

        for k in[0..len]
            j = (i+k) % (colors.length-1)
            grd.addColorStop( k/len, colors[j] )

        return grd

module.exports = Trail;