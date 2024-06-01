(module game
  (import :src.player :as player)

  (defn init []
    (player.init))

  (defn update [dt]
    (player.update dt))

  (defn draw []
    (player.draw)))
