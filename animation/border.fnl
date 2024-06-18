(local border {})

(fn border.init [rect
                         init-border-thickness
                         init-max-border-thickness
                         init-border-transition-speed]
  (set rect.borderThickness (or init-border-thickness 1))
  (set rect.maxBorderThickness (or init-max-border-thickness 10))
  (set rect.borderTransitionSpeed (or init-border-transition-speed 20)))

(fn border.update [rect dt]
  (when rect.thicken
    (set rect.borderThickness (math.min (+ rect.borderThickness (* rect.borderTransitionSpeed dt)) rect.maxBorderThickness))
    (when (= rect.borderThickness rect.maxBorderThickness)
      (set rect.thicken false))))

border
