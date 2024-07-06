(local border {})

(fn border.init [rect init-params]
  (set rect.maxBorderThickness (or rect.maxBorderThickness (and init-params (init-params.maxBorderThickness)) 10))
  (set rect.borderTransitionSpeed (or rect.borderTransitionSpeed (and init-params (init-params.borderTransitionSpeed)) 10))
  (set rect.borderThickness (or rect.borderThickness 1))
  (set rect.thicken (or rect.thicken false)))

(fn border.update [rect dt]
  (when rect.thicken
    (set rect.borderThickness (math.min (+ rect.borderThickness (* rect.borderTransitionSpeed dt)) rect.maxBorderThickness))
    (when (= rect.borderThickness rect.maxBorderThickness)
      (set rect.thicken false))))

border
