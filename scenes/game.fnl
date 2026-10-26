(local audio (fennel.dofile "audio/audio.fnl"))
(local animations (fennel.dofile "animation/init.fnl"))
(local songData (fennel.dofile "audio/songData.fnl"))
(local highScores (. _G :highScores))
(local labels ["Nope!" "Ok " "Great!" "Perfect!" "Miss!" ""])
(local colors [[1 0 0] [0 1 0] [0 1 0] [0 1 0] [1 0 0] [1 1 0]])
(local beatAnimationDur 5)

(var songId 4)
(var bar 1)
(var popUpMenu false)
(var paused false)
(local titleFont (love.graphics.newFont :assets/Coolville.otf 70))
(local resultFont (love.graphics.newFont :assets/Coolville.otf 24))
(var lastBeat -1)
(var everyNBeats 0)
(var newSquares 0)
(var updateBoard true)
(var minWinScore nil)

(var score 0)
(var songKey "")
(var bestScore 0)
(var newHighScore false)
(var saveError nil)

(local vals [0 50 100 200])

(var lastLabel 5)

(var moveBS 1)

(var changeScene 0)

;;(var fullscreen false)	

(var padding (* (love.graphics.getHeight) 0.02))
(var box (- (love.graphics.getHeight) (* 2 padding)) )
(var cuadrado (/ box 6))
(var inicio (/ (- (love.graphics.getWidth) box) 2))

(var bigx (love.math.random 0 4))
(var bigy (love.math.random 0 4))
(var bigSquare (animations.createRectangle {:x (+ inicio (* cuadrado bigx))
                                            :y (+ padding (* cuadrado bigy))
                                            :w (* cuadrado 2)
                                            :h (* cuadrado 2)
                                            :borderThickness 8
                                            :r 0
                                            :g 0
                                            :b 1
                                            :line true}))
(animations.initAll bigSquare)

(var nSquares 8)
(var listS [])
(for [i 1 nSquares 1]
  (table.insert listS [false 0 0 nil])
)

(fn correctx [a]  ;; 1 1 - 5 4
  (if (= (% bigx 2) (% a 2))
    true
    false
  )
)

(fn correcty [a]
  (if (= (% bigy 2) (% a 2))
    true
    false
  )
)

(fn correct [a b]
  (if (and (correctx a) (correcty b))
    true
    false
  )
)

(fn valid [xx yy pressedCorrectly]
  (var return false)
  (local incorrectSquare nil)
  (for [i nSquares 2 -1]
    (if (and (correct (+ xx (. (. listS i) 2)) (+ yy (. (. listS i) 3))) (not (. (. listS (- i 1)) 1)))
      (do
        (if (. (. listS i) 1)
          (set return true)
        )
        (tset listS i 1 false)
        (tset (. (. listS i) 4) :appearing false)
        (tset (. (. listS i) 4) :grow true)
        (if pressedCorrectly
          (animations.setColor (. (. listS i) 4) 0.322 0.878 0.431)
          (animations.setColor (. (. listS i) 4) 1 0.529 0)
        )
        )
      )
  )
  (if (correct (+ xx (. (. listS 1) 2)) (+ yy (. (. listS 1) 3)))
    (do
      (if (. (. listS 1) 1)
        (set return true)
      )
      (tset listS 1 1 false)
      (tset (. (. listS 1) 4) :appearing false)
      (tset (. (. listS 1) 4) :grow true)
      (if pressedCorrectly
        (animations.setColor (. (. listS 1) 4) 0.322 0.878 0.431)
        (animations.setColor (. (. listS 1) 4) 1 0.529 0)
      ))
    )
  return
)



(fn rSquares []
  (if (not (. (. listS nSquares) 1))  ;; Si el último cuadrado no está activo
    [(set nSquares newSquares)
    (set bigx (love.math.random 0 4))
    (set bigy (love.math.random 0 4))
    (for [k 1 nSquares 1]
      (for [i 1 nSquares 1]
        (var x (love.math.random 0 5))
        (var y (love.math.random 0 5))
        (var control true)
        (while control
          (set control false)
          (for [j 1 (- i 1) 1]
            (if (and (= (. (. listS j) 2) x) (= (. (. listS j) 3) y))
              [
                (set x (love.math.random 0 5))
                (set y (love.math.random 0 5))
                (set control true)
              ]
            )
          )
        )
        (let [rect (animations.createRectangle {
                                               :x (+ inicio (* cuadrado x)) 
                                               :y (+ padding (* cuadrado y)) 
                                               :w cuadrado 
                                               :h cuadrado 
                                               :borderThickness 4 
                                               :r 1 
                                               :g 1 
                                               :b 0 
                                               :colorChange false 
                                               :grow false 
                                               :thicken false 
                                               :alpha 1 
                                               :line true})]
          (animations.initAll rect)
          (tset listS i [true x y rect]))
      )
    )
    (set updateBoard false)]
  )
)

(fn moveBigS []
  (var i 1)
  (while (and (<= i nSquares) (not (. (. listS i) 1)))
    (set i (+ 1 i))
  )
  (when (<= i nSquares)
    (let [target-x (if (= (% (. (. listS i) 2) 2) (% bigx 2))
                    (. (. listS i) 2)
                    (- (. (. listS i) 2) 1))
          target-y (if (= (% (. (. listS i) 3) 2) (% bigy 2))
                    (. (. listS i) 3)
                    (- (. (. listS i) 3) 1))]
      (animations.move.init bigSquare (+ inicio (* cuadrado target-x)) (+ padding (* cuadrado target-y)) 0.1))
    (set moveBS 0)
  )
)

(fn load []
  (set moveBS 1)
  (for [i 1 8 1]
    (tset listS i [false 0 0 nil])
  )
  (set score 0)
  (set lastLabel 5)
  (set bar 1)
  (set changeScene 0)
  (set songId (. _G :currSong))
  (set songKey (songData.getSongTitle songId))
  (set bestScore (highScores.getScore songKey))
  (set newHighScore false)
  (set saveError nil)
  (set popUpMenu false)
  (set paused false)
  (let [barData (songData.getBeats songId bar)]
    (audio.init (. barData 1) (. barData 2) (songData.getSongBPM songId) 2 false (songData.getSongTitle songId) (songData.getSongVolume songId))
    (set newSquares (length (. barData 2)))
  )
  (set lastBeat -1)
  (set updateBoard true)
  (set nSquares 1)
  (set minWinScore (songData.getSongMinScore songId))
)

(fn update [dt]
  (animations.update bigSquare dt)

  (when (not (or popUpMenu paused))
    (let [audioState (audio.update dt)]
      (when (= (. audioState 1) 1)
        (var i 0)
        (var j 0)
        (while (not (valid i j false))
          (if (and (= i 0) (= j 0))
            (set j 1)
            (if (and (= i 0) (= j 1))
              (set i 1)
              (if (and (= i 1) (= j 1))
                (set j 0) 
              )
            )
          )
        )
        (set moveBS 1)
        (set lastLabel 4)
      )
      (when (= (. (. audioState 2) 1) 1)
        (set bar (+ 1 bar))
        (let [barData (songData.getBeats songId bar)]
          (when barData
            (audio.changeBeats (. barData 1) (. barData 2))
            (set newSquares (length (. barData 2)))
            (set updateBoard true)
          )
        )

      )
      (when (= (. (. audioState 2) 2) 1)
        (if (= everyNBeats 0)
          (do 
            (set lastBeat beatAnimationDur)
            (set everyNBeats 1)
          )
          (set everyNBeats (- everyNBeats 1))
        )
      )
    )
  )

  (for [i 1 nSquares 1]
    (when (. (. listS i) 4)
      (animations.update (. (. listS i) 4) dt))
  )

  (when (and (not paused)
           (not popUpMenu)
           (audio.audioFinished))
    (set popUpMenu true)

    (set newHighScore (highScores.submitScore songKey score))
    (set bestScore (highScores.getScore songKey))

    (let [(saved errorMessage) (highScores.save)]
      (when (not saved)
        (set saveError (or errorMessage "Could not save high scores"))
      )
  )
  )

  (set lastBeat (- lastBeat 1))

  changeScene
)


(fn draw []

  (when updateBoard
    (rSquares)
  )
  (if (= moveBS 1)
    (moveBigS)
  )
  (love.graphics.clear 0 0 0)

  (let [posLeft 150
        font (. _G :globalFont)
        strScore (tostring score)
        strBest (.. "Best: " (tostring bestScore))
        strLabel (. labels (+ 1 lastLabel))
        cc (. colors (+ 1 lastLabel))
        recordBeaten (> score bestScore)]

    (love.graphics.setColor (. cc 1) (. cc 2) (. cc 3) 1)
    (love.graphics.print strLabel
                        (+ (- posLeft (/ (font:getWidth strLabel) 2)) 10)
                        300)

    (love.graphics.setColor 1 1 1 1)
    (love.graphics.print "Score"
                        (- posLeft (/ (font:getWidth "Score") 2))
                        360)

    (if recordBeaten
      (love.graphics.setColor 0.322 0.878 0.431 1)
      (love.graphics.setColor 1 1 1 1)
    )

    (love.graphics.print strScore
                        (- posLeft (/ (font:getWidth strScore) 2))
                        400)

    (love.graphics.setColor 1 1 0 1)
    (love.graphics.print strBest
                        (- posLeft (/ (font:getWidth strBest) 2))
                        480)

    (when recordBeaten
      (love.graphics.setColor 0.322 0.878 0.431 1)
      (love.graphics.print "Record beaten!"
                          (- posLeft (/ (font:getWidth "Record beaten!") 2))
                          530)
    )

    (love.graphics.setColor 1 1 1 1)
  )
  (love.graphics.setColor 0.5 0.5 0.5 0.5)
  (love.graphics.setLineWidth 2)

  (when (> lastBeat 0)
    (love.graphics.push)
    (let [ww (love.graphics.getWidth) hh (love.graphics.getHeight)]
      (love.graphics.translate (* ww -0.0035) (* hh -0.0035))
      (love.graphics.scale 1.007 1.007)
    )
  )

  (for [i 0 (* cuadrado 6) cuadrado]
  (love.graphics.line inicio (+ padding i) (+ inicio (* cuadrado 6)) (+ padding i))
  (love.graphics.line (+ i inicio) padding (+ i inicio) (+ padding (* cuadrado 6)))
  )

  (love.graphics.setColor 0 0 1 1)
  (love.graphics.setLineWidth 4)
  ; (love.graphics.rectangle "line" (+ inicio (* cuadrado bigx)) (+ padding (* cuadrado bigy)) (* cuadrado 2) (* cuadrado 2) )
  (animations.draw bigSquare)

  (love.graphics.setColor 1 1 0 1)

  (for [i 1 nSquares 1]
        (animations.draw (. (. listS i) 4))
        (love.graphics.print i (+ inicio (* cuadrado (+ (. (. listS i) 2) 0.5))) (+ padding (* cuadrado (+ (. (. listS i) 3) 0.5))))
  )

  (when (> lastBeat 0)
    (love.graphics.pop)
  )

  (when (or paused popUpMenu)
    (love.graphics.setColor 0 0 0 0.6)
    (love.graphics.rectangle :fill 0 0 (love.graphics.getWidth) (love.graphics.getHeight))
    (let [
      xx (love.mouse.getX)
      yy (love.mouse.getY)
      w2100 (- (/ (love.graphics.getWidth) 2) 100)
      centerX (/ (love.graphics.getWidth) 2)
      font (. _G :globalFont)
      strScore (.. "Score: " (tostring score))
      strBest (.. "Best: " (tostring bestScore))
      gen (and (<= w2100 xx) (<= xx (+ w2100 170)))
      next (and (and (not paused) (>= score minWinScore)) (< songId (. _G :totalLevels)))
    ]
      (if (and gen (and (<= 400 yy) (< yy 430)))
        (love.graphics.setColor 1 1 1 1)
        (love.graphics.setColor 0.5 0.5 0.5 1)
      )
      (if paused
        (love.graphics.print "Restart" (+ w2100 25) 400)
        (love.graphics.print "Play Again" (+ w2100 3) 400)
      )
      (when next
        (if (and gen (and (<= 500 yy) (< yy 530)))
          (love.graphics.setColor 1 1 1 1)
          (love.graphics.setColor 0.5 0.5 0.5 1)
        )
        (love.graphics.print "Next Level" w2100 500)
      )
      (if (and gen (and (<= (if next 600 500) yy) (< yy (if next 630 530))))
        (love.graphics.setColor 1 1 1 1)
        (love.graphics.setColor 0.5 0.5 0.5 1)
      )
      (love.graphics.print "Main Menu" (+ w2100 8) (if next 600 500))
      (love.graphics.setColor 1 1 1)
      (when (not paused)
      (love.graphics.setFont font)
      (love.graphics.setColor 1 1 1 1)
      (love.graphics.print strScore
                          (- centerX (/ (font:getWidth strScore) 2))
                          310)

      (love.graphics.setFont resultFont)
      (love.graphics.setColor 1 1 0 1)
      (love.graphics.print strBest
                          (- centerX (/ (resultFont:getWidth strBest) 2))
                          355)

      (when newHighScore
        (love.graphics.setColor 0.322 0.878 0.431 1)
        (love.graphics.print "New High Score!"
                            (- centerX (/ (resultFont:getWidth "New High Score!") 2))
                            280)
      )

      (when saveError
        (let [message "Could not save high scores. Changes may be lost on exit."]
          (love.graphics.setColor 1 0.529 0 1)
          (love.graphics.print message
                              (- centerX (/ (resultFont:getWidth message) 2))
                              660)
        )
      )

      (love.graphics.setFont font)
      (love.graphics.setColor 1 1 1 1)
    )
      (love.graphics.setColor 1 1 0)
      (love.graphics.setFont titleFont)
      (if paused
        (love.graphics.print "Paused" (- w2100 17) 200)
        (if (>= score minWinScore)
          (love.graphics.print "Level Completed!" (- w2100 180) 200)
          (love.graphics.print "Try Again!" (- w2100 60) 200)
        )
      )
    )
  )

  (let [xx (love.mouse.getX) yy (love.mouse.getY)]
    (if (and (and (and (> xx 1150) (< xx 1200)) (and (> yy 20) (< yy 60))) (audio.audioStarted))
      (love.graphics.setColor 1 1 1)
      (love.graphics.setColor 0.5 0.5 0.5)
    )
  )
  (love.graphics.setLineWidth 3)
  (love.graphics.circle "line" 1200 30 15)
  (love.graphics.line 1196 23 1196 37)
  (love.graphics.line 1204 23 1204 37)

  ;(audio.drawDebug)
)

(fn keypressed [key]
  (when (and (not (or paused popUpMenu)) (= key "r"))
    (var state (audio.checkBeatState))
    (if (not= state 0)
      [
      (if (valid 0 0 true)
        [(set lastLabel state)
        (set score (+ score (. vals (+ state 1))))
        (set moveBS 1)
        (audio.advanceTarget)]
        (set lastLabel 0))]
      (set lastLabel 0)
    )
    
  )
  (when (and (not (or paused popUpMenu)) (= key "f"))
    (var state (audio.checkBeatState))
    (if (not= state 0)
      [
      (if (valid 0 1 true)
        [(set lastLabel state)
        (set score (+ score (. vals (+ state 1))))
        (set moveBS 1)
        (audio.advanceTarget)]
        (set lastLabel 0)
      )]
      (set lastLabel 0)
    )
  )
  (when (and (not (or paused popUpMenu)) (= key "i"))
    (var state (audio.checkBeatState))
    (if (not= state 0)
      [
      (if (valid 1 0 true)
        [(set lastLabel state)
        (set score (+ score (. vals (+ state 1))))
        (set moveBS 1)
        (audio.advanceTarget)]
        (set lastLabel 0))]
      (set lastLabel 0)
    )
  )
  (when (and (not (or paused popUpMenu)) (= key "j"))
    (var state (audio.checkBeatState))
    (if (not= state 0)
      [
      (if (valid 1 1 true)
        [(set lastLabel state)
        (set score (+ score (. vals (+ state 1))))
        (set moveBS 1)
        (audio.advanceTarget)]
        (set lastLabel 0))]
      (set lastLabel 0)
    )
  )

  (when (= key "escape")
    (if paused
      (do
        (set paused false)
        (audio.play)
      )
      (when (audio.audioStarted)
        (set paused true)
        (audio.pause)
      )
    )
  )

  ;;(when (= key "q")
  ;;  (audio.pause)
  ;;)

  ;;(when (= key "f5")
  ;;  (if fullscreen 
  ;;    [ (love.window.setFullscreen false )
  ;;    (set fullscreen false)
  ;;    ]
  ;;    [ (love.window.setFullscreen true )
  ;;    (set fullscreen true)
  ;;    ]
  ;;  )
  ;;  (set padding (* (love.graphics.getHeight) 0.02))
  ;;  (set box (- (love.graphics.getHeight) (* 2 padding)) )
  ;;  (set cuadrado (/ box 6))
  ;;  (set inicio (/ (- (love.graphics.getWidth) box) 2))  
  ;;)
)

(fn mousepressed [xx yy button]
  (when (= button 1)
    (let [xx (love.mouse.getX) yy (love.mouse.getY)]
      (when (and (and (> xx 1150) (< xx 1200)) (and (> yy 20) (< yy 60)))
        (if paused
          (do
            (set paused false)
            (audio.play)
          )
          (when (audio.audioStarted)
            (set paused true)
            (audio.pause)
          )
        )
      )
    )
  )
  (when (and (= button 1) (or paused popUpMenu))
    (let [
      w2100 (- (/ (love.graphics.getWidth) 2) 100)
      gen (and (<= w2100 xx) (<= xx (+ w2100 170)))
      next (and (not paused) (< songId (. _G :totalLevels)))
    ]
      (when (and gen (and (<= 400 yy) (< yy 430)))
        (audio.stop)
        (load)
      )
      (when (and (and gen (and (<= 500 yy) (< yy 530)) next))
        (audio.stop)
        (tset _G :currSong (+ songId 1))
        (load)
      )
      (when (and gen (and (<= (if next 600 500) yy) (< yy (if next 630 530))))
        (set changeScene 5)
        (audio.stop)
      )
    )
  )
)
    
{
  :load load
  :update update
  :draw draw
  :keypressed keypressed
  :mousepressed mousepressed
}
