(local color-change (fennel.dofile "animation/colorChange.fnl"))
(local fade (fennel.dofile "animation/fade.fnl"))
(local grow-shrink (fennel.dofile "animation/growShrink.fnl"))
(local border (fennel.dofile "animation/border.fnl"))

(fn create-rectangle [params]
  (let [rect {:alpha (or params.alpha 1)
              :appearing true
              :b (or params.b 1)
              :borderThickness 1
              :colorChange false
              :g (or params.g 1)
              :grow false
              :h params.h
              :appearing true
              :r (or params.r 1)
              :line (or params.line false)
              :scale 1
              :thicken false
              :w params.w
              :x params.x
              :y params.y}]
    rect))

(fn update [rect dt] 
  (fade.update rect dt)
  (when rect.colorChange 
    (color-change.update rect dt))
  (when rect.grow 
    (grow-shrink.update rect dt))
  (when (= rect.grow false)
    (set rect.decreasing true)
    (grow-shrink.update rect dt))
  (when rect.thicken 
    (border.update rect dt)))

(fn draw [rect]
  (love.graphics.setColor rect.r rect.g rect.b rect.alpha)
  (if (= rect.line false)
      (love.graphics.rectangle :fill rect.x rect.y (* rect.w rect.scale) (* rect.h rect.scale))
      (do
        (love.graphics.setLineWidth rect.borderThickness)
        (love.graphics.rectangle :line rect.x rect.y (* rect.w rect.scale) (* rect.h rect.scale))
        (love.graphics.setLineWidth 1))))

{: border
 :colorChange color-change
 :createRectangle create-rectangle
 : draw
 : fade
 :growShrink grow-shrink
 : update}	
