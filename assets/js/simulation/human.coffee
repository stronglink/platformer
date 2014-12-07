#= require simulation/entity

do (
    Entity = platform.module 'entity'
    Keyboard = platform.module 'keyboard'
) ->

    class Entity.Human extends Entity.Base

        defaults:
            image: 'human.png'
            width: 7
            height: 10
            gravity: 0.5
            acceleration: .4
            jumpPower: 10
            maxVelocity: 5

        initialize: ->
            @bindKey ['UP', 'W'], @jump.bind @
            @bindKey ['DOWN', 'S'], => @moveSouth @acceleration
            @bindKey ['RIGHT', 'D'], => @moveEast @acceleration
            @bindKey ['LEFT', 'A'], => @moveWest @acceleration

        update: ->
            super
            @canJump or= @onGround()

        jump: ->
            return unless @canJump
            @canJump = false
            @moveNorth @jumpPower

        bindKey: (keys, fn) ->
            keys = [keys] unless Array.isArray keys

            for key in keys
                do (key=key) ->
                    Keyboard.Delegate.down key, fn
                    Keyboard.Delegate.up key, fn
