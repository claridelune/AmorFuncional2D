(local animations (fennel.dofile "animation/init.fnl"))
(local updateDur 1)
(local keys ["r " "f " "j " "i "])
(var changeScene 0)
(var comb "")

(var titleFont nil)
(var cuadrado 75)
(var inicio 250)
(var padding 250)
(var bigx 100)
(var bigy 100)
(var nSquares 4)
(var listS [[false 100 200] [false 200 300] [false 400 500] [false 500 600]])
(var bigSquare nil)
(var updateBoard false)
(var lastUpdate nil)
(var moveBS nil)

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
    [;(set nSquares newSquares)
    (set bigx (love.math.random 0 2))
    (set bigy (love.math.random 0 2))
    (for [k 1 nSquares 1]
      (for [i 1 nSquares 1]
        (var x (love.math.random 0 3))
        (var y (love.math.random 0 3))
        (var control true)
        (while control
          (set control false)
          (for [j 1 (- i 1) 1]
            (if (and (= (. (. listS j) 2) x) (= (. (. listS j) 3) y))
              [
                (set x (love.math.random 0 3))
                (set y (love.math.random 0 3))
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
    (set comb "")]
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
  )
)

(fn load []
  (set changeScene 0)
  (love.graphics.setLineWidth 4)
  (set titleFont (love.graphics.newFont :assets/Coolville.otf 70))
  (set bigSquare (animations.createRectangle {:x (+ inicio (* cuadrado bigx))
                                            :y (+ padding (* cuadrado bigy))
                                            :w (* cuadrado 2)
                                            :h (* cuadrado 2)
                                            :borderThickness 8
                                            :r 0
                                            :g 0
                                            :b 1
                                            :line true}))
    (animations.initAll bigSquare)
    (set updateBoard true)
    (set lastUpdate (love.timer.getTime))
    (set moveBS 1)
    (set comb "")
)

(fn update [dt]
  (let [currTime (love.timer.getTime)]
    (when (> currTime (+ lastUpdate updateDur))
        (var i 0)
        (var j 0)
        (var index 1)
        (while (not (valid i j true))
            (if (and (= i 0) (= j 0))
                (do
                    (set j 1)
                    (set index 2)
                )
            (if (and (= i 0) (= j 1))
                (do
                    (set i 1)
                    (set index 3)
                )
                (if (and (= i 1) (= j 1))
                    (do
                        (set j 0)
                        (set index 4)
                    )
                )
            )
            )
        )
        (set comb (.. comb (. keys index)))
        (set moveBS 1)
        (set lastUpdate (+ lastUpdate updateDur))
    )
  )
  (animations.update bigSquare dt)
  (for [i 1 nSquares 1]
    (when (. (. listS i) 4)
      (animations.update (. (. listS i) 4) dt))
  )
  changeScene
)

(fn draw []
    (when updateBoard
        (rSquares)
    )
    (moveBigS)
    
    (let [
        xx (love.mouse.getX)
        yy (love.mouse.getY)
        cond (and (and (<= 250 xx) (<= xx 575)) (and (<= 650 yy) (<= yy 686)))
    ]

        (love.graphics.setColor 0.5 0.5 0.5 0.5)
        (love.graphics.setLineWidth 2)

        (for [i 0 (* cuadrado 4) cuadrado]
        (love.graphics.line inicio (+ padding i) (+ inicio (* cuadrado 4)) (+ padding i))
        (love.graphics.line (+ i inicio) padding (+ i inicio) (+ padding (* cuadrado 4)))
        )

        (love.graphics.setColor 0 0 1 1)
        (love.graphics.setLineWidth 4)
        (animations.draw bigSquare)

        (love.graphics.setColor 1 1 0 1)

        (for [i 1 nSquares 1]
            (animations.draw (. (. listS i) 4))
            (love.graphics.print i (+ inicio (* cuadrado (+ (. (. listS i) 2) 0.5))) (+ padding (* cuadrado (+ (. (. listS i) 3) 0.5))))
        )

        (if cond
            (love.graphics.setColor 1 1 1)
            (love.graphics.setColor 0.5 0.5 0.5)
        )
        (love.graphics.print "Return to main menu" 250 650)
    )

    (love.graphics.setColor 1 1 1 0.5)
    (love.graphics.print "The keys: r, f, i, j are mapped" 650 255)
    (love.graphics.print "to the four quadrants of the" 650 291)
    (love.graphics.print "blue square. You need to press" 650 327)
    (love.graphics.print "the key corresponding to the" 650 363)
    (love.graphics.print "position of the yellow square" 650 399)
    (love.graphics.print "when hearing a toc sound." 650 435)
    (love.graphics.print (.. "Keys: " comb) 650 500)

    (love.graphics.setColor 1 1 0)
    (love.graphics.setFont titleFont)
    (love.graphics.print "HOW TO PLAY" 250 100)
)

(fn mousepressed [xx yy button]
  (when (= button 1)
    (let [
      cond (and (and (<= 250 xx) (<= xx 575)) (and (<= 650 yy) (<= yy 686)))
    ]
      (when cond
        (set changeScene 5)
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
