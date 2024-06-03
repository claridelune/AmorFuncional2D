(local game (fennel.dofile "game.fnl"))
;(local test (fennel.dofile "testBeats.fnl"))
;; uncomment test and comment game to run testBeats scene

;(fn love.load []
;  (test.load)
;)

;(fn love.update [dt]
;  (test.update dt)
;)

(fn love.draw []
  (game.draw)
  ;(test.draw)
)

(fn love.keypressed [key]
  (game.keypressed key)
  ;(test.keypressed key)
)
