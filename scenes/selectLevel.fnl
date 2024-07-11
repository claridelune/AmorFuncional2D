(var changeScene 0)

(var titleFont nil)


(fn load []
  (set changeScene 0)
  (love.graphics.setLineWidth 4)
  (set titleFont (love.graphics.newFont :assets/Coolville.otf 70))
)

(fn update [dt]
  changeScene
)

(fn draw []
    (let [
        xx (love.mouse.getX)
        yy (love.mouse.getY)
        gen (and (<= 300 yy) (<= yy 400))
    ]
        (for [index 1 (. _G :totalLevels)]
            (let [ini (+ 325 (* (- index 1) 100)) pos (and gen (and (< ini xx) (<= xx (+ ini 100))))]
                (if pos (love.graphics.setColor 0 0 1) (love.graphics.setColor 0.5 0.5 0.5))
                (love.graphics.rectangle "line" ini 300 100 100)
                (love.graphics.print index (+ 365 (* (- index 1) 100)) 335)
                (when pos
                    (love.graphics.setColor 1 1 0)
                    (love.graphics.rectangle "line" (- ini 8) 292 100 100)
                    (love.graphics.print index (+ 357 (* (- index 1) 100)) 327)
                )
                (when (and pos (love.mouse.isDown 1))
                    (tset _G :currSong index)
                    (set changeScene 1)
                )
            )
        )
    )

    (love.graphics.setColor 1 1 0)
    (love.graphics.setFont titleFont)
    (love.graphics.print "SELECT LEVEL" 250 150)
)

(fn keypressed [key]
)

{
  : load
  : update
  : draw
  : keypressed
}
