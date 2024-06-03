(local beats (fennel.dofile "beats.fnl"))
(local window 0.05)
(local offset 0.04)
(var correct 0)
(var incorrect 0)
(var colorR 1)
(var colorG 1)
(var debug1 0)
(var debug2 0)
(var debug3 0)
(var debug4 0)
(var debug5 0)

;; test scene: press any button when hearing "toc" sound

(fn load []
  (beats.init [1 3 4] [5 7 8] 300 2)
  (love.graphics.setColor 1 1 0)
)

(fn update [dt]
  (beats.update dt)
)

(fn draw []
  (love.graphics.setColor colorR colorG 0)
  (love.graphics.setLineWidth 4)
  (love.graphics.rectangle "line" 300 300 300 300)
  (love.graphics.print correct 500 100)
  (love.graphics.print incorrect 600 100)
  (love.graphics.print debug1 500 200)
  (love.graphics.print debug2 600 200)
  (love.graphics.print debug3 700 200)
  (love.graphics.print debug4 500 250)
  (love.graphics.print debug5 600 250)
)

(fn keypressed [key]
  (let [(lastBeat nextBeat) (unpack (beats.get2Beats))
    (lastTime nextTime) (unpack (beats.get2CorrectTimes))
    currTime (+ (beats.getCurrentAudioTime) offset)]
    (if (or (and (<= (- lastTime window) currTime) (<= currTime (+ lastTime window)) (or (= lastBeat 5) (= lastBeat 7) (= lastBeat 8))) (and (<= (- nextTime window) currTime) (<= currTime (+ nextTime window)) (or (= nextBeat 5) (= nextBeat 7) (= nextBeat 8))))
      (do (set correct (+ correct 1)) (set colorG 1) (set colorR 0))
      (do (set incorrect (+ incorrect 1)) (set colorG 0) (set colorR 1))
    )
    (set debug1 lastTime)
    (set debug2 nextTime)
    (set debug3 currTime)
    (set debug4 lastBeat)
    (set debug5 nextBeat)
  )
)

{
  : load
  : update
  : draw
  : keypressed
}
