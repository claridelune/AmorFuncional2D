(local highScores (. _G :highScores))
(local songData (fennel.dofile "audio/songData.fnl"))

(local firstLevelX 325)
(local levelY 300)
(local levelSize 100)
(local selectionOffset 8)

(local mainMenuX 250)
(local mainMenuY 500)
(local mainMenuWidth 325)
(local mainMenuHeight 36)

(var changeScene 0)

(var titleFont nil)

(var previewFont nil)
(var selectedSong nil)
(var lastMouseX nil)
(var lastMouseY nil)

(fn getLevelX [index]
  (+ firstLevelX (* (- index 1) levelSize))
)

(fn getHoveredSong [xx yy]
  (var hoveredSong nil)

  (when (and (<= levelY yy)
             (<= yy (+ levelY levelSize)))
    (for [index 1 (. _G :totalLevels)]
      (let [ini (getLevelX index)]
        (when (and (< ini xx)
                   (<= xx (+ ini levelSize)))
          (set hoveredSong index)
        )
      )
    )
  )

  hoveredSong
)

(fn isMainMenuHovered [xx yy]
  (and (<= mainMenuX xx)
       (<= xx (+ mainMenuX mainMenuWidth))
       (<= mainMenuY yy)
       (<= yy (+ mainMenuY mainMenuHeight)))
)

(fn startSong [song]
  (when song
    (set selectedSong song)
    (tset _G :currSong song)
    (set changeScene 1)
  )
)

(fn load []
  (set changeScene 0)
  (love.graphics.setLineWidth 4)
  (set titleFont (love.graphics.newFont :assets/Coolville.otf 70))
  (set previewFont (love.graphics.newFont :assets/Coolville.otf 24))

  (set lastMouseX (love.mouse.getX))
  (set lastMouseY (love.mouse.getY))
  (set selectedSong (getHoveredSong lastMouseX lastMouseY))
)

(fn update [dt]
  (let [xx (love.mouse.getX)
        yy (love.mouse.getY)
        mouseMoved (or (not= xx lastMouseX)
                       (not= yy lastMouseY))]

    (when mouseMoved
      (let [hoveredSong (getHoveredSong xx yy)]
        (when hoveredSong
          (set selectedSong hoveredSong)
        )
      )

      (set lastMouseX xx)
      (set lastMouseY yy)
    )
  )

  changeScene
)

(fn drawPreview []
  (let [panelWidth 340
        panelX (- (love.graphics.getWidth) panelWidth 40)
        panelY 30
        textX (+ panelX 12)
        textWidth (- panelWidth 24)]

    (love.graphics.setFont previewFont)
    (love.graphics.setColor 1 1 0 1)
    (love.graphics.rectangle "line" panelX panelY panelWidth 150)

    (if selectedSong
      (let [songName (songData.getSongName selectedSong)
            songKey (songData.getSongTitle selectedSong)
            strBest (.. "Best: " (tostring (highScores.getScore songKey)))]

        (love.graphics.setColor 1 1 1 1)
        (love.graphics.printf songName textX (+ panelY 20) textWidth "right")

        (love.graphics.setColor 1 1 0 1)
        (love.graphics.printf strBest textX (+ panelY 90) textWidth "right")
      )

      (do
        (love.graphics.setColor 0.5 0.5 0.5 1)
        (love.graphics.printf "Choose a song"
                              textX (+ panelY 55) textWidth "right")
      )
    )

    (love.graphics.setFont (. _G :globalFont))
    (love.graphics.setColor 1 1 1 1)
  )
)

(fn draw []
  (let [xx (love.mouse.getX)
        yy (love.mouse.getY)]

    (for [index 1 (. _G :totalLevels)]
      (let [ini (getLevelX index)
            pos (= index selectedSong)
            textX (+ ini 40)
            textY (+ levelY 35)]

        (if pos
          (love.graphics.setColor 0 0 1)
          (love.graphics.setColor 0.5 0.5 0.5)
        )

        (love.graphics.rectangle "line" ini levelY levelSize levelSize)
        (love.graphics.print index textX textY)

        (when pos
          (love.graphics.setColor 1 1 0)
          (love.graphics.rectangle "line"
                                   (- ini selectionOffset)
                                   (- levelY selectionOffset)
                                   levelSize levelSize)
          (love.graphics.print index
                               (- textX selectionOffset)
                               (- textY selectionOffset))
        )
      )
    )

    (if (isMainMenuHovered xx yy)
      (love.graphics.setColor 1 1 1)
      (love.graphics.setColor 0.5 0.5 0.5)
    )

    (love.graphics.print "Return to main menu" mainMenuX mainMenuY)
  )

  (love.graphics.setColor 1 1 0)
  (love.graphics.setFont titleFont)
  (love.graphics.print "SELECT LEVEL" 250 150)

  (drawPreview)
)

(fn keypressed [key]
  (when (= key "tab")
    (let [totalLevels (. _G :totalLevels)
          backwards (love.keyboard.isDown "lshift" "rshift")
          direction (if backwards -1 1)]

      (when (> totalLevels 0)
        (if selectedSong
          (set selectedSong
            (+ 1 (% (+ (- selectedSong 1) direction) totalLevels)))
          (set selectedSong (if backwards totalLevels 1))
        )

        (set lastMouseX (love.mouse.getX))
        (set lastMouseY (love.mouse.getY))
      )
    )
  )

    (when (or (= key "return") (= key "kpenter"))
    (startSong selectedSong)
    )
)

(fn mousepressed [xx yy button]
  (when (= button 1)
    (if (isMainMenuHovered xx yy)
      (set changeScene 5)
      (startSong (getHoveredSong xx yy))
    )
  )
)

{
  : load
  : update
  : draw
  : keypressed
  : mousepressed
}
