(local audio (fennel.dofile "audio/audio.fnl"))
(local labels [:Nope! :Ok :Great! :Perfect! ""])

(var colorR 1)
(var colorG 1)
(var streak 0)
(var lastLabel 5)
(var changeScene 0)

(fn load []
  (audio.init 4 [1 3 4] 200 2)
  (love.graphics.setLineWidth 4)
  (set changeScene 0)
  (set colorR 1)
  (set colorG 1)
  (set streak 0)
  (set lastLabel 5)
)

(fn update [dt]
  (audio.update dt)
  changeScene
)

(fn draw []
  (love.graphics.setColor colorR colorG 0)
  (love.graphics.rectangle "line" 300 300 300 300)
  (love.graphics.print "Press c to config delay" 700 300)
  (love.graphics.print "Streak:" 100 300)
  (love.graphics.print streak 150 300)
  (love.graphics.print (. labels lastLabel) 200 300)
  (love.graphics.setColor 1 1 0)
  (audio.drawDebug)
)

(fn keypressed [key]
  (when (= key "c")
    (set changeScene 2)
    (audio.stop)
  )
  (let [beatState (audio.checkBeatState)]
    (case beatState
      3 (do ; Perfect
        (set streak (+ streak 1))
        (set colorG 1)
        (set colorR 0)
        (audio.advanceTarget)
      )
      2 (do ; Great
        (set streak (+ streak 1))
        (set colorG 0.75)
        (set colorR 0.15)
        (audio.advanceTarget)
      )
      1 (do ; Ok
        (set streak (+ streak 1))
        (set colorG 0.5)
        (set colorR 0.3)
        (audio.advanceTarget)
      )
      0 (do ; Nope
        (set streak 0)
        (set colorG 0)
        (set colorR 1)
      )
    )
    (set lastLabel (+ beatState 1))
  )
)

{
  : load
  : update
  : draw
  : keypressed
}
