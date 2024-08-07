(local scenes [
  (fennel.dofile "scenes/game.fnl")
  (fennel.dofile "scenes/audioConfig.fnl")
  (fennel.dofile "scenes/testBeats.fnl")
  (fennel.dofile "scenes/testAnimation.fnl")
  (fennel.dofile "scenes/mainMenu.fnl")
  (fennel.dofile "scenes/selectLevel.fnl")
  (fennel.dofile "scenes/credits.fnl")
])
(local moonshine (require :moonshine))

(var effect nil)

(var currentScene 5) ; set starting scene
;; every scene must have a load, update, draw and keypressed functions
;; the update function must return 0 (no scene change) or a number indicating the
;; index of another scene (scene change)
;; scenes must be in the scene directory(??)
;; also check if audioConfig and testBeats work plz

(fn love.load []
  ;(set effect (moonshine.chain moonshine.effects.dmg))
  (set effect (moonshine.chain moonshine.effects.scanlines))
  (set effect (effect.chain moonshine.effects.crt))
  (set effect (effect.chain moonshine.effects.glow))
  ;(set effect.dmg.palette [[0 0 0] [100 125 125] [125 125 255] [255 255 255]])
  (set effect.crt.distortionFactor [1.06 1.065])
  (set effect.crt.feather 0.05)
  (set effect.glow.strength 10)
  (tset _G :globalFont (love.graphics.newFont :assets/Coolville.otf 36))
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
  (love.graphics.setFont (. _G :globalFont))
  (effect (. (. scenes currentScene) :draw))
)

(fn love.keypressed [key]
  ((. (. scenes currentScene) :keypressed) key)
)
