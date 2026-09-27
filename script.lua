loadstring(game:HttpGet("https://githubusercontent.com"))()
local X = loadstring(game:HttpGet("https://githubusercontent.com"))().Load({Title = "Steal An Egg: APEX GOD MATRIX", Style = 3, SizeX = 420, SizeY = 480, Theme = "Dark", UpdateTitle = true})
local FarmTab = X.New({ Title = "⚡ Farming Modes" })
local FilterTab = X.New({ Title = "🔍 Rare Scanner" })
local SafetyTab = X.New({ Title = "🛡️ Anti-Ban Security" })
local HatchTab = X.New({ Title = "🥚 Egg Hatching" })
getgenv().FarmType = "None"
getgenv().HatchActive = false
getgenv().SelectedEgg = "BasicEgg"
getgenv().AutoRebirth = false
getgenv().ModDetection = true
getgenv().RareScannerActive = false
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TargetRarities = {"secret", "cherub", "solaris", "blackhole", "volcanic", "legendary", "epic"}
local function walkToTarget(targetPart)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildWhichIsA("Humanoid")
    if not hrp or not hum then return end
    hum.WalkSpeed = 32
    local distance = (hrp.Position - targetPart.Position).Magnitude
    local duration = distance / hum.WalkSpeed
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetPart.CFrame})
    tween:Play()
    tween.Completed:Wait()
end
local function hopToNextServer()
    pcall(function()
        local servers = HttpService:JSONDecode(game:HttpGet("https://roblox.com" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=50"))
        local randomServer = servers.data[math.random(1, #servers.data)]
        if randomServer and randomServer.playing < randomServer.maxPlayers and randomServer.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer.id, LocalPlayer)
        else
            for _, server in pairs(servers.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                    break
                end
            end
        end
    end)
end
FarmTab.Dropdown({
    Text = "Select Collection Engine",
    Callback = function(Value) getgenv().FarmType = Value end,
    Options = {"None", "Instant Teleport", "Silent Collect", "Humanized Tween"}
})
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().FarmType ~= "None" then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj:IsA("Model") and (string.find(obj.Name:lower(), "egg") or obj:FindFirstChild("Egg")) then
                        local part = obj:FindFirstChildWhichIsA("BasePart") or obj.PrimaryPart
                        if part and part.Transparency < 1 then
                            if getgenv().FarmType == "Instant Teleport" then
                                hrp.CFrame = part.CFrame
                                task.wait(0.02)
                                firetouchinterest(hrp, part, 0)
                                firetouchinterest(hrp, part, 1)
                            elseif getgenv().FarmType == "Silent Collect" then
                                firetouchinterest(hrp, part, 0)
                                task.wait(0.05)
                                firetouchinterest(hrp, part, 1)
                                task.wait(0.4)
                            elseif getgenv().FarmType == "Humanized Tween" then
                                walkToTarget(part)
                                firetouchinterest(hrp, part, 0)
                                firetouchinterest(hrp, part, 1)
                                task.wait(math.random(3, 6) / 10)
                            end
                        end
                    end
                end
            end)
        end
    end
end)
FilterTab.Toggle({
    Text = "Auto-Hop Till Rare Egg Found",
    Callback = function(Value) getgenv().RareScannerActive = Value end,
    Enabled = false
})
task.spawn(function()
    while task.wait(2) do
        if getgenv().RareScannerActive then
            local foundTarget = false
            pcall(function()
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj:IsA("Model") and (string.find(obj.Name:lower(), "egg") or obj:FindFirstChild("Egg")) then
                        local objName = obj.Name:lower()
                        for _, rarity in pairs(TargetRarities) do
                            if string.find(objName, rarity) then
                                foundTarget = true
                                break
                            end
                        end
                    end
                end
            end)
            if not foundTarget then hopToNextServer() end
        end
    end
end)
SafetyTab.Toggle({
    Text = "Enable Admin Auto-Panic Switch",
    Callback = function(Value) getgenv().ModDetection = Value end,
    Enabled = true
})
task.spawn(function()
    while task.wait(1) do
        if getgenv().ModDetection then
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player:GetRankInGroup(1200769) > 0 or string.find(player.Name:lower(), "mod") or string.find(player.Name:lower(), "admin") then
                        hopToNextServer()
                    end
                end
            end)
        end
    end
end)
SafetyTab.Toggle({
    Text = "Background Auto Rebirth Loop",
    Callback = function(Value) getgenv().AutoRebirth = Value end,
    Enabled = false
})
task.spawn(function()
    while task.wait(2) do
        if getgenv().AutoRebirth then
            pcall(function()
                local remotes = ReplicatedStorage:WaitForChild("Remotes")
                if remotes:FindFirstChild("Rebirth") then
                    remotes.Rebirth:FireServer()
                elseif remotes:FindFirstChild("Prestige") then
                    remotes.Prestige:InvokeServer()
                end
            end)
        end
    end
end)
HatchTab.Dropdown({
    Text = "Target Buying Pool",
    Callback = function(Value) getgenv().SelectedEgg = Value end,
    Options = {"BasicEgg", "RareEgg", "EpicEgg", "LegendaryEgg"}
})
HatchTab.Toggle({
    Text = "Inject No-Animation Purchase Loop",
    Callback = function(Value) getgenv().HatchActive = Value end,
    Enabled = false
})
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().HatchActive then
            pcall(function()
                ReplicatedStorage.Remotes.HatchEgg:InvokeServer(getgenv().SelectedEgg, "Single")
            end)
        end
    end
end)
