(local audio (fennel.dofile "audio/audio.fnl"))

(var keep false)
(var diffs [])
(var changeScene 0)

(fn load []
  (audio.init 1 [] 200 0)
  (love.graphics.setLineWidth 4)
  (set changeScene 0)
  (set keep false)
)

(fn updateOffsetInput []
    (let [oldLength (+ (length diffs) 1)]
        (while (> (length diffs) 0)
            (tset _G :offsetInput (+ (. _G :offsetInput) (table.remove diffs)))
        )
        (tset _G :offsetInput (/ (. _G :offsetInput) oldLength))
    )
)

(fn update [dt]
  (audio.update dt)
  (when (>= (length diffs) 8)
    (updateOffsetInput)
  )
  changeScene
)

(fn draw []
  (love.graphics.setColor 1 1 0)
  (love.graphics.print (.. "Press s to " (if keep :stop :start) " config") 100 250)
  (love.graphics.print "Press p to play" 300 250)
  (love.graphics.print "Press r to reset offset" 500 250)
  (love.graphics.print "Current Offset:" 100 300)
  (love.graphics.print (. _G :offsetInput) 200 300)
  (audio.drawDebug)
  (each [index value (ipairs diffs)]
    (love.graphics.print value 700 (+ 200 (* index 25)))
  )
)

(fn keypressed [key]
  (if (or (= key "s") (= key "p"))
    (do 
        (set keep (not keep))
        (if keep
            (audio.changeBeats 4 [1 3])
            (do (updateOffsetInput) (audio.changeBeats 1 []))
        )
    )
    (when keep
        (let [diff (audio.getBeatDiff)]
            (table.insert diffs diff)
        )
    )
  )
  (when (= key "p")
    (set changeScene 3)
  )
  (when (= key "r")
    (updateOffsetInput)
    (tset _G :offsetInput 0)
  )
)

{
  : load
  : update
  : draw
  : keypressed
}
