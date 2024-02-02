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

If you have multiple scripts that will change the player's movement, you don't need to create multiple ```.new``` movements. Instead, it is recommended that you use the ```Cache``` system to get the already existing movement.
This helps avoid confusion and bugs by only using one movement per player. 

```lua
local cacheMovement = ModuleScript:GetCache(plr) -- returns original movement or nil; recommended you check for nil after calling it
cacheMovement:SetSpeed(16)
cacheMovement:Update()
```

As seen above, you should create a new movement when the player joins.
You can manually destroy or kill the movement with ```self:KillSelf```.

```lua
game.Players.PlayerRemoving:Connect(function(plr)
	local cacheMovement = ModuleScript.Cache(plr)
	cacheMovement:KillSelf()
	print(cacheMovement) -- nil
end)
```

All the methods:

```lua
newMovement = Movement.new(Player: Player) -- Returns self and it's methods

newMovement:SetSpeed(Number: number) -- Sets self.CurrentSpeed to Number. IMPORTANT: This does NOT set the humanoid's walkspeed/jumppower!

newMovement:SetJumpPower(Number: number) -- Sets self.CurrentJumpPower to Number. IMPORTANT: This does NOT set the humanoid's walkspeed/jumppower!

newMovement:GetSpeed(): number -- Returns self.CurrentSpeed

newMovement:GetJumpPower(): number -- Returns self.JumpPower

newMovement:Update() -- Updates the humanoid's walkspeed and jumppower to the self.CurrentSpeed and self.CurrentJumpPower

cacheMovement = Movement:GetCache(Player: Player) -- Returns self if exists, else returns nil

newMovement:KillSelf() -- Kills self AND any self cache
```

Todo:

Queues, other humanoid property methods
