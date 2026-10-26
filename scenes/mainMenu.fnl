(var changeScene 0)

(var titleFont nil)

(fn load []
  (set changeScene 0)
  (love.graphics.setLineWidth 4)
  (set titleFont (love.graphics.newFont :assets/Coolville.otf 100))
  (tset _G :totalLevels 5)
  
  (when (not (. _G :maxScoreLvl))
    (tset _G :maxScoreLvl [])
  )

  (for [i 1 (. _G :totalLevels)]
    (when (not (. (. _G :maxScoreLvl) i))
      (tset (. _G :maxScoreLvl) i 0)
    )
  )
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
    ss (and gen (and (<= 355 yy) (< yy 385)))
    tt (and gen (and (<= 410 yy) (< yy 440)))
    cc (and gen (and (<= 465 yy) (< yy 495)))
    qq (and gen (and (<= 520 yy) (< yy 550)))
    ee (and gen (and (<= 575 yy) (< yy 605)))
  ]
    (if ff (love.graphics.setColor 1 1 1) (love.graphics.setColor 0.5 0.5 0.5))
    (love.graphics.print "Play" 750 300)
    (if ss (love.graphics.setColor 1 1 1) (love.graphics.setColor 0.5 0.5 0.5))
    (love.graphics.print "Select Level" 750 355)
    (if tt (love.graphics.setColor 1 1 1) (love.graphics.setColor 0.5 0.5 0.5))
    (love.graphics.print "Config" 750 410)
    (if cc (love.graphics.setColor 1 1 1) (love.graphics.setColor 0.5 0.5 0.5))
    (love.graphics.print "How To Play" 750 465)
    (if qq (love.graphics.setColor 1 1 1) (love.graphics.setColor 0.5 0.5 0.5))
    (love.graphics.print "Credits" 750 520)
    (if ee (love.graphics.setColor 1 1 1) (love.graphics.setColor 0.5 0.5 0.5))
    (love.graphics.print "Exit" 750 575)
  )
  (love.graphics.setColor 0 0 1)
  (love.graphics.rectangle "line" 325 300 300 300)
  (love.graphics.setColor 1 1 0)
  (love.graphics.rectangle "line" 316 291 300 300)
  (love.graphics.setFont titleFont)
  (love.graphics.setColor 0 0 1)
  (love.graphics.print "Map" 425 180)
  (love.graphics.setColor 1 1 0)
  (love.graphics.print "Beat" 360 150)
)

(fn mousepressed [xx yy button]
  (when (= button 1)
    (let [
      gen (and (<= 750 xx) (<= xx 960))
      ff (and gen (and (<= 300 yy) (< yy 330)))
      ss (and gen (and (<= 355 yy) (< yy 385)))
      tt (and gen (and (<= 410 yy) (< yy 440)))
      cc (and gen (and (<= 465 yy) (< yy 495)))
      qq (and gen (and (<= 520 yy) (< yy 550)))
      ee (and gen (and (<= 575 yy) (< yy 605)))
    ]
      (when ff
        (tset _G :currSong 1)
        (set changeScene 1)
      )
      (when ss
        (set changeScene 6)
      )
      (when tt
        (set changeScene 2)
      )
      (when cc
        (set changeScene 8)
      )
      (when qq
        (set changeScene 7)
      )
      (when ee
        (love.event.quit)
      )
    )
  )
)

{
  : load
  : update
  : draw
  : mousepressed
}
