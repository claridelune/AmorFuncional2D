(var changeScene 0)
(var titleFont nil)
(var subtitleFont nil)
(var textFont nil)
(var creditsY 600)
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
  changeScene
)

(fn draw []
  (love.graphics.setFont titleFont)
  (love.graphics.setColor 0 0 1)
  (love.graphics.print "Map" 525 creditsY)
  (love.graphics.setColor 1 1 0)
  (love.graphics.print "Beat" 460 (- creditsY 30))

  
  (love.graphics.setFont subtitleFont)
  (love.graphics.setColor 1 1 1)
  (love.graphics.print "Programmers:" 500 (+ creditsY 110))
  (love.graphics.setFont textFont)
  (love.graphics.setColor 0.5 0.5 0.5)
  (love.graphics.print "Mariana Caceres" 500 (+ creditsY 170))
  (love.graphics.print "Paul Becerra" 500 (+ creditsY 230))
  (love.graphics.print "claridelune" 500 (+ creditsY 290))

  (love.graphics.setFont subtitleFont)
  (love.graphics.setColor 1 1 1)
  (love.graphics.print "Music:" 500 (+ creditsY 370))

  (love.graphics.setFont textFont)
  (love.graphics.setColor 0.5 0.5 0.5)
  (love.graphics.print "BitCrushing" 500 (+ creditsY 430))
  (love.graphics.print "Author:" 500 (+ creditsY 470))
  (love.graphics.print "Victor Leao" 500 (+ creditsY 510))

  (love.graphics.print "Mandatory Overtime" 500 (+ creditsY 570))
  (love.graphics.print "Author:" 500 (+ creditsY 610))
  (love.graphics.print "Joth" 500 (+ creditsY 650))

  (love.graphics.print "On My Way [8 Bit Loop]" 500 (+ creditsY 710))
  (love.graphics.print "Author:" 500 (+ creditsY 750))
  (love.graphics.print "DeltaBreaker" 500 (+ creditsY 790))

  (love.graphics.print "Cute March Music" 500 (+ creditsY 850))
  (love.graphics.print "Author:" 500 (+ creditsY 890))
  (love.graphics.print "DeltaBreaker" 500 (+ creditsY 930))

  (love.graphics.print "Swimming Fever" 500 (+ creditsY 990))
  (love.graphics.print "Author:" 500 (+ creditsY 1040))
  (love.graphics.print "C418" 500 (+ creditsY 1080))
)

(fn keypressed [key]
  (when (= key "escape")
    (love.event.quit))
)

{
  :load load
  :update update
  :draw draw
  :keypressed keypressed
}
