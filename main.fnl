(local game (require :src.game))

(fn love.load []
  (game.init))

(fn love.update [dt]
  ;; Update game logic
  (game.update dt))

(fn love.draw []
  ;; Render game
  (game.draw))
