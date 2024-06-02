(local box 900)
(local cuadrado (/ box 6))
(var first true)
(var second true)
(var third true)

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
  (love.graphics.rectangle "line" 150 150 (* cuadrado 2) (* cuadrado 2) )

  (love.graphics.setColor 1 1 0 1)

  (if first
    (love.graphics.rectangle "line" (* cuadrado 5) (* cuadrado 4) cuadrado cuadrado)
  )
  (if second
    (love.graphics.rectangle "line" (* cuadrado 4) (* cuadrado 1) cuadrado cuadrado)
  )
  (if third
    (love.graphics.rectangle "line" (* cuadrado 0) (* cuadrado 4) cuadrado cuadrado)
  )
  
  )

  (fn love.keypressed [key]
  ;;(when (= key "r")
  ;;  (set first true))
  (when (= key "f")
    (set first false))
  (when (= key "o")
    (set second false))
  (when (= key "k")
    (set third false))
  (when (= key "escape")
    (love.event.quit)))
    
    
)

{:draw draw}
