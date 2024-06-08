(local animation (fennel.dofile "animation/init.fnl"))

(var rect1 nil)

(fn load [] 
  (set rect1 {:h 100 :w 100 :x 100 :y 100})
  (animation.colorChange.init rect1 1 0 0)
  )

(fn update [dt] 
  (animation.colorChange.update dt))

(fn draw [] (animation.colorChange.draw))

{
  : load
  : update
  : draw
}
