(local animation (fennel.dofile "animation/init.fnl"))

(var selected-rect-index 1)

(local rectangles {})

(fn load []
  (let [rect1 (animation.createRectangle {:b 0
                                          :g 0
                                          :h 200
                                          :r 1
                                          :w 200
                                          :x 100
                                          :y 100})
        rect2 (animation.createRectangle {:b 1
                                          :g 0
                                          :h 200
                                          :r 0
                                          :w 200
                                          :x 410
                                          :y 100
                                          :line true})]
    (animation.colorChange.init rect1)
    (animation.colorChange.init rect2)
    (animation.fade.init rect1)
    (animation.fade.init rect2)
    (animation.growShrink.init rect1)
    (animation.growShrink.init rect2)
    (animation.border.init rect1)
    (animation.border.init rect2)
    (table.insert rectangles rect1)
    (table.insert rectangles rect2)))

(fn update [dt]
  (each [_ rect (ipairs rectangles)] (animation.update rect dt)) 0)	

(fn draw []
  (each [_ rect (ipairs rectangles)] (animation.draw rect))
  (love.graphics.setColor 1 1 1)
  (love.graphics.print (.. "Press 1 or 2 to select a rectangle. Current: "
                           selected-rect-index) 10 10)
  (love.graphics.print "Press C to change color, F to fade, G to grow/shrink, B to thicken borders"
                       10 30))	

(fn keypressed [key]
  (let [rect (. rectangles selected-rect-index)]
  (when (= key "1") (set selected-rect-index 1))
  (when (= key "2") (set selected-rect-index 2))
  (when (= key "c") (set rect.colorChange true))
  (when (= key "f") (set rect.appearing (not rect.appearing)))
  (when (= key "g") (set rect.grow (not rect.grow)))
  (when (= key "b") (set rect.thicken true))))

{
  : load
  : update
  : draw
  : keypressed
}
