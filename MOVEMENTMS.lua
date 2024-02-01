local MOVEMENTMS = {}
MOVEMENTMS.__index = MOVEMENTMS

function MOVEMENTMS.new(Player: Player)
	return setmetatable({
		Player = Player,
		CurrentSpeed = 0,
		CurrentJumpPower = 0
	}, MOVEMENTMS)
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
end
 
function MOVEMENTMS:GetSpeed(): number
	return self.CurrentSpeed
end

function MOVEMENTMS:SetJumpPower(NewJumpPower: number)
	self.CurrentJumpPower = NewJumpPower
end

function MOVEMENTMS:GetJumpPower(): number
	return self.CurrentJumpPower
end

return MOVEMENTMS
