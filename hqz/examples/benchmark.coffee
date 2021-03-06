#!/usr/bin/env coffee
#
# Modification of sine.coffee, to act as a benchmark scene.
# This has many small objecs, a lot of ray bouncing, a large scene,
# and random variables as object positions.
#
# Micah Elizabeth Scott <micah@scanlime.org>
# Creative Commons BY-SA license:
# http://creativecommons.org/licenses/by-sa/3.0/
#

RAYS = 100000

TAU = Math.PI * 2
deg = (degrees) -> degrees * TAU / 360
plot = require './plot'

lerp = (frame, length, a, b) ->
    a + (b - a) * frame / length

sunlight = (frame) ->
    # Warm point source
    x = lerp frame, 600, 1920, -200
    [ 1.0, x, -20, 0, 0, [0, 180], [5000, 'K'] ]

sealight = (frame) ->
    # Big diffuse light, with a blueish color
    x = lerp frame, 600, 1920, -800
    [ 0.1, [x-300, x+300], 1200, 0, 0, [180, 360], [10000, 'K'] ]

sineFunc = (frame, seed, x0, y0, w, h, angle) ->
    (t) ->
        e = lerp frame, 600, 300, 50
        u = lerp frame, 600, 20, 10
        scale = Math.pow(e, t)
        x = w * t
        y = h * Math.sin(t*(u + scale)) / (1 + scale)
        dx = Math.cos angle
        dy = Math.sin angle
        [ x0 + dx*x + dy*y, y0 + dy*x - dx*y ]

fuzzify = (objs) ->
    # Use random variables for line position, to test AABBs
    for o in objs
        o[1] = [ o[1] - 5, o[1] + 5 ]
        o[2] = [ o[2] - 5, o[2] + 5 ]
    return objs    

frames = do (frame = 0) ->

    resolution: [1920, 1080]
    rays: RAYS
    exposure: 0.65
    gamma: 2.2

    viewport: [0, 0, 1920, 1080]
    seed: frame * RAYS / 20

    lights: [
        sunlight frame
        sealight frame
    ]

    materials: [
        [ [0.1, "d"], [0.9, "r"] ]
    ]

    objects: [
        # No fixed objects
    ].concat(
        fuzzify plot
            material: 0
            sineFunc frame, '1', -140, 470, 3000, 900, deg 10 
    )

console.log JSON.stringify frames
