(local grow-shrink {})

(fn grow-shrink.init [rect
                      init-scale
                      init-max-scale
                      init-min-scale
                      init-transition-speed]
  (set rect.scale (or init-scale 1))
  (set rect.maxScale (or init-max-scale 1.5))
  (set rect.minScale (or init-min-scale 0.5))
  (set rect.transitionSpeed (or init-transition-speed 0.5)))

(fn grow-shrink.update [rect dt]
  (when rect.grow
    (if (< rect.scale rect.maxScale)
      (set rect.scale (+ rect.scale (* rect.transitionSpeed dt)))
      (set rect.scale rect.maxScale)))
  (when (not rect.grow)
    (if (> rect.scale rect.minScale)
      (set rect.scale (- rect.scale (* rect.transitionSpeed dt)))
      (set rect.scale rect.minScale))))

grow-shrink	
