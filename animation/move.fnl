(local move {})

(fn move.init [rect target-x target-y duration]
  (when (not rect.moving)
    (set rect.targetX target-x)
    (set rect.targetY target-y)
    (set rect.startX rect.x)
    (set rect.startY rect.y)
    (set rect.moveDuration duration)
    (set rect.elapsedTime 0)
    (set rect.moving true)
    ))

(fn move.update [rect dt]
  (when rect.moving
    (set rect.elapsedTime (+ rect.elapsedTime dt))
    (if (>= rect.elapsedTime rect.moveDuration)
      (do
        (set rect.x rect.targetX)
        (set rect.y rect.targetY)
        (set rect.moving false))
      (let [t (/ rect.elapsedTime rect.moveDuration)]
        (set rect.x (+ rect.startX (* t (- rect.targetX rect.startX))))
        (set rect.y (+ rect.startY (* t (- rect.targetY rect.startY))))))))

move
