(var changeScene 0)
(var titleFont nil)
(var subtitleFont nil)
(var textFont nil)
(var creditsY 600)
(var creditsX 400)
(local ending (love.audio.newSource "assets/swimming_fever.mp3" :stream))

(fn load []
  (set changeScene 0)
  (love.graphics.setLineWidth 4)
  (set titleFont (love.graphics.newFont :assets/Coolville.otf 100))
  (set subtitleFont (love.graphics.newFont :assets/Coolville.otf 40))
  (set textFont (love.graphics.newFont :assets/Coolville.otf 30))
  (ending:setVolume 0.3)
  (ending:play)
  (set creditsY (love.graphics.getHeight))
)

(fn update [dt]
  (set creditsY (- creditsY (* dt 50)))

  (when (< creditsY -1200)
    (set changeScene 5) 
    (ending:stop)
  )

  changeScene
)

(fn draw []
  (love.graphics.setFont titleFont)
  (love.graphics.setColor 0 0 1)
  (love.graphics.print "Map" (+ creditsX 225) creditsY)
  (love.graphics.setColor 1 1 0)
  (love.graphics.print "Beat" (+ creditsX 160) (- creditsY 30))

  
  (love.graphics.setFont subtitleFont)
  (love.graphics.setColor 1 1 1)
  (love.graphics.print "Programmers:" creditsX (+ creditsY 110))
  (love.graphics.setFont textFont)
  (love.graphics.setColor 0.5 0.5 0.5)
  (love.graphics.print "runosake" creditsX (+ creditsY 170))
  (love.graphics.print "Paul Becerra" creditsX (+ creditsY 230))
  (love.graphics.print "claridelune" creditsX (+ creditsY 290))

  (love.graphics.setFont subtitleFont)
  (love.graphics.setColor 1 1 1)
  (love.graphics.print "Music:" creditsX (+ creditsY 370))

  (love.graphics.setFont textFont)
  (love.graphics.setColor 0.5 0.5 0.5)
  (love.graphics.print "BitCrushing" creditsX (+ creditsY 430))
  (love.graphics.print "Author:" creditsX (+ creditsY 470))
  (love.graphics.print "Victor Leao" creditsX (+ creditsY 510))

  (love.graphics.print "Mandatory Overtime" creditsX (+ creditsY 570))
  (love.graphics.print "Author:" creditsX (+ creditsY 610))
  (love.graphics.print "Joth" creditsX (+ creditsY 650))

  (love.graphics.print "On My Way [8 Bit Loop]" creditsX (+ creditsY 710))
  (love.graphics.print "Author:" creditsX (+ creditsY 750))
  (love.graphics.print "DeltaBreaker" creditsX (+ creditsY 790))

  (love.graphics.print "Cute March Music" creditsX (+ creditsY 850))
  (love.graphics.print "Author:" creditsX (+ creditsY 890))
  (love.graphics.print "DeltaBreaker" creditsX (+ creditsY 930))

  (love.graphics.print "Swimming Fever" creditsX (+ creditsY 990))
  (love.graphics.print "Author:" creditsX (+ creditsY 1040))
  (love.graphics.print "C418" creditsX (+ creditsY 1080))

  (let [xx (love.mouse.getX) yy (love.mouse.getY)]
    (if (and (and (> xx 890) (< xx 985)) (and (> yy 100) (< yy 125)))
      (love.graphics.setColor 1 1 1)
      (love.graphics.setColor 0.5 0.5 0.5)
    )
  )
  (love.graphics.print "Return" 900 100)
)


(fn mousepressed [xx yy button]
  (when (= button 1)
    (when (and (and (> xx 890) (< xx 985)) (and (> yy 100) (< yy 125)))
      (set changeScene 5) 
      (ending:stop)
    )
  )
)

{
  :load load
  :update update
  :draw draw
  :mousepressed mousepressed
}
