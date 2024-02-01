--!strict

export type MovementStruct = {
	Player: Player,
	PlayerUserId: number,
	CurrentSpeed: number,
	CurrentJumpPower: number
}

local MOVEMENTMS = {Cache = {} :: MovementStruct} -- Cast Cache type to MovementStruct type
MOVEMENTMS.__index = MOVEMENTMS

function SetCache(self)
	setmetatable(self, MOVEMENTMS)
	
	MOVEMENTMS.Cache[self.PlayerUserId] = self
end

function MOVEMENTMS.new(Player: Player)
	local self: MovementStruct = {
		Player = Player,
		PlayerUserId = Player.UserId,
		CurrentSpeed = 0,
		CurrentJumpPower = 0
	}
	
	setmetatable(self, MOVEMENTMS)
	
	SetCache(self)
	return self
end

function MOVEMENTMS:GetCache(Player: Player): {[any]: any} | nil
	return if MOVEMENTMS.Cache[Player.UserId] then MOVEMENTMS.Cache[Player.UserId] else nil
end

function MOVEMENTMS:Update()
	local Character = self.Player.Character
	local Humanoid = if Character then Character:FindFirstChildOfClass("Humanoid") else nil

	if not Humanoid then warn(`Could not update movement for {self.Player.DisplayName}`) return end

	Humanoid.WalkSpeed = self.CurrentSpeed
	Humanoid.JumpPower = self.CurrentJumpPower
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

function MOVEMENTMS:GetSpeed(): number
	return self.CurrentSpeed
end

function MOVEMENTMS:GetJumpPower(): number
	return self.CurrentJumpPower
end

function MOVEMENTMS:KillSelf() -- Garbage collector
	MOVEMENTMS.Cache[self.Player.UserId] = nil
	setmetatable(self, nil)
	table.clear(self :: any)
end

return MOVEMENTMS
