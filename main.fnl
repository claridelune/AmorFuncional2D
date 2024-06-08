(local game (fennel.dofile "game.fnl"))
;(local test (fennel.dofile "testBeats.fnl"))
;(local animation (fennel.dofile "testAnimation.fnl"))
;; uncomment test and comment game to run testBeats scene

;(fn love.load []
;  (test.load)
;  (animation.load)
;)

;(fn love.update [dt]
;  (test.update dt)
;  (animation.update dt)
;)

(fn love.draw []
  (game.draw)
  ;(test.draw)
  ;(animation.draw)
)

(fn love.keypressed [key]
  (game.keypressed key)
  ;(test.keypressed key)
)
