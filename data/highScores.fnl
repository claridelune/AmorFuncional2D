(local fileName "highScores.txt")
(local fileHeader "BeatMapHighScores:1")
(local missingFileError 2)

(var scores {})

(var canSave false)
(var loadError nil)

(fn getScore [song]
  (or (. scores song) 0)
)

(fn submitScore [song score]
  (if (> score (getScore song))
    (do
      (tset scores song score)
      true
    )
    false
  )
)

(fn getFilePath []
  (let [sourcePath (love.filesystem.getSource)
        packaged (or (love.filesystem.isFused)
                     (string.match sourcePath "%.love$"))
        gameFolder (if packaged
                     (love.filesystem.getSourceBaseDirectory)
                     sourcePath)]
    (.. gameFolder "/data/" fileName)
  )
)

(fn parseScores [contents]
  (let [normalized (string.gsub contents "\r\n" "\n")
        (header body) (string.match normalized "^([^\n]*)\n?(.*)$")
        loadedScores {}]

    (var valid (= header fileHeader))

    (each [line (string.gmatch body "[^\n]+")]
      (let [(song scoreText) (string.match line "^([^\t\r]+)\t([^\t\r]+)$")
            score (and scoreText (tonumber scoreText))]

        (if (and song
                 score
                 (>= score 0)
                 (< score math.huge)
                 (= score (math.floor score))
                 (= (. loadedScores song) nil))
          (tset loadedScores song score)
          (set valid false)
        )
      )
    )

    (if valid loadedScores nil)
  )
)

(fn failLoad [message]
  (set loadError (or message "Could not load high scores"))
  (values false loadError)
)

(fn openSaveFile []
  (let [path (getFilePath)
        (file openError errorCode) (io.open path "rb")]

    (if (and (not file) (= errorCode missingFileError))
      (io.open (.. path ".bak") "rb")
      (values file openError errorCode)
    )
  )
)

(fn load []
  (set canSave false)
  (set loadError nil)

  (let [(file openError errorCode) (openSaveFile)]
    (if
      file
      (let [(contents readError) (file:read "*a")
            (closed closeError) (file:close)]

        (if
          (not contents) (failLoad readError)
          (not closed) (failLoad closeError)

          (let [loadedScores (parseScores contents)]
            (if loadedScores
              (do
                (set scores loadedScores)
                (set canSave true)
                true
              )
              (failLoad "Invalid high score file")
            )
          )
        )
      )

      (= errorCode missingFileError)
      (do
        (set scores {})
        (set canSave true)
        true
      )

      (failLoad openError)
    )
  )
)

(fn writeFile [path contents]
  (let [(file openError) (io.open path "wb")]
    (if file
      (let [(written writeError) (file:write contents)
            (closed closeError) (file:close)]

        (if
          (not written) (values false writeError)
          (not closed) (values false closeError)
          true
        )
      )
      (values false openError)
    )
  )
)

(fn prepareBackup [path backupPath]
  (let [(file openError errorCode) (io.open path "rb")]
    (if
      file
      (let [(closed closeError) (file:close)]
        (if (not closed)
          (values false closeError)

          (let [(removed removeError removeCode) (os.remove backupPath)]
            (if (and (not removed)
                     (not= removeCode missingFileError))
              (values false removeError)

              (let [(renamed renameError) (os.rename path backupPath)]
                (if renamed
                  (values true nil true)
                  (values false renameError)
                )
              )
            )
          )
        )
      )

      (= errorCode missingFileError)
      (values true nil false)

      (values false openError)
    )
  )
)

(fn installSave [path temporaryPath backupPath hadBackup]
  (let [(installed installError) (os.rename temporaryPath path)]
    (if
      installed
      true

      hadBackup
      (let [(restored restoreError) (os.rename backupPath path)]
        (if restored
          (values false installError)

          (do
            (set canSave false)
            (set loadError
              (.. "Could not restore the previous save: "
                  (tostring restoreError)))
            (values false loadError)
          )
        )
      )

      (values false installError)
    )
  )
)

(fn writeScores []
  (let [path (getFilePath)
        temporaryPath (.. path ".tmp")
        backupPath (.. path ".bak")
        lines [fileHeader]]

    (each [song score (pairs scores)]
      (table.insert lines (.. song "\t" (tostring score)))
    )

    (let [(written writeError)
          (writeFile temporaryPath (table.concat lines "\n"))]

      (if written
        (let [(prepared backupError hadBackup)
              (prepareBackup path backupPath)]

          (if prepared
            (installSave path temporaryPath backupPath hadBackup)
            (values false backupError)
          )
        )
        (values false writeError)
      )
    )
  )
)

(fn save []
  (if canSave
    (writeScores)
    (values false
            (or loadError "High scores have not been loaded"))
  )
)

{
  :getScore getScore
  :submitScore submitScore
  :load load
  :save save
}