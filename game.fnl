(local box (love.graphics.getHeight) )
(local cuadrado (/ box 6))
(local inicio (/ (- (love.graphics.getWidth) box) 2))

(var randx (% (love.math.random 6) 6))
(var randy (% (love.math.random 6) 6))	

(var first true)
(var second true)
(var third true)

(var bigx (- (love.math.random 5) 1))
(var bigy (- (love.math.random 5) 1))

(var x1 (- (love.math.random 6) 1))
(var y1 (- (love.math.random 6) 1))

(var x2 (- (love.math.random 6) 1))
(var y2 (- (love.math.random 6) 1))

(while (and (= x1 x2) (= y1 y2)) (set x2 (- (love.math.random 6) 1)))

(var x3 (- (love.math.random 6) 1))
(var y3 (- (love.math.random 6) 1))

(while (or (and (= x1 x3) (= y1 y3)) (and (= x2 x3) (= y2 y3))) (set y3 (- (love.math.random 6) 1)))

(fn turn-two []
  (if (= first false)
    true
    false
  )
)

(fn turn-three []
  (if (= second false)
    true
    false
  )
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

(fn correct1 [a b] ;; 1 1 - 5 4
  (if (correct a b)
    (set first false)
  )
)

(fn correct2 [a b]
  (if (and (correct a b) (turn-two) )
    (set second false)
  )
)

(fn correct3 [a b]
  (if (and (correct a b) (turn-three) )
    (set third false)
  )
)

(
  (fn draw []
  (love.graphics.clear 0 0 0)

  (love.graphics.setColor 0.5 0.5 0.5 0.5)
  (love.graphics.setLineWidth 1)

  (for [i 0 (* cuadrado 6) cuadrado]
  (love.graphics.line inicio i (+ inicio (* cuadrado 6)) i)
  (love.graphics.line (+ i inicio) 0 (+ i inicio) (* cuadrado 6))
  )

  (love.graphics.setColor 0 0 1 1)
  (love.graphics.setLineWidth 4)
  (love.graphics.rectangle "line" (+ inicio (* cuadrado bigx)) (* cuadrado bigy) (* cuadrado 2) (* cuadrado 2) )

  (love.graphics.setColor 1 1 0 1)

  (if first
    [(love.graphics.rectangle "line" (+ inicio (* cuadrado x1)) (* cuadrado y1) cuadrado cuadrado)
    (love.graphics.print "1" (+ inicio (* cuadrado (+ x1 0.5))) (* cuadrado (+ y1 0.5)))]
  )
  (if second
    [(love.graphics.rectangle "line" (+ inicio (* cuadrado x2)) (* cuadrado y2) cuadrado cuadrado)
    (love.graphics.print "2" (+ inicio (* cuadrado (+ x2 0.5))) (* cuadrado (+ y2 0.5)))]
  )
  (if third
    [(love.graphics.rectangle "line" (+ inicio (* cuadrado x3)) (* cuadrado y3) cuadrado cuadrado)
    (love.graphics.print "3" (+ inicio (* cuadrado (+ x3 0.5))) (* cuadrado (+ y3 0.5)))]
  )
  
  )

  (fn keypressed [key]
  (when (= key "r")
    [ (correct3 x3 y3)
      (correct2 x2 y2)
      (correct1 x1 y1)]
  )
  (when (= key "f")
    [ (correct3 x3 (+ y3 1))
      (correct2 x2 (+ y2 1))
      (correct1 x1 (+ y1 1))]
  )
  (when (= key "o")
    [ (correct3 (+ x3 1) y3)
      (correct2 (+ x2 1) y2)
      (correct1 (+ x1 1) y1)]
  )
  (when (= key "k")
    [ (correct3 (+ x3 1) (+ y3 1))
      (correct2 (+ x2 1) (+ y2 1))
      (correct1 (+ x1 1) (+ y1 1))]
  )
  (when (= key "escape")
    (love.event.quit)))
    
    
)

{
  :draw draw
  :keypressed keypressed
}
