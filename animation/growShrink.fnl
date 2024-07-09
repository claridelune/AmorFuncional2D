(local grow-shrink {})

(fn grow-shrink.init [rect init-params]
  (set rect.scale (or rect.scale (and init-params (init-params.scale)) 1))
  (set rect.maxScale (or rect.maxScale (and init-params (init-params.maxScale)) 2))
  (set rect.minScale (or rect.minScale (and init-params (init-params.minScale)) 0.5))
  (set rect.growShrinkTransitionSpeed (or rect.growShrinkTransitionSpeed (and init-params (init-params.growShrinkTransitionSpeed)) 1000))
  (set rect.grow (or rect.grow (and init-params (init-params.grow)) false)))

(fn grow-shrink.update [rect dt]
  (if rect.grow
      (set rect.scale (math.min (+ rect.scale (* rect.growShrinkTransitionSpeed dt)) rect.maxScale))
      (set rect.scale (math.max (- rect.scale (* rect.growShrinkTransitionSpeed dt)) rect.minScale))))

grow-shrink	
