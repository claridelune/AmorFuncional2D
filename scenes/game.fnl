(local audio (fennel.dofile "audio/audio.fnl"))
(local labels [:Nope! :Ok :Great! :Perfect! :Miss! ""])

(var lastLabel 5)

(var changeScene 0)

(var fullscreen false)	

(var padding (* (love.graphics.getHeight) 0.02))
(var box (- (love.graphics.getHeight) (* 2 padding)) )
(var cuadrado (/ box 6))
(var inicio (/ (- (love.graphics.getWidth) box) 2))

(var bigx (love.math.random 0 4))
(var bigy (love.math.random 0 4))

(var nSquares 4)
(var listS [])
(for [i 1 nSquares 1]
  (table.insert listS [false 0 0 nil])
)

(local animations (fennel.dofile "animation/init.fnl"))

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

(fn valid [xx yy]
  (var return false)
  (for [i nSquares 2 -1]
    (if (and (correct (+ xx (. (. listS i) 2)) (+ yy (. (. listS i) 3))) (not (. (. listS (- i 1)) 1)))
      (do
        (if (. (. listS i) 1)
          (set return true)
        )
        (tset listS i 1 false)
        (tset (. (. listS i) 4) :appearing false)))
  )
  (if (correct (+ xx (. (. listS 1) 2)) (+ yy (. (. listS 1) 3)))
    (do
      (if (. (. listS 1) 1)
        (set return true)
      )
      (tset listS 1 1 false)
      (tset (. (. listS 1) 4) :appearing false)))
  return
)



(fn rSquares []
  (if (not (. (. listS nSquares) 1))  ;; Si el último cuadrado no está activo
    [(set bigx (love.math.random 0 4))
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
          (animations.init-all rect)
          (tset listS i [true x y rect]))
      )
    )]
  )
)

(fn load []
  (audio.init 4 [1 2 3 4] 200 2)
)

(fn update [dt]
  (when (= (. (audio.update dt) 1) 1)
    (var i 0)
    (var j 0)
    (while (not (valid i j))
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
    (set lastLabel 4)
  )

  (for [i 1 nSquares 1]
    (when (. (. listS i) 4)
      (animations.update (. (. listS i) 4) dt))
  )
  changeScene
)


(fn draw []

  (rSquares)
  (love.graphics.clear 0 0 0)

  (love.graphics.print (. labels (+ 1 lastLabel)) 200 300)
  (love.graphics.setColor 0.5 0.5 0.5 0.5)
  (love.graphics.setLineWidth 1)

  (for [i 0 (* cuadrado 6) cuadrado]
  (love.graphics.line inicio (+ padding i) (+ inicio (* cuadrado 6)) (+ padding i))
  (love.graphics.line (+ i inicio) padding (+ i inicio) (+ padding (* cuadrado 6)))
  )

  (love.graphics.setColor 0 0 1 1)
  (love.graphics.setLineWidth 4)
  (love.graphics.rectangle "line" (+ inicio (* cuadrado bigx)) (+ padding (* cuadrado bigy)) (* cuadrado 2) (* cuadrado 2) )

  (love.graphics.setColor 1 1 0 1)

  (for [i 1 nSquares 1]
        (animations.draw (. (. listS i) 4))
        (love.graphics.print i (+ inicio (* cuadrado (+ (. (. listS i) 2) 0.5))) (+ padding (* cuadrado (+ (. (. listS i) 3) 0.5))))
  )
)



(fn keypressed [key]
  (when (= key "r")
    (var state (audio.checkBeatState))
    (if (not= state 0)
      [
      (if (valid 0 0)
        (set lastLabel state)
        (set lastLabel 0))]
      (set lastLabel 0)
    )
    
  )
  (when (= key "f")
    (var state (audio.checkBeatState))
    (if (not= state 0)
      [
      (if (valid 0 1)
        (set lastLabel state)
        (set lastLabel 0)
      )]
      (set lastLabel 0)
    )
  )
  (when (= key "o")
    (var state (audio.checkBeatState))
    (if (not= state 0)
      [
      (if (valid 1 0)
        (set lastLabel state)
        (set lastLabel 0))]
      (set lastLabel 0)
    )
  )
  (when (= key "k")
    (var state (audio.checkBeatState))
    (if (not= state 0)
      [
      (if (valid 1 1)
        (set lastLabel state)
        (set lastLabel 0))]
      (set lastLabel 0)
    )
  )
  (when (= key "1")
    (set changeScene 1)
  )
  (when (= key "2")
    (set changeScene 2)
  )
  (when (= key "3")
    (set changeScene 3)
  )

  (when (= key "f5")
    (if fullscreen 
      [ (love.window.setFullscreen false )
      (set fullscreen false)
      ]
      [ (love.window.setFullscreen true )
      (set fullscreen true)
      ]
    )
    (set padding (* (love.graphics.getHeight) 0.02))
    (set box (- (love.graphics.getHeight) (* 2 padding)) )
    (set cuadrado (/ box 6))
    (set inicio (/ (- (love.graphics.getWidth) box) 2))  
  )

  (when (= key "escape")
    (love.event.quit))
)
    
{
  :load load
  :update update
  :draw draw
  :keypressed keypressed
}
