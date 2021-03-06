do (
    Game = platform.module 'game'
    Util = platform.module 'util'
    MapUtil = platform.module 'util.map'
    Keyboard = platform.module 'keyboard'
    {Event} = platform.module 'mixin'
) ->

    class Game.Human extends Game.Entity

        Event.mixin @::

        key: 'human'

        defaults: Util.extend {}, @::defaults,
            width: 7
            height: 10
            jumpPower: 9

        initialize: ->
            @bindKey ['UP', 'W'], => @jump()
            @bindKey ['DOWN', 'S'], => @moveSouth @acceleration
            @bindKey ['RIGHT', 'D'], => @moveEast @acceleration
            @bindKey ['LEFT', 'A'], => @moveWest @acceleration
            @bindKey ['SPACE'], => @act()
            return

        update: ->
            @interacting = false
            super
            @canJump or= @onGround()
            return

        interact: (tile) ->
            if @interacting and tile.key is 'exit'
                @trigger 'action:exit'
            return

        act: ->
            @interacting = true
            return

        jump: ->
            return unless @canJump
            @canJump = false
            @moveNorth @jumpPower
            return

        onGround: ->
            index = MapUtil.mapPositionToIndex @x, @y
            tile = @map.get index.x, index.y + 1
            @isObstacle(tile) and tile.y is Math.round @y + @height

        bindKey: (keys, fn) ->
            keys = [keys] unless Array.isArray keys

            for key in keys
                do (key=key) ->
                    Keyboard.Delegate.down key, fn
                    Keyboard.Delegate.up key, fn
            return
