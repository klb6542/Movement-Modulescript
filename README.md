# Movement-Modulescript
For ROBLOX.

Easily create and edit your player's movement. You no longer need to keep track of walk speed/jump power calculations. Instead, you can handle it without any confusion with just one script.
Supports type-checking to ensure no confusion.

Example:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ModuleScript = require(ReplicatedStorage.ModuleScript)

game.Players.PlayerAdded:Connect(function(plr)
	local newMovement = ModuleScript.new(plr)
	newMovement:SetSpeed(5)
	newMovement:Update()
end)
```

If have multiple scripts that will change the player's movement, you don't need to create multiple ```.new``` movements. Instead, it is recommended that you use the ```Cache``` system to get the already existing movement.
This helps avoid confusion and bugs by only using one movement per player. As seen above, you should create a new movement when the player joins.
You can manually destroy or kill the movement with ```self:KillSelf```.

```lua
game.Players.PlayerRemoving:Connect(function(plr)
	local cacheMovement = ModuleScript.Cache(plr) -- Can return original movement or nil if none exist
	cacheMovement:KillSelf()
	print(cacheMovement) -- errors because cacheMovement is nil
end)
```
