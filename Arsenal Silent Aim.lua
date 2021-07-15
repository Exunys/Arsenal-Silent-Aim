--// Services

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Shortcuts

local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--// Variables

local OldNameCall = nil

--// Settings

getgenv().SilentAimEnabled = true

--// Functions

local function GetClosestPlayer()
	local MaximumDistance = math.huge
	local Target

	local Thread = coroutine.wrap(function()
		wait(20)
		MaximumDistance = math.huge
	end)

	Thread()

	for _, v in next, Players:GetPlayers() do
		if v.Name ~= LocalPlayer.Name then
			if v.TeamColor ~= LocalPlayer.TeamColor then
				if workspace:FindFirstChild(v.Name) ~= nil then
					if workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then
						if workspace[v.Name]:FindFirstChild("Humanoid") ~= nil and workspace[v.Name]:FindFirstChild("Humanoid").Health ~= 0 then
							local ScreenPoint = Camera:WorldToScreenPoint(workspace[v.Name]:WaitForChild("HumanoidRootPart", math.huge).Position)
							local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
							
							if VectorDistance < MaximumDistance then
								Target = v
								MaximumDistance = VectorDistance
							end
						end
					end
				end
			end
		end
	end

	return Target
end

--// Silent Aim

OldNameCall = hookmetamethod(game, "__namecall", function(Self, ...)
	local NameCallMethod = getnamecallmethod()
	local Arguments = {...}

	if not checkcaller() and tostring(Self) == "HitPart" and tostring(NameCallMethod) == "FireServer" then
		if getgenv().SilentAimEnabled == true then
			Arguments[1] = GetClosestPlayer().Character.Hitbox
		end

		return Self.FireServer(Self, unpack(Arguments))
	elseif not checkcaller() and tostring(Self) == "Trail" and tostring(NameCallMethod) == "FireServer" then
		if getgenv().SilentAimEnabled == true then
			if type(Arguments[1][5]) == "string" then
				Arguments[1][6] = GetClosestPlayer().Character.Hitbox
				Arguments[1][2] = GetClosestPlayer().Character.Hitbox.Position
			end
		end

		return Self.FireServer(Self, unpack(Arguments))
	elseif not checkcaller() and tostring(Self) == "CreateProjectile" and tostring(NameCallMethod) == "FireServer" then	
		if getgenv().SilentAimEnabled == true then
			Arguments[18] = GetClosestPlayer().Character.Hitbox
			Arguments[19] = GetClosestPlayer().Character.Hitbox.Position
			Arguments[17] = GetClosestPlayer().Character.Hitbox.Position
			Arguments[4] = GetClosestPlayer().Character.Hitbox.CFrame
			Arguments[10] = GetClosestPlayer().Character.Hitbox.Position
			Arguments[3] = GetClosestPlayer().Character.Hitbox.Position
		end

		return Self.FireServer(Self, unpack(Arguments))
	elseif not checkcaller() and tostring(Self) == "Flames" and tostring(NameCallMethod) == "FireServer" then -- DOESNT WORK
		if getgenv().SilentAimEnabled == true then
			Arguments[1] = GetClosestPlayer().Character.Hitbox.CFrame
			Arguments[2] = GetClosestPlayer().Character.Hitbox.Position
			Arguments[5] = GetClosestPlayer().Character.Hitbox.Position
		end

		return Self.FireServer(Self, unpack(Arguments))
	elseif not checkcaller() and tostring(Self) == "Fire" and tostring(NameCallMethod) == "FireServer" then
		if getgenv().SilentAimEnabled == true then
			Arguments[1] = GetClosestPlayer().Character.Hitbox.Position
		end

		return Self.FireServer(Self, unpack(Arguments))
	elseif not checkcaller() and tostring(Self) == "ReplicateProjectile" and tostring(NameCallMethod) == "FireServer" then
		if getgenv().SilentAimEnabled == true then
			Arguments[1][3] = GetClosestPlayer().Character.Hitbox.Position
			Arguments[1][4] = GetClosestPlayer().Character.Hitbox.Position
			Arguments[1][10] = GetClosestPlayer().Character.Hitbox.Position
		end

		return Self.FireServer(Self, unpack(Arguments))
	elseif not checkcaller() and tostring(Self) == "RemoteEvent" and tostring(NameCallMethod) == "FireServer" then
		if getgenv().SilentAimEnabled == true then
			if Arguments[1][1] == "createparticle" and Arguments[1][2] == "muzzle" then
				if Arguments[3] == LocalPlayer.Character.Gun then
					if ReplicatedStorage.Weapons(LocalPlayer.Character.Gun.Boop.Value).Melee then
						local KnifeArguments1 = {
							[1] = "createparticle",
							[2] = "bullethole",
							[3] = GetClosestPlayer().Character.Hitbox,
							[4] = GetClosestPlayer().Character.Hitbox.Position,
							[5] = Vector3.new(0, 0, 0),
							[6] = ReplicatedStorage.Weapons:FindFirstChild(LocalPlayer.Character.Gun.Boop.Value),
							[7] = false,
							[8] = GetClosestPlayer().Character.Hitbox.Position,
							[9] = true,
							[12] = LocalPlayer,
							[13] = 1
						}
						
						local KnifeArguments = {
							GetClosestPlayer().Character.Hitbox,
							GetClosestPlayer().Character.Hitbox.Position,
							ReplicatedStorage.Weapons:FindFirstChild(LocalPlayer.Character.EquippedTool.Value).Name,
							1,
							5,
							false,
							false,
							false,
							1,
							false,
							ReplicatedStorage.Weapons:FindFirstChild(LocalPlayer.Character.EquippedTool.Value).FireRate.Value,
							ReplicatedStorage.Weapons:FindFirstChild(LocalPlayer.Character.EquippedTool.Value).ReloadTime.Value,
							ReplicatedStorage.Weapons:FindFirstChild(LocalPlayer.Character.EquippedTool.Value).Ammo.Value,
							ReplicatedStorage.Weapons:FindFirstChild(LocalPlayer.Character.EquippedTool.Value).StoredAmmo.Value,
							ReplicatedStorage.Weapons:FindFirstChild(LocalPlayer.Character.EquippedTool.Value).Bullets.Value,
							ReplicatedStorage.Weapons:FindFirstChild(LocalPlayer.Character.EquippedTool.Value).EquipTime.Value,
							ReplicatedStorage.Weapons:FindFirstChild(LocalPlayer.Character.EquippedTool.Value).RecoilControl.Value,
							ReplicatedStorage.Weapons:FindFirstChild(LocalPlayer.Character.EquippedTool.Value).Auto.Value,
							ReplicatedStorage.Weapons:FindFirstChild(LocalPlayer.Character.EquippedTool.Value)["Speed%"].Value,
							ReplicatedStorage:WaitForChild("wkspc").DistributedTime.Value,
							215,
							1,
							false,
							true
						}

						ReplicatedStorage.Events.RemoteEvent:FireServer(KnifeArguments1)
						ReplicatedStorage.Events.HitPart:FireServer(unpack(KnifeArguments))
					end
				end
			end
		end

		return Self.FireServer(Self, unpack(Arguments))
	end

	return OldNameCall(Self, ...)
end)
