(local color-change {})

(var (rect r g b phase) nil)

(fn change [dt]
  (if (= phase 1) (do
                    (set g (+ g dt))
                    (when (>= g 1) (set phase (+ phase 1))))
      (= phase 2) (do
                   (set r (- r dt))
                   (when (<= r 0) (set phase (+ phase 1))))
      (= phase 3) (do
                   (set b (+ b dt))
                   (when (>= b 1) (set phase (+ phase 1))))
      (= phase 4) (do
                   (set g (- g dt))
                   (when (<= g 0) (set phase (+ phase 1))))
      (= phase 5) (do
                   (set r (+ r dt))
                   (when (>= r 1) (set phase (+ phase 1))))
      (= phase 6) (do
                   (set b (- b dt))
                   (when (<= b 0) (set phase 1)))))

(fn color-change.init [init-rect init-r init-g init-b] (set rect init-rect)
  (set r init-r)
  (set g init-g)
  (set b init-b)
  (set phase 1))

(fn color-change.update [dt] (change dt))

(fn color-change.draw [] (love.graphics.setColor r g b)
  (love.graphics.rectangle :fill rect.x rect.y rect.w rect.h))

color-change	
