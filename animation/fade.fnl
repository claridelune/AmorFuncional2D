(local fade {})

(fn fade.init [rect init-params]
  (set rect.alpha (or rect.alpha (and init-params (init-params.alpha)) 1))
  (set rect.fadeTransitionSpeed (or rect.fadeTransitionSpeed (and init-params (init-params.fadeTransitionSpeed)) 0.85))
  (set rect.appearing (or rect.appearing (and init-params (init-params.appearing)) false)))

(fn fade.update [rect dt]
  (if rect.appearing
      (set rect.alpha (math.min (+ rect.alpha (* rect.fadeTransitionSpeed dt)) 1))
      (set rect.alpha (math.max (- rect.alpha (* rect.fadeTransitionSpeed dt)) 0))))

fade	
