type MovementStruct = {
	Player: Player,
	PlayerUserId: number,
	CurrentSpeed: number,
	CurrentJumpPower: number
}

local MOVEMENTMS = {Cache = {} :: MovementStruct} -- Cast Cache type to MovementStruct type
MOVEMENTMS.__index = MOVEMENTMS

function AddCache(self: MovementStruct)
	MOVEMENTMS.Cache[self.Player.UserId] = self
end

function MOVEMENTMS.new(Player: Player)
	local self: MovementStruct = {
		Player = Player,
		PlayerUserId = Player.UserId,
		CurrentSpeed = 0,
		CurrentJumpPower = 0
	}

	AddCache(self)
	return setmetatable(self, MOVEMENTMS)
end 

function MOVEMENTMS:GetCache(Player: Player?): {[Player]: MovementStruct} | MovementStruct | {}
	return if self.Cache[Player] then self.Cache[Player.UserId] else self.Cache
end

function MOVEMENTMS:Update()
	local Character = self.Player.Character
	local Humanoid = if Character then Character:FindFirstChildOfClass("Humanoid") else nil

	if not Humanoid then warn(`Could not update movement for {self.Player.DisplayName}`) return end

	Humanoid.WalkSpeed = self.CurrentSpeed
	Humanoid.JumpPower = self.CurrentJumpPower
end

function MOVEMENTMS:SetSpeed(NewSpeed: number)
	self.CurrentSpeed = NewSpeed
	AddCache(self)
end

function MOVEMENTMS:SetJumpPower(NewJumpPower: number)
	self.CurrentJumpPower = NewJumpPower
	AddCache(self)
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
