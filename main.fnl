(local scenes [
  (fennel.dofile "game.fnl")
  (fennel.dofile "scenes/audioConfig.fnl")
  (fennel.dofile "scenes/testBeats.fnl")
  (fennel.dofile "testAnimation.fnl")
])

(var currentScene 1) ; set starting scene
;; every scene must have a load, update, draw and keypressed functions
;; the update function must return 0 (no scene change) or a number indicating the
;; index of another scene (scene change)
;; scenes must be in the scene directory(??)
;; also check if audioConfig and testBeats work plz

(fn love.load []
  ((. (. scenes currentScene) :load))
)

(fn love.update [dt]
  (let [newScene ((. (. scenes currentScene) :update) dt)]
    (when (not (= newScene 0))
      (set currentScene newScene)
      ((. (. scenes currentScene) :load))
    )
  )
)

(fn love.draw []
  ((. (. scenes currentScene) :draw))
)

(fn love.keypressed [key]
  ((. (. scenes currentScene) :keypressed) key)
)
