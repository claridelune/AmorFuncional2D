(local box 900)
(local cuadrado (/ box 6))
(var first true)
(var second true)
(var third true)

(var bigx 1)
(var bigy 1)

(var x1 5)
(var x2 4)
(var x3 0)

(var y1 4)
(var y2 1)
(var y3 4)

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

  (for [i cuadrado (* cuadrado 6) cuadrado]
  (love.graphics.line 0 i (* cuadrado 6) i)
  (love.graphics.line i 0 i (* cuadrado 6))
  )

  (love.graphics.setColor 0 0 1 1)
  (love.graphics.setLineWidth 4)
  (love.graphics.rectangle "line" (* cuadrado bigx) (* cuadrado bigy) (* cuadrado 2) (* cuadrado 2) )

  (love.graphics.setColor 1 1 0 1)

  (if first
    [(love.graphics.rectangle "line" (* cuadrado x1) (* cuadrado y1) cuadrado cuadrado)
    (love.graphics.print "1" (* cuadrado (+ x1 0.5)) (* cuadrado (+ y1 0.5)))]
  )
  (if second
    [(love.graphics.rectangle "line" (* cuadrado x2) (* cuadrado y2) cuadrado cuadrado)
    (love.graphics.print "2" (* cuadrado (+ x2 0.5)) (* cuadrado (+ y2 0.5)))]
  )
  (if third
    [(love.graphics.rectangle "line" (* cuadrado x3) (* cuadrado y3) cuadrado cuadrado)
    (love.graphics.print "3" (* cuadrado (+ x3 0.5)) (* cuadrado (+ y3 0.5)))]
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
