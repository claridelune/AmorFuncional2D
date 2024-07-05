(local fade {})

(fn fade.init [rect init-alpha init-transition-speed]
  (set rect.alpha (or init-alpha 1))
  (set rect.transitionSpeed (or init-transition-speed 0.85)))

(fn fade.update [rect dt]
  (if rect.appearing
      (set rect.alpha (math.min (+ rect.alpha (* rect.transitionSpeed dt))1))
      (set rect.alpha (math.max (- rect.alpha (* rect.transitionSpeed dt))0))))

fade	
