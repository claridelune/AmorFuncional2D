(module player
  (defn init []
    ;; Initialize player state
    (set _G.player {:x 100 :y 100 :speed 200}))

  (defn update [dt]
    (let [{:keys [x y speed]} _G.player] ; Desestructurar el mapa
      (when (love.keyboard.isDown "up")
        (set _G.player :y (- y (* speed dt))))
      (when (love.keyboard.isDown "down")
        (set _G.player :y (+ y (* speed dt))))
      (when (love.keyboard.isDown "left")
        (set _G.player :x (- x (* speed dt))))
      (when (love.keyboard.isDown "right")
        (set _G.player :x (+ x (* speed dt))))))

  (defn draw []
    ;; Draw player
    (let [{:keys [x y]} _G.player] ; Desestructurar el mapa
      (love.graphics.rectangle "fill" x y 50 50))))
