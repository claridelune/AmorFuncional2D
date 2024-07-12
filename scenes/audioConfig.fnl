(local audio (fennel.dofile "audio/audio.fnl"))

(var keep false)
(var diffs [])
(var changeScene 0)

(fn load []
  (audio.init 1 [] 188 0 true)
  (love.graphics.setLineWidth 4)
  (set changeScene 0)
  (set keep false)
)

(fn updateOffsetInput []
    (let [oldLength (length diffs)]
      (when (not= oldLength 0)
        (tset _G :offsetInput 0)
        (while (> (length diffs) 0)
            (tset _G :offsetInput (+ (. _G :offsetInput) (table.remove diffs)))
        )
        (tset _G :offsetInput (/ (. _G :offsetInput) oldLength))
      )
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
  (love.graphics.print "Press p to play" 100 300)
  (love.graphics.print "Press m to return to main menu" 100 350)
  (love.graphics.print "Press r to reset offset" 100 400)
  (love.graphics.print "Current Offset:" 100 500)
  (love.graphics.print (. _G :offsetInput) 400 500)
  ;(audio.drawDebug)
  (each [index value (ipairs diffs)]
    (love.graphics.print value 700 (+ 200 (* index 25)))
  )
)

(fn keypressed [key]
  (if (or (or (= key "s") (= key "p")) (= key "m"))
    (do 
        (set keep (not keep))
        (if keep
            (audio.changeBeats 2 [1])
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
    (tset _G :currSong 1)
    (set changeScene 1)
  )
  (when (= key "m")
    (set changeScene 5)
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
