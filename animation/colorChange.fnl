(local color-change {})

(fn change [rect dt]
  (if (= rect.phase 1)
      (do
        (set rect.g (+ rect.g dt))
        (when (>= rect.g 1) (set rect.phase 2))) (= rect.phase 2)
      (do
        (set rect.r (- rect.r dt))
        (when (<= rect.r 0) (set rect.phase 3))) (= rect.phase 3)
      (do
        (set rect.b (+ rect.b dt))
        (when (>= rect.b 1) (set rect.phase 4))) (= rect.phase 4)
      (do
        (set rect.g (- rect.g dt))
        (when (<= rect.g 0) (set rect.phase 5))) (= rect.phase 5)
      (do
        (set rect.r (+ rect.r dt))
        (when (>= rect.r 1) (set rect.phase 6))) (= rect.phase 6)
      (do
        (set rect.b (- rect.b dt))
        (when (<= rect.b 0) (set rect.phase 1)))))

(fn color-change.init [rect] (set rect.phase 1))

(fn color-change.update [rect dt] (change rect dt))

color-change	
