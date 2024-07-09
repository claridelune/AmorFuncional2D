(local color-change (fennel.dofile "animation/colorChange.fnl"))
(local fade (fennel.dofile "animation/fade.fnl"))
(local grow-shrink (fennel.dofile "animation/growShrink.fnl"))
(local border (fennel.dofile "animation/border.fnl"))
(local move (fennel.dofile "animation/move.fnl"))

(fn create-rectangle [params]
  (let [rect {:alpha (or params.alpha 1)
              :appearing (or params.appearing true)
              :b (or params.b 1)
              :borderThickness (or params.borderThickness 1)
              :colorChange (or params.colorChange false)
              :colorTransitionSpeed (or params.colorTransitionSpeed 0.5)
              :g (or params.g 1)
              :grow (or params.grow false)
              :growShrinkTransitionSpeed (or params.growShrinkTransitionSpeed 0.5)
              :h (or params.h 100)
              :r (or params.r 1)
              :line (or params.line false)
              :scale (or params.scale 1)
              :thicken (or params.thicken false)
              :w (or params.w 100)
              :x (or params.x 0)
              :y (or params.y 0)
              :moving false}]
    rect))

(fn init-all [rect]
  (color-change.init rect)
  (grow-shrink.init rect)
  (border.init rect)
  (fade.init rect)
)

(fn update [rect dt]
  (fade.update rect dt)
  (move.update rect dt)
  (when rect.colorChange
    (color-change.update rect dt))
  (when rect.grow
    (grow-shrink.update rect dt))
  (when rect.thicken
    (border.update rect dt)))

(fn draw [rect]
  (love.graphics.setColor rect.r rect.g rect.b rect.alpha)
  (if (not rect.line)
      (love.graphics.rectangle :fill rect.x rect.y (* rect.w rect.scale) (* rect.h rect.scale))
      (do
        (love.graphics.setLineWidth rect.borderThickness)
        (love.graphics.rectangle :line rect.x rect.y (* rect.w rect.scale) (* rect.h rect.scale))
        (love.graphics.setLineWidth 1))))

(fn setColor [rect r g b]
  (set rect.r r)
  (set rect.g g)
  (set rect.b b))

{:border border
 :colorChange color-change
 :createRectangle create-rectangle
 :draw draw
 :fade fade
 :growShrink grow-shrink
 :move move
 :update update
 :setColor setColor
 :initAll init-all}
