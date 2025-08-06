-- Server code: hook ping
local RS = game:GetService("ReplicatedStorage")
local PingEvent = Instance.new("RemoteEvent")
PingEvent.Name = "PingEvent"
PingEvent.Parent = RS
PingEvent.OnServerEvent:Connect(function(p, t)
	local ping = math.floor((tick() - t) * 1000)
	PingEvent:FireClient(p, ping)
end)

-- Client / hack code
if game:GetService("RunService"):IsClient() then
	local Players = game:GetService("Players")
	local PingEvent = RS:WaitForChild("PingEvent")

	local function showPing(player)
		player.CharacterAdded:Wait()
		local head = player.Character:WaitForChild("Head")
		local gui = Instance.new("BillboardGui", head)
		gui.Size = UDim2.new(0,100,0,40)
		gui.StudsOffset = Vector3.new(0,2,0)
		gui.AlwaysOnTop = true
		local label = Instance.new("TextLabel", gui)
		label.Size = UDim2.new(1,1,1,1)
		label.BackgroundTransparency = 1
		label.TextScaled = true
		label.Font = Enum.Font.SourceSansBold
		label.Text = "Ping: ..."
		label.Parent = gui
	end

	for _, pl in pairs(game.Players:GetPlayers()) do
		if pl ~= game.Players.LocalPlayer then showPing(pl) end
	end
	game.Players.PlayerAdded:Connect(showPing)

	spawn(function()
		while true do
			local t0 = tick()
			PingEvent:FireServer(t0)
			PingEvent.OnClientEvent:Once(function(val)
				local pl = game.Players.LocalPlayer
				if pl.Character and pl.Character:FindFirstChild("Head") then
					local gui = pl.Character.Head:FindFirstChild("BillboardGui")
					if gui and gui:FindFirstChild("TextLabel") then
						gui.TextLabel.Text = "Ping: "..val.." ms"
					end
				end
			end)
			wait(2)
		end
	end)
end
