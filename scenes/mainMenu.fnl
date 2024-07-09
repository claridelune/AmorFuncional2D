(var changeScene 0)

(var titleFont nil)

(fn load []
  (set changeScene 0)
  (love.graphics.setLineWidth 4)
  (set titleFont (love.graphics.newFont :assets/Coolville.otf 100))
  (tset _G :totalLevels 4)
)

(fn update [dt]
  changeScene
)

(fn draw []
  (let [
    xx (love.mouse.getX)
    yy (love.mouse.getY)
    gen (and (<= 750 xx) (<= xx 960))
    ff (and gen (and (<= 300 yy) (< yy 330)))
    ss (and gen (and (<= 400 yy) (< yy 430)))
    tt (and gen (and (<= 500 yy) (< yy 530)))
    ]
    (if ff (love.graphics.setColor 1 1 1) (love.graphics.setColor 0.5 0.5 0.5))
    (love.graphics.print "Play" 750 300)
    (if ss (love.graphics.setColor 1 1 1) (love.graphics.setColor 0.5 0.5 0.5))
    (love.graphics.print "Select Level" 750 400)
    (if tt (love.graphics.setColor 1 1 1) (love.graphics.setColor 0.5 0.5 0.5))
    (love.graphics.print "Config" 750 500)
    (when (and ff (love.mouse.isDown 1))
      (tset _G :currSong 1)
      (set changeScene 1)
    )
    (when (and ss (love.mouse.isDown 1))
      (set changeScene 6)
    )
    (when (and tt (love.mouse.isDown 1))
      (set changeScene 2)
    )
  )
  (love.graphics.setColor 0 0 1)
  (love.graphics.rectangle "line" 325 300 300 300)
  (love.graphics.setColor 1 1 0)
  (love.graphics.rectangle "line" 316 291 300 300)
  (love.graphics.setFont titleFont)
  (love.graphics.print "BeatMap" 250 150)
)

(fn keypressed [key]
)

{
  : load
  : update
  : draw
  : keypressed
}
