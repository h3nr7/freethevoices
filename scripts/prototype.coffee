
TWEEN = require './lib/Tween.js'
Stats = require './lib/Stats.js'

SignatureTest1 = require './prototype/SignatureTest1.coffee'


Main = new ->

    stats = null
    preset = null

    init = ( container, settings ) ->
        console.log "SignatureTest1 BEGINS"

        stats = new Stats()
        stats.domElement.style.position = 'absolute'
        stats.domElement.style.bottom = '0px'
        stats.domElement.style.right = '0px'
        document.body.appendChild stats.domElement

        preset = new SignatureTest1 container, settings

        animate()



    animate = () ->
        requestAnimationFrame animate

        stats.update()
        TWEEN.update()
        preset.update()
        preset.render()


    return {

        init: init,
        resize: ( w, h ) -> preset.resize w, h
    }

window.onload = () ->
    settings = { preset: '', debug: true, width: window.innerWidth, height: window.innerHeight }
    Main.init document.getElementById( 'signature-test1' ), settings

    , false

window.onresize = () ->
    Main.resize Math.max( 480, window.innerWidth ), Math.max( 480, window.innerHeight)