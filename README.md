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

It is recommended that you use the ```Cache``` system to get 
