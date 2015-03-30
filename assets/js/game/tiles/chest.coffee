do (
    Game = platform.module 'game'
    Tile = platform.module 'game.tile'
    Item = platform.module 'game.item'
) ->

    class Tile.Chest extends Game.Tile

        key: 'chest'

        update: (entities) ->
            for entity in entities
                if @collides(entity)
                    entity.interact @
            return

        getItem: ->
            new Item.Jetpack
    
        isWalkable: ->
            true

        collides: (entity) ->
            @x < entity.x + entity.width and
            @x + @width > entity.x and
            @y < entity.y + entity.height and
            @y + @height > entity.y
