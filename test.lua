-- Soundboard Script
local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local InjectTo = game:GetService("TestService") -- Optional safe parent

local specialChars = "1234567890QWRYUIOPASDFGHJKLZXVBMN+×÷=/_<>,!@#$%^&*?`~\\|{}€£¥₩qwertyuiopasdfghjklzxcvbnm"

local function generateRandomName()
    local length = math.random(5, 10)
    local name = ""
    for i = 1, length do
        local index = math.random(1, #specialChars)
        name = name .. specialChars:sub(index, index)
    end
    return name
end

local function findRemoteEvent(name, parent)
    for _, child in ipairs(parent:GetDescendants()) do
        if child:IsA("RemoteEvent") and child.Name == name then
            return child
        end
    end
    return nil
end

local function getRemoteEvent()
    return findRemoteEvent("AC6_FE_Sounds", replicatedStorage) or findRemoteEvent("AC6_FE_Sounds", workspace)
end

local function playSoundLocal(soundId, looped)
    local sound = Instance.new("Sound")
    sound.Name = generateRandomName()
    sound.SoundId = soundId
    sound.Volume = 1
    sound.Looped = looped
    sound.Parent = InjectTo
    sound:Play()
    if not looped then
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end
end

local NotificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/IceMinisterq/Notification-Library/Main/Library.lua"))()
local remote = getRemoteEvent()

-- Notify attachment
if remote then
    playSoundLocal("rbxassetid://2084290015", false)
    NotificationLibrary:SendNotification("Success", "SUCCESSFULLY ATTACHED TO AC6 🎶 Enjoy playing audio server-side :3", 4)
else
    NotificationLibrary:SendNotification("Warning", "AC6_FE_Sounds RemoteEvent not found. Local play only.", 5)
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ARK_RAGE_GUI"
gui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true

local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 25)
titleBar.BackgroundColor3 = Color3.fromRGB(150, 150, 150)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.Text = "ARK RAGE ON TOP"
titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.TextSize = 18
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local closeButton = Instance.new("TextButton", titleBar)
closeButton.Size = UDim2.new(0, 25, 1, 0)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local minimizeButton = Instance.new("TextButton", titleBar)
minimizeButton.Size = UDim2.new(0, 25, 1, 0)
minimizeButton.Position = UDim2.new(1, -60, 0, 0)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 18
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    mainFrame.Size = minimized and UDim2.new(0, 300, 0, 25) or UDim2.new(0, 300, 0, 200)
end)

local textBox = Instance.new("TextBox", mainFrame)
textBox.Size = UDim2.new(0.8, 0, 0.2, 0)
textBox.Position = UDim2.new(0.1, 0, 0.3, 0)
textBox.PlaceholderText = "[Music ID here]"
textBox.Text = ""
textBox.TextColor3 = Color3.fromRGB(0, 0, 0)
textBox.TextSize = 16
textBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
textBox.BorderSizePixel = 1
textBox.Font = Enum.Font.SourceSans

local looped = false
local loopButton = Instance.new("TextButton", mainFrame)
loopButton.Size = UDim2.new(0.4, 0, 0.2, 0)
loopButton.Position = UDim2.new(0.1, 0, 0.6, 0)
loopButton.Text = "Loop: OFF"
loopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
loopButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
loopButton.Font = Enum.Font.SourceSansBold
loopButton.TextSize = 14
loopButton.MouseButton1Click:Connect(function()
    looped = not looped
    loopButton.Text = looped and "Loop: ON" or "Loop: OFF"
end)

local playButton = Instance.new("TextButton", mainFrame)
playButton.Size = UDim2.new(0.4, 0, 0.2, 0)
playButton.Position = UDim2.new(0.5, 0, 0.6, 0)
playButton.Text = "Play!"
playButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
playButton.Font = Enum.Font.SourceSansBold
playButton.TextSize = 16

playButton.MouseButton1Click:Connect(function()
    local input = textBox.Text
    if input ~= "" and tonumber(input) then
        local assetId = "rbxassetid://" .. input
        if remote then
            -- Server-side play
            remote:FireServer(assetId)
            NotificationLibrary:SendNotification("Server Sound", "Requested sound on server!", 3)
        else
            -- Local fallback
            playSoundLocal(assetId, looped)
            NotificationLibrary:SendNotification("Local Sound", "Sound played locally.", 3)
        end
    else
        NotificationLibrary:SendNotification("Error", "Please enter a valid numeric sound ID.", 3)
    end
end)
