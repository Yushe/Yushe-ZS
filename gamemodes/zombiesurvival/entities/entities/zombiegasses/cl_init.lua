include("shared.lua")

ENT.NextGas = 0
ENT.NextSound = 0

function ENT:Initialize()
	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(48, 64)
	
end

function ENT:OnRemove()
	--self.Emitter:Finish()
end

function ENT:Think()
	if self.NextSound <= CurTime() then
		self.NextSound = CurTime() + math.Rand(4, 6)

		if 0 < GAMEMODE:GetWave() and MySelf:IsValid() and MySelf:Team() == TEAM_HUMAN and MySelf:Alive() and MySelf:EyePos():Distance(self:GetPos()) < self:GetRadius() + 128 then
			surface.PlaySound("ambient/voices/cough"..math.random(1, 4)..".wav")
		end
	end
end

local matGlow = Material("sprites/glow04_noz")
local colGlow = Color(0, 180, 0, 220)
function ENT:Draw()
	--local pos = self:GetPos()
--	local radius = self:GetRadius()
	--render.SetMaterial(matGlow)
	--render.DrawSprite(pos + Vector(0, 0, radius * 0.5), radius + math.Rand(0, 80), radius + math.Rand(0, 80), colGlow)

	self.NextGas = CurTime() + math.Rand(0.08, 0.2)

	local radius = self:GetRadius()

	local randdir = VectorRand()
	randdir.z = math.abs(randdir.z)
	randdir:Normalize()
	local emitpos = self:GetPos() + randdir * math.Rand(0, radius / 2)

	local particle = self.Emitter:Add("particles/smokey", emitpos)
	particle:SetVelocity(randdir * math.Rand(8, 256))
	particle:SetAirResistance(64)
	particle:SetDieTime(math.Rand(1.2, 2.5))
	particle:SetStartAlpha(math.Rand(70, 90))
	particle:SetEndAlpha(0)
	particle:SetStartSize(1)
	particle:SetEndSize(radius * math.Rand(0.25, 0.45))
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(-1, 1))
	particle:SetColor(0, math.Rand(40, 70), 0)
end
