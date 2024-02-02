--!strict

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

local MOVEMENTMS = {Cache = {} :: MovementStruct, Ids = {} :: PlayerStruct} -- Cast table types to custom types
MOVEMENTMS.__index = MOVEMENTMS


function SetCache(self)
	setmetatable(self, MOVEMENTMS)

	MOVEMENTMS.Cache[self.PlayerUserId] = self
end

function GenerateID(MinLength: number?, MaxLength: number?): number
	return Random.new(os.time()):NextInteger(MinLength or 100 * 10^9, MaxLength or 100 * 10^12)
end

function MOVEMENTMS.new(Player: Player | PlayerStruct, AttributeInstance: Instance?, AttributeName: string?, AttributeValue: any?)
	if MOVEMENTMS.Cache[Player.UserId] then error(`Another constructor with the same UserId already exists`) return end
	
	local self: MovementStruct = {
		Player = Player,
		PlayerUserId = Player.UserId,
		CurrentSpeed = 0,
		CurrentJumpPower = 0,
		Attribute = {
			Instance = AttributeInstance,
			Name = AttributeName,
			Value = AttributeValue
		}
	}

	setmetatable(self, MOVEMENTMS)

	SetCache(self)
	return self
end

function MOVEMENTMS.GenerateFakePlayer(MinLength: number?, MaxLength: number?): PlayerStruct
	local UserId = GenerateID(MinLength, MaxLength)

	MOVEMENTMS.Ids[UserId] = UserId
	return {UserId = GenerateID(MinLength, MaxLength)}
end

function MOVEMENTMS:GetCache(Player: Player | nil, AttributeInstance: Instance?, AttributeName: string?): {[any]: any} | nil
	local AttributeAttendence = AttributeInstance and AttributeName
	if not Player and not AttributeAttendence then error(`All arguments are nil`) return end
	
	if AttributeAttendence then
		local Cache: {[any]: any} = nil
		
		for i,v in pairs(MOVEMENTMS.Cache) do
			if v.Attribute.Instance ~= AttributeInstance or v.Attribute.Name ~=  AttributeName then continue end
			
			Cache = v
			break
		end
		
		return Cache
	end
	
	return if MOVEMENTMS.Cache[Player.UserId] then MOVEMENTMS.Cache[Player.UserId] else nil
end

function MOVEMENTMS:Update()
	if self.Attribute.Instance then
		self.Attribute.Instance:SetAttribute(self.Attribute.Name, self.Attribute.Value)
	end
	
	if typeof(self.Player) ~= "Player" then SetCache(self) return end
	
	local Character = self.Player.Character
	local Humanoid = if Character then Character:FindFirstChildOfClass("Humanoid") else nil

		if not Humanoid then warn(`Could not update movement for {self.Player.DisplayName}; Has the character loaded yet? - {script:GetFullName()}`) return end

	Humanoid.WalkSpeed = self.CurrentSpeed
	Humanoid.JumpPower = self.CurrentJumpPower
	SetCache(self)
end

function MOVEMENTMS:SetAttributeValue(Value: any)
	self.Attribute.Value = Value
	SetCache(self)
end

function MOVEMENTMS:SetSpeed(NewSpeed: number)
	self.CurrentSpeed = NewSpeed
	SetCache(self)
end

function MOVEMENTMS:SetJumpPower(NewJumpPower: number)
	self.CurrentJumpPower = NewJumpPower
	SetCache(self)
end

function MOVEMENTMS:GetAttributeValue(): any
	return self.Attribute.Value
end

function MOVEMENTMS:GetSpeed(): number
	return self.CurrentSpeed
end

function MOVEMENTMS:GetJumpPower(): number
	return self.CurrentJumpPower
end

function MOVEMENTMS:KillSelf() -- Garbage collector
	if MOVEMENTMS.Ids[self.Player.UserId] then MOVEMENTMS.Ids[self.Player.UserId] = nil end
	MOVEMENTMS.Cache[self.Player.UserId] = nil
	
	setmetatable(self, nil)
	table.clear(self :: any)

	self = nil
end

return MOVEMENTMS
