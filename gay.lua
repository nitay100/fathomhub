local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local mouse = Players.LocalPlayer:GetMouse()
local nevermore_modules = rawget(require(game.ReplicatedStorage.Framework.Nevermore), "_lookupTable")
local network = rawget(nevermore_modules, "Network") -- network is the place where the remote handling shit is
local remotes_table = getupvalue(getsenv(network).GetEventHandler, 1)
local events_table = getupvalue(getsenv(network).GetFunctionHandler, 1)
local remotes = {}
local lines = {}
local texts = {}
local walkspeed = 16
local infjump
local antidamage
local autospawn
local tracersenabled
local nofall
local textenabled
local noclip
local stompaura
local jumppower = 50
getgenv().TracerColor = Color3.fromRGB(99, 13, 197)

-- the good ol anticheat bypass
for i,v in pairs(getgc(true)) do
    if typeof(v) == "table" and rawget(v, "punish") then
        hookfunction(v.punish, function(...)
            return
        end)
    end
end

table.foreach(remotes_table, function(i,v)
    if rawget(v, "Remote") then
        remotes[rawget(v, "Remote")] = i
    end
end)

table.foreach(events_table, function(i,v)
    if rawget(v, "Remote") then
        remotes[rawget(v, "Remote")] = i
    end
end)


-- the retards at combat warriors detect if you make changes to the names so this is the second best method
local pog
pog = hookmetamethod(game, "__index", function(self, key)
    if (key == "Name" or key == "name") and remotes[self] then
       return remotes[self]
    end

    return pog(self, key)
end)

-- this shit took me one hour to make
-- i think im gonna kms after this
-- hated every second :sob:
-- https://skid.menu/​‌​​​​‌​​‌​‌​‌‌‌​​‌‌‌​​‌​​‌‌‌​​‌​​‌‌​‌‌​​‌‌​‌​​​​‌‌​​‌‌‌​‌‌​‌‌​‌

for i,v in pairs(getconnections(game.Players.LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"))) do
    v:Disable()
end

for i,v in pairs(game.Players:GetPlayers()) do
    if v ~= Players.LocalPlayer then
        if v.Character then
            local line = Drawing.new("Line")
            line.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
            line.Color = TracerColor
            line.Thickness = 2
            lines[v] = line
    
            local text = Drawing.new("Text")
            text.Text = v.Name
            text.Size = 20
            text.Outline = true
            text.OutlineColor = Color3.new(0,0,0)        
            text.Center = true
            texts[v] = text
        end
        v.CharacterAdded:Connect(function()
            local line = Drawing.new("Line")
            line.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
            line.Color = TracerColor
            line.Thickness = 2
            lines[v] = line
    
            local text = Drawing.new("Text")
            text.Text = v.Name
            text.Size = 20
            text.Outline = true
            text.OutlineColor = Color3.new(0,0,0)        
            text.Center = true
            texts[v] = text

            spinny = Instance.new("BodyForce")
        end)
        v.CharacterRemoving:Connect(function()
            lines[v]:Remove()
            lines[v] = nil
            texts[v]:Remove()
            texts[v] = nil
        end)
    end
end

game.Players.PlayerAdded:Connect(function(v)
    v.CharacterAdded:Connect(function()
        local line = Drawing.new("Line")
        line.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
        line.Color = TracerColor
        line.Thickness = 2
        lines[v] = line

        local text = Drawing.new("Text")
        text.Text = v.Name
        text.Size = 20
        text.Outline = true
        text.OutlineColor = Color3.new(0,0,0)
        text.Center = true
        texts[v] = text
    end)

    v.CharacterRemoving:Connect(function()
        lines[v]:Remove()
        lines[v] = nil
        texts[v]:Remove()
        texts[v] = nil
    end)
end)

local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()
local window = Material.Load({
    Title = "goofy ahh script",
    Style = 3,
    SizeX = 400,
    SizeY = 300,
    Theme = "Dark"
})

local main = window.New({
    Title = "main"
})

local player = window.New({
    Title = "player"
})

local visuals = window.New({
    Title = "visuals"
})

main.Button({
    Text = "disable jump cooldown",
    Callback = function()
        for i,v in pairs(getgc(true)) do
            if typeof(v) == "table" and rawget(v, "getCanJump") then
                hookfunction(v.getCanJump, function(...)
                    return true
                end)
            end
        end
    end
})

main.Button({
    Text = "infinite stamina",
    Callback = function()
        for i,v in pairs(getgc(true)) do
            if typeof(v) == "table" and rawget(v, "_setStamina") then
                 hookfunction(v._setStamina, function(...)
                     _stamina = 9e9
                 end)
            end
         end
    end
})

main.Toggle({
    Text = "no fall damage",
    Callback = function(v)
        nofall = v

        if v then
            for i,v in pairs(getgc(true)) do
                if typeof(v) == "table" and rawget(v, "onCharacterTookFallDamage") then
                    hookfunction(getupvalue(v._startModule, 2), function(...)
                        return
                    end)
                end
            end
        end
    end
})

main.Toggle({
    Text = "stomp aura",
    Callback = function(v)
        stompaura = v
    end
})

main.Toggle({
    Text = "anti fire + bear trap damage",
    Callback = function(v)
        antidamage = v
    end,
    Enabled = false
})

main.Toggle({
    Text = "auto spawn",
    Callback = function(v)
        autospawn = v
    end,
    Enabled = false
})

player.Slider({
    Text = "walkspeed",
    Callback = function(v)
        walkspeed = v
    end,
    Min = 16,
    Max = 75,
    Def = 16
})

player.Slider({
    Text = "jumppower",
    Callback = function(v)
        jumppower = v
    end,
    Min = 50,
    Max = 200,
    Def = 50
})

player.Toggle({
    Text = "inf jump",
    Callback = function(v)
        infjump = v
    end,
    Enabled = false
})

player.Toggle({
    Text = "noclip",
    Callback = function(v)
        noclip = v
    end,
    Enabled = false
})




visuals.ColorPicker({
    Text = "visuals color",
    Default = Color3.fromRGB(99, 13, 197),
    Callback = function(v)
        getgenv().TracerColor = v
    end
})

visuals.Toggle({
    Text = "tracers",
    Callback = function(v)
        tracersenabled = v
    end,
    Enabled = false
})

visuals.Toggle({
    Text = "text",
    Callback = function(v)
        textenabled = v
    end,
    Enabled = false
})


mouse.KeyDown:Connect(function(v)
    if infjump and v == " " then
        Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState(3)
    end
end)

-- checks if the player loaded into the game
Players.LocalPlayer.PlayerGui.RoactUI.ChildRemoved:Connect(function(v)
    if v.Name == "MainMenu" then
        for i,v in pairs(getconnections(game.Players.LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"))) do
            v:Disable()
        end
        if nofall then
            for i,v in pairs(getgc(true)) do
                if typeof(v) == "table" and rawget(v, "onCharacterTookFallDamage") then
                    hookfunction(getupvalue(v._startModule, 2), function(...)
                        return
                    end)
                end
            end
        end
    end
end)

-- the main loop for shit
RunService.Stepped:Connect(function()
    Players.LocalPlayer.Character.Humanoid.WalkSpeed = walkspeed
    Players.LocalPlayer.Character.Humanoid.JumpPower = jumppower

    if autospawn and Players.LocalPlayer.PlayerGui.RoactUI:FindFirstChild("MainMenu") then
        keypress(0x20)
        keyrelease(0x20)
    end

    -- really fuckin basic stomp aura but it works :shrug:
    if stompaura then
        for i,v in pairs(Players:GetPlayers()) do
            if v ~= Players.LocalPlayer and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health <= 15 then
                if (v.Character.HumanoidRootPart.Position - Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 4 then
                    keypress(0x51)
                    keyrelease(0x51)
                end
            end
        end
    end

    if noclip then
        for i,v in pairs(Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
    
    if tracersenabled then
        for player,line in pairs(lines) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local pos,visible = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                line.Color = TracerColor
                line.To = Vector2.new(pos.X, pos.Y)
                -- line.Color = player.Character.Torso.Color
                line.Visible = visible
            else
                line.Visible = false
            end
        end
    end

    if textenabled then
        for player,text in pairs(texts) do
            if player.Character and player.Character:FindFirstChild("Head") then
                local head, HeadVisible = workspace.CurrentCamera:WorldToViewportPoint(player.Character.Head.Position)
                text.Position = Vector2.new(head.X, head.Y - 28)
                text.Color = TracerColor
                text.Visible = HeadVisible
            else
                text.Visible = false
            end
        end
    end
end)

local methodHook
methodHook = hookmetamethod(game, "__namecall", function(self, ...)
    if antidamage and tostring(self) == "GotHitRE" and getnamecallmethod() == "FireServer" then
        return
    end
    return methodHook(self, ...)
end)