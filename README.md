# Movement-Modulescript

                      											      Now supports attributes!

Easily create and edit your player's movement. You no longer need to keep track of walk speed/jump power calculations. Instead, you can handle it without any confusion with just one script.
Supports type-checking to ensure no confusion.

Example:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ModuleScript = require(ReplicatedStorage.ModuleScript)

game.Players.PlayerAdded:Connect(function(plr)
	local newMovement = ModuleScript.new(plr)
	newMovement:SetSpeed(5)
	newMovement:Update() -- you should check if the player exists before updating, this is an example
end)
```

If you have multiple scripts that will change the player's movement, you don't need to create multiple ```.new``` constructor movements. Instead, it is recommended that you use the ```cache``` system to get the already existing movement (constructor).
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

You can create a constructor for attributes aswell.
```lua
local newModifier = ModuleScript.new(ModuleScript.GenerateFakePlayer(), bp, "myNumber", 5)
newModifier:Update()

newModifier:SetAttributeValue(5)
newModifier:Update()
print(newModifier:GetAttributeValue()) -- 5

```

```bp``` is the instance the attribute is on, and ```myNumber``` is the name of the attribute.
```5``` is the value you want to set on the creation of the constructor, and it can be left out.

If you have another script and you want to get the cache, use the method below on the Modulescript:
```
local newModifier = ModuleScript:GetCache(nil, bp, "myNumber")

task.wait(15)
newModifier:SetAttributeValue(7)
newModifier:Update()
print(newModifier:GetAttributeValue()) -- 7
```

Just like above, you need to specify the instance that the attribute is on and the name of the attribute.

All methods of the constructor:

```lua
newMovement = Movement.new(Player: Player) -- Constructor 

Movement.GenerateFakePlayer(MinLength: number?, MaxLength: number?): PlayerStruct -- Min and max length represent the min and max of random when generating a UserId for the player.

newMovement:SetSpeed(Number: number) -- Sets self.CurrentSpeed to Number. IMPORTANT: This does NOT set the humanoid's walkspeed/jumppower! Use :Update() instead.

newMovement:SetJumpPower(Number: number) -- Sets self.CurrentJumpPower to Number. IMPORTANT: This does NOT set the humanoid's walkspeed/jumppower! Use :Update() instead.

newMovement:GetSpeed(): number -- Returns self.CurrentSpeed

newMovement:GetJumpPower(): number -- Returns self.JumpPower

newMovement:Update() -- Updates the humanoid's walkspeed and jumppower to the self.CurrentSpeed and self.CurrentJumpPower and any attributes.

newMovement:SetAttributeValue(Value: any) -- Sets self.Attribute.Value to Value. IMPORTANT: This does NOT set the attributes value! Use :Update() instead.

newMovement:GetAttributeValue(): any -- Returns self.Attribute.Value

cacheMovement = Movement:GetCache(Player: Player) -- Returns self if exists, else returns nil

cacheAttribute = Movement:GetCache(nil: nil, AttributeInstance: Instance, AttributeName: string) -- Nil helps the method know you aren't trying to get a player's cache.

newMovement:KillSelf() -- Kills self AND any self cache
```

All types:

```lua
export type MovementStruct = {
	Player: Player | PlayerStruct,
	PlayerUserId: number,
	CurrentSpeed: number,
	CurrentJumpPower: number,
	Attribute: AttributeStruct
}

type AttributeStruct = {
	Instance: Instance | nil, 
	Name: string | nil, 
	Value: any | nil
}

type PlayerStruct = {
	UserId: number
}

-- If you want to use these types in your script for type checking, write 'export' before 'type' like MovementStruct does.
-- Example: newMovement = Movement.new(Player): Movement.MovementStruct
```

Please report any suggestions or bugs on the devforum.
https://devforum.roblox.com/t/simple-humanoid-movement-modulescript/2818974/3
