--!strict

type MovementStruct = {
	Player: Player,
	CurrentSpeed: number,
	CurrentJumpPower: number
}

local MOVEMENTMS = {}
MOVEMENTMS.__index = MOVEMENTMS

MOVEMENTMS.Cache = {} :: MovementStruct -- Cast type to MovementStruct

function AddCache(self: MovementStruct)
	MOVEMENTMS.Cache[self.Player] = self
end

function MOVEMENTMS.new(Player: Player)
	local self: MovementStruct = {
		Player = Player,
		CurrentSpeed = 0,
		CurrentJumpPower = 0
	}

	AddCache(self)
	return setmetatable(self, MOVEMENTMS)
end

function MOVEMENTMS:GetCache(): MovementStruct | nil
	return MOVEMENTMS.Cache[self.Player]
end

function MOVEMENTMS:Update()
	local Character = self.Player.Character
	local Humanoid = Character or nil

	if not Humanoid then warn(`Could not update speed for {self.Player.DisplayName}`) return end

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

function MOVEMENTMS:KillSelf(Player: Player?) -- Garbage collector
	self.Player = self.Player or Player

	MOVEMENTMS.Cache[self.Player] = nil
	setmetatable(self, nil)
	table.clear(self :: any)
end

return MOVEMENTMS
