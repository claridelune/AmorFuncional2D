; (local game (require :src.game))
(local game (fennel.dofile "game.fnl"))

(fn love.draw []
  (game.draw)
)

(fn love.keypressed [key]
  (game.keypressed key)
)
