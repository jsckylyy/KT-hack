--@KTHack Submission Controller
local controller = {}

--@Services 
local Services = setmetatable({}, {
	__index = function(self, Service)
		return game:GetService(Service)
	end,
})
--//ServiceDiplomacies 
local TweenService, Tweens = Services.TweenService, Services.TweenService 
local UserInputService = Services.UserInputService 

--@Global Timeouts 
local timeout = ((8 * math.sin(.8)) - .7) 

--//@Legacy Abbreviations 
local camera = workspace.CurrentCamera

--//@Global Dependencies
local remote = script.Remote

--//@Local Functions 
local function zoomCam(amount : number , duration : number) 
	local tween = Tweens:Create(
		camera,
		(TweenInfo.new)(duration), 
		{FieldOfView = amount}
	)
	tween:Play() 
	task.delay(duration - -(math.cos(10)), tween.Destroy, tween) 
end

local function TweenBase(instance : any, durationid : number, prop : string, value : any)
	local tween = Tweens:Create(
		instance, 
		TweenInfo.new(durationid), 
		{[prop] = value}
	)
	tween:Play() 
	task.delay(durationid + .5, tween.Destroy, tween)
end

local function getMouseHit()
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
	local mouseLocation = UserInputService:GetMouseLocation()

	local viewportPointRay = camera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)
	local RayResult = workspace:Raycast(viewportPointRay.Origin, viewportPointRay.Direction * 1000, raycastParams)
	if RayResult then
		return RayResult.Instance 
	end
end

local function getMousePos()	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}

	local mouseLocation = UserInputService:GetMouseLocation()
	local viewportPointRay = camera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)
	local RayResult = workspace:Raycast(viewportPointRay.Origin, viewportPointRay.Direction * 1000, raycastParams)
	if RayResult then
		return RayResult.Position
	end
	--//Shift/Viewport Ray @: return nil, (viewportPointRay.Origin + viewportPointRay.Direction * 1000)
end

--[[
local CameraShaker = require(game:GetService('ReplicatedStorage'):WaitForChild("CameraShaker"));
local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
	camera.CFrame = camera.CFrame * shakeCf
end)
camShake:Start()
--camShake:Shake(CameraShaker.Presets[Arg])
]]

--//@Client Module Identifiers  

function controller.SetupQueries() 
	--/Character Dependencies 
	local player = game.Players.LocalPlayer 
	local character = player.Character or player.CharacterAdded:Wait() 

	--/Local Dependencies 

	--[[ Interfacing ]] -- 
	local Gui = player.PlayerGui:WaitForChild("InputQuestionsGui", timeout)

	local Frame = Gui.MainFrame 
	local Input = Frame.Input 
	local Submit = Frame.Submit 
	local Finish = Frame.Finish 
	local Questions = Frame.Questions 

	-- [[ Titles ]] -- 
	local Title = Frame.Title 
	local TitleTwo = Frame.TitleTwo 

	-- [[ Answers ]] --
	local Answers = Frame.Answers 
	local AnswerOne = Answers.AnswerOne
	local AnswerTwo = Answers.AnswerTwo
	local AnswerThree = Answers.AnswerThree
	local AnswerFour = Answers.AnswerFour


	for _,v in(Frame:GetDescendants()) do 
		if v:IsA("TextButton") or v:IsA("TextLabel") then 
			v:SetAttribute("BackgroundTransparency", v.BackgroundTransparency)
			-- 
			v.TextTransparency = 1 
			v.BackgroundTransparency = 1 
		elseif v:IsA("TextBox") then 
			v:SetAttribute("BackgroundTransparency", v.BackgroundTransparency)
			-- 
			v.TextTransparency = 1 
		end
	end
	remote.OnClientEvent:Connect(function(Action)
		if Action == "EnableHostGui" then 

			game.Players.LocalPlayer.PlayerGui.HostPanel.Enabled = true 

			Gui.Enabled = true 
			for _,v in(Frame:GetDescendants()) do 
				if v:IsA("TextButton") or v:IsA("TextLabel") then 
					TweenBase(v, 1, "TextTransparency", 0)

					if v:GetAttribute("BackgroundTransparency") then 
						TweenBase(v, 1, "BackgroundTransparency", v:GetAttribute("BackgroundTransparency"))
					else 
						TweenBase(v, 1, "BackgroundTransparency", 0)
					end
					--
				elseif v:IsA("TextBox") then 
					TweenBase(v, 1, "TextTransparency", 0)

					if v:GetAttribute("BackgroundTransparency") then 
						TweenBase(v, 1, "BackgroundTransparency", v:GetAttribute("BackgroundTransparency"))
					else 
						TweenBase(v, 1, "BackgroundTransparency", 0)
					end
				end
			end
		end
	end)
end


function controller:AddQuery() 
	--/Character Dependencies 
	local player = game.Players.LocalPlayer 
	local character = player.Character or player.CharacterAdded:Wait() 

	--/Local Dependencies 

	--[[ Interfacing ]] -- 
	local Gui = player.PlayerGui:WaitForChild("InputQuestionsGui", timeout)
	local Frame = Gui.MainFrame 
	local Input = Frame.Input 
	local Submit = Frame.Submit 
	local Finish = Frame.Finish 
	local Questions = Frame.Questions 

	-- [[ Titles ]] -- 
	local Title = Frame.Title 
	local TitleTwo = Frame.TitleTwo 

	-- [[ Answers ]] --
	local Answers = Frame.Answers 
	local AnswerOne = Answers.AnswerOne
	local AnswerTwo = Answers.AnswerTwo
	local AnswerThree = Answers.AnswerThree
	local AnswerFour = Answers.AnswerFour

	local debounce = false 

	local function CheckAnswers() 
		local blank = true 

		--[[ Check Blanks ]]--
		if AnswerOne.Text == "" then 
			blank = false 
		end
		if AnswerTwo.Text == "" then 
			blank = false 
		end
		if AnswerThree.Text == "" then 
			blank = false 
		end
		if AnswerFour.Text == "" then 
			blank = false 
		end
		return blank 
	end 

	if not debounce then
		debounce = true 

		if Input.Text == "" then 
			TitleTwo.Text = "Make sure your question isn't blank."
			TitleTwo.TextColor3 = Color3.fromRGB(255, 111, 111)

			task.delay(1, function() 
				TitleTwo.TextColor3 = Color3.fromRGB(255, 255, 255)
				TitleTwo.Text = "Enter your answers to the question, make the first one correct." 
			end)
		else 
			local pass = CheckAnswers()
			if not pass then 
				TitleTwo.Text = "Make sure your answers are not blank."
				TitleTwo.TextColor3 = Color3.fromRGB(255, 111, 111)
				task.delay(1, function() 
					TitleTwo.TextColor3 = Color3.fromRGB(255, 255, 255)
					TitleTwo.Text = "Enter your answers to the question, make the first one correct." 
				end)
			else 
				--/Assume that all of them are not blank 

				remote:FireServer("CreateQuestion", Input.Text, AnswerOne.Text, AnswerTwo.Text, AnswerThree.Text, AnswerFour.Text)

				repeat TitleTwo.Text = "Question pending..." task.wait(.5) until game.ReplicatedStorage.MainController.Questions:FindFirstChild(Input.Text)

				TitleTwo.Text = "Question successfully created!"
				TitleTwo.TextColor3 = Color3.fromRGB(134, 255, 134)

				TweenBase(AnswerOne, 1, "TextTransparency", 1)
				TweenBase(AnswerTwo, 1, "TextTransparency", 1)
				TweenBase(AnswerThree, 1, "TextTransparency", 1)
				TweenBase(AnswerFour, 1, "TextTransparency", 1)
				TweenBase(Input, 1, "TextTransparency", 1)

				if #game.ReplicatedStorage.MainController.Questions:GetChildren() == 1 then 
					Questions.Text = #game.ReplicatedStorage.MainController.Questions:GetChildren() .. " question made."
				else 
					Questions.Text = #game.ReplicatedStorage.MainController.Questions:GetChildren() .. " questions made."
				end
				task.delay(1, function() 

					AnswerOne.Text = ""
					AnswerTwo.Text = ""
					AnswerThree.Text = ""
					AnswerFour.Text = ""
					Input.Text = ""
					-- [[ Restart ]] --
					TweenBase(Input, 1, "TextTransparency", 0)

					TweenBase(AnswerOne, 1, "TextTransparency", 0)
					TweenBase(AnswerTwo, 1, "TextTransparency", 0)
					TweenBase(AnswerThree, 1, "TextTransparency", 0)
					TweenBase(AnswerFour, 1, "TextTransparency", 0)

					TweenBase(TitleTwo, 1, "TextTransparency", 1)
					task.delay(1, function() 
						TweenBase(TitleTwo, 1, "TextTransparency", 0)
						TitleTwo.TextColor3 = Color3.fromRGB(255, 255, 255)
						TitleTwo.Text = "Enter your answers to the question, make the first one correct." 
					end)
				end) 

			end
		end
	end

end

function controller:CloseQueries() 
	--[[ Interfacing ]] -- 
	local Gui = game.Players.LocalPlayer.PlayerGui:WaitForChild("InputQuestionsGui", timeout)
	local Frame = Gui.MainFrame 
	local Input = Frame.Input 
	local Submit = Frame.Submit 
	local Finish = Frame.Finish 
	local Questions = Frame.Questions 

	-- [[ Titles ]] -- 
	local Title = Frame.Title 
	local TitleTwo = Frame.TitleTwo 

	-- [[ Answers ]] --
	local Answers = Frame.Answers 
	local AnswerOne = Answers.AnswerOne
	local AnswerTwo = Answers.AnswerTwo
	local AnswerThree = Answers.AnswerThree
	local AnswerFour = Answers.AnswerFour


	for _,v in(Frame:GetDescendants()) do 
		if v:IsA("TextButton") or v:IsA("TextLabel") then 
			TweenBase(v, 1, "TextTransparency", 1)
			TweenBase(v, 1, "BackgroundTransparency", 1)

		elseif v:IsA("TextBox") then 
			TweenBase(v, 1, "TextTransparency", 1)
			TweenBase(v, 1, "BackgroundTransparency", 1)
		end
	end

	TweenBase(Frame, 1, "BackgroundTransparency", 1)
	task.delay(.8, function() Gui.Enabled = false; end)
	remote:FireServer("StartGame")
end

function controller:CloseGui() 
	--[[ Interfacing ]] -- 
	local Gui = game.Players.LocalPlayer.PlayerGui:WaitForChild("InputQuestionsGui", timeout)
	local Frame = Gui.MainFrame 
	local Input = Frame.Input 
	local Submit = Frame.Submit 
	local Finish = Frame.Finish 
	local Questions = Frame.Questions 

	-- [[ Titles ]] -- 
	local Title = Frame.Title 
	local TitleTwo = Frame.TitleTwo 

	-- [[ Answers ]] --
	local Answers = Frame.Answers 
	local AnswerOne = Answers.AnswerOne
	local AnswerTwo = Answers.AnswerTwo
	local AnswerThree = Answers.AnswerThree
	local AnswerFour = Answers.AnswerFour


	for _,v in(Frame:GetDescendants()) do 
		if v:IsA("TextButton") or v:IsA("TextLabel") then 
			TweenBase(v, 1, "TextTransparency", 1)
			TweenBase(v, 1, "BackgroundTransparency", 1)

		elseif v:IsA("TextBox") then 
			TweenBase(v, 1, "TextTransparency", 1)
			TweenBase(v, 1, "BackgroundTransparency", 1)
		end
	end

	TweenBase(Frame, 1, "BackgroundTransparency", 1)
	task.delay(.8, function() Gui.Enabled = false; end)
end


function controller.OnQuery() 
	--[[ Framework ]]--
	local QueryGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("QuestionAsk")
	local Frame = QueryGui.MainFrame
	local One = Frame.Answers.One
	local Two = Frame.Answers.Two
	local Three = Frame.Answers.Three 
	local Four = Frame.Answers.Four
	local Submit = Frame.Submit
	local Title = Frame.Title
	local Question = Frame.Question
	local Countdown = Frame.Countdown
	local Selected = Frame.Selected

	for _,v in(QueryGui:GetDescendants()) do 
		if v:IsA("TextLabel") or v:IsA("TextButton") then 
			v.TextTransparency = 1 
			v:SetAttribute("BackgroundTransparency", v.BackgroundTransparency)
			--
			v.BackgroundTransparency = 1 
		end
	end
	Frame.BackgroundTransparency = 1 


	remote.OnClientEvent:Connect(function(action, question, computer)
		if action == "QueryPlayer" then

			for _,v in(QueryGui:GetDescendants()) do 
				if v:IsA("TextLabel") or v:IsA("TextButton") then 
					v.TextTransparency = 1 
					v.BackgroundTransparency = 1 
				end
			end
			Frame.BackgroundTransparency = 1 

			for _,v in(QueryGui:GetDescendants()) do 
				if v:IsA("TextLabel") or v:IsA("TextButton") then 
					v.Position = v:GetAttribute("NormalPosition")
					v.Text = v:GetAttribute("NormalText")
					v.TextColor3 = v:GetAttribute("NormalTextColor")
				end
			end

			QueryGui.Enabled = true 

			TweenBase(Frame, 1, "BackgroundTransparency", .3)
			task.wait(.5)

			TweenBase(Title, 1, "TextTransparency", 0)
			TweenBase(Title, 1, "BackgroundTransparency", Title:GetAttribute("BackgroundTransparency"))
			Question.Text = question 
			Question.Position = Question:GetAttribute("StartPosition")
			TweenBase(Question, 1, "TextTransparency", 0)
			TweenBase(Question, 1, "BackgroundTransparency", Question:GetAttribute("BackgroundTransparency"))
			task.wait(2)
			Question:TweenPosition(Question:GetAttribute("EndPosition"), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 1)
			task.wait(.5)
			Countdown.Text = "4"
			TweenBase(Countdown, .5, "BackgroundTransparency", 0)
			TweenBase(Countdown, .7, "TextTransparency", 0)
			task.wait(1)
			Countdown.Text = "3"
			task.wait(1)
			Countdown.Text = "2"
			task.wait(1)
			Countdown.Text = "1"
			task.wait(1)
			TweenBase(Countdown, .5, "BackgroundTransparency", 1)
			TweenBase(Countdown, .7, "TextTransparency", 1)

			--[[Setting the Answers Up]]--
			for i,v in(game.ReplicatedStorage.MainController.Questions[question]:GetChildren()) do 
				if not v:GetAttribute("Assigned") then 
					v:SetAttribute("Assigned", i)
				end
			end

			task.wait(.5)

			for i,v in(game.ReplicatedStorage.MainController.Questions[question]:GetChildren()) do 
				if v:GetAttribute("Assigned") then 
					if v:GetAttribute("Assigned") == 1 then 
						One.Text = v.Name 
					elseif v:GetAttribute("Assigned") == 2 then 
						Two.Text = v.Name 
					elseif v:GetAttribute("Assigned") == 3 then 
						Three.Text = v.Name
					elseif v:GetAttribute("Assigned") == 4 then 
						Four.Text = v.Name
					end
				end
			end

			task.wait(.7)
			TweenBase(One, 1, "TextTransparency", 0)
			TweenBase(One, 1, "BackgroundTransparency", One:GetAttribute("BackgroundTransparency"))

			TweenBase(Two, 1, "TextTransparency", 0)
			TweenBase(Two, 1, "BackgroundTransparency", Two:GetAttribute("BackgroundTransparency"))

			TweenBase(Three, 1, "TextTransparency", 0)
			TweenBase(Three, 1, "BackgroundTransparency", Three:GetAttribute("BackgroundTransparency"))

			TweenBase(Four, 1, "TextTransparency", 0)
			TweenBase(Four, 1, "BackgroundTransparency", Four:GetAttribute("BackgroundTransparency"))

			local Selects = false 
			local CanSelect = true 

			Countdown.Value.Value = 15 
			-- 
			Countdown.Text = Countdown.Value.Value
			Countdown.Position = Countdown:GetAttribute("MainTimerPosition")

			coroutine.wrap(function() 
				repeat 
					Countdown.Value.Value -= 1 
					Countdown.Text = Countdown.Value.Value 
					task.wait(1)					
				until Countdown.Value.Value < 1 
				CanSelect = false 
				Selects = false 
				Title.Text = "Times up!" 
				TweenBase(Title, 1, "TextColor3", Color3.fromRGB(218, 95, 95))

				for _,newv in(Frame.Answers:GetChildren()) do
					TweenBase(newv, 1, "TextTransparency", 1)
					TweenBase(newv, 1, "BackgroundTransparency", 1)
				end
				TweenBase(Submit, 1, "TextTransparency", 1)
				TweenBase(Submit, 1, "BackgroundTransparency", 1)
				--task.delay(1, function() Submit.Visible = false end)

				TweenBase(Countdown, .5, "BackgroundTransparency", 1)
				TweenBase(Countdown, .7, "TextTransparency", 1)

				TweenBase(Question, 1, "TextColor3", Color3.fromRGB(73, 218, 206))


				Question:TweenPosition(Question:GetAttribute("StartPosition"), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 1.5)
				task.wait(1)	
				local answer  
				for _,v in(game.ReplicatedStorage.MainController.Questions[question]:GetChildren()) do 
					if v.Value then 
						answer = v.Name 
					end
				end

				--[[
				task.wait(1)
				Question.Text = "The correct answer is: " .. answer 
				TweenBase(Question, 1, "TextColor3", Color3.fromRGB(75, 218, 87))
]]
				task.wait(2)
				if Selected.Value == answer then 
					Question.Text = "You got this correct!" 
					TweenBase(Question, 1, "TextColor3", Color3.fromRGB(106, 218, 80))

					if computer then 
						remote:FireServer("RespondToComputer", computer)
					end

				else 
					Question.Text = "You got this incorrect." 
					TweenBase(Question, 1, "TextColor3", Color3.fromRGB(218, 32, 32))

					if computer then 
						task.wait(3)
						remote:FireServer("QueryPlayer", game.Players.LocalPlayer)
					end

				end
				task.wait(1)
				TweenBase(Title, 1, "TextTransparency", 1)
				TweenBase(Title, 1, "BackgroundTransparency", 1)
				task.wait(1)
				TweenBase(Question, 1, "TextTransparency", 1)
				TweenBase(Question, 1, "BackgroundTransparency", 1)
				--
				TweenBase(Frame, 1, "BackgroundTransparency", 1)



			end)()


			TweenBase(Countdown, .5, "BackgroundTransparency", 0)
			TweenBase(Countdown, .7, "TextTransparency", 0)

			for _,v in(Frame.Answers:GetChildren()) do 
				v.Activated:Connect(function() 
					if CanSelect then 
						for _,v in(Frame.Answers:GetChildren()) do 
							TweenBase(v, 1, "TextColor3", Color3.fromRGB(255, 56, 56))
						end
						TweenBase(v, 1, "TextColor3", Color3.fromRGB(144, 255, 148))
						TweenBase(Submit, 1, "TextTransparency", 0)
						TweenBase(Submit, 1, "BackgroundTransparency", Submit:GetAttribute("BackgroundTransparency"))
						Selected.Value = v.Text 
						Selects = true 
					end
				end)
			end

			Submit.Activated:Connect(function()
				if Selects then 
					CanSelect = false 
					Selects = false 

					TweenBase(Submit, 1, "TextTransparency", 1)
					TweenBase(Submit, 1, "BackgroundTransparency", 1)

					Title.Text = "Answer Locked in: " 
					TweenBase(Title, 1, "TextColor3", Color3.fromRGB(181, 218, 177))

					for _,newv in(Frame.Answers:GetChildren()) do
						if newv.Text ~= Selected.Value then 
							TweenBase(newv, 1, "TextTransparency", 1)
							task.delay(1.4, function() 
								TweenBase(newv, 1, "BackgroundTransparency", 1)
							end) 

						end 
					end

					-- 
					for _,v in(Frame.Answers:GetChildren()) do 
						v:TweenPosition(Frame.Answers:GetAttribute("EndPositions"), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 1.5)
					end

				end
			end)

		end
	end)
end

function controller.ClientListener()
	remote.OnClientEvent:Connect(function(Action, Header, Description)
		if Action == "SendNotification" then 
			game:GetService("StarterGui"):SetCore("SendNotification",{
				Title = Header, 
				Text = Description, 
				--Icon = "rbxassetid://1234567890"
			})
		end
		if Action == "Countdown" then 
			local Duration = Header
			local Countdown = game.Players.LocalPlayer.PlayerGui.GameFrame.MainFrame.Countdown

			Countdown.Text = Duration 

			game.Players.LocalPlayer.PlayerGui.GameFrame.MainFrame.Visible = true 
			Countdown.Visible = true 

			coroutine.wrap(function() 
				repeat 
					Countdown.Value.Value -= 1 
					Countdown.Text = Countdown.Value.Value 
					task.wait(1)					
				until Countdown.Value.Value < 1 
				Countdown.Text = " "
			end)()
		end
		if Action == "ShowPlayerFrames" then 
			game.Players.LocalPlayer.PlayerGui.GameFrame.MainFrame.PlayerFrame.Visible = true 

			for _,v in(workspace.Players:GetChildren()) do
				local template = game.ReplicatedStorage.PlayerName:Clone()
				template.Visible = true 
				template.Text = v.Name 
				template.Parent = game.Players.LocalPlayer.PlayerGui.GameFrame.MainFrame.PlayerFrame
				if v:GetAttribute("Killer") then 
					template.BackgroundColor3 = Color3.fromRGB(121, 30, 30)
				end
			end
		end

		if Action == "GameCountdown" then 
			local Duration = Header
			local Countdown = game.Players.LocalPlayer.PlayerGui.GameFrame.MainFrame.Countdown

			Countdown.Text = Duration 

			game.Players.LocalPlayer.PlayerGui.GameFrame.MainFrame.Visible = true 
			Countdown.Visible = true 

			Countdown.Value.Value = Duration 

			coroutine.wrap(function() 
				repeat 
					Countdown.Value.Value -= 1 
					Countdown.Text = "Time Left: " .. Countdown.Value.Value 
					task.wait(1)					
				until Countdown.Value.Value < 1 
				Countdown.Text = "GAME OVER"



			end)()
		end

		if Action == "Captured" then 
			local Victim = Header 
			game.Players.LocalPlayer.PlayerGui.GameFrame.MainFrame.CapturedFrame.Visible = true 
			game.Players.LocalPlayer.PlayerGui.GameFrame.MainFrame.CapturedFrame.Text.Visible = true 

			game.Players.LocalPlayer.PlayerGui.GameFrame.MainFrame.CapturedFrame.Text.Text = Victim .. " was captured."
			task.delay(1.5, function() 
				game.Players.LocalPlayer.PlayerGui.GameFrame.MainFrame.CapturedFrame.Visible = false 
				game.Players.LocalPlayer.PlayerGui.GameFrame.MainFrame.CapturedFrame.Text.Visible = false 
			end)
		end


		if Action == "ComputerToggle" then 
			local Victim = Header 

			coroutine.wrap(function()
				game.Players.LocalPlayer.PlayerGui.GameFrame.MainFrame.Computers.Text.Text = game.ReplicatedStorage.GameInformation.Computers.Value .. " computers left"
				game.Players.LocalPlayer.PlayerGui.GameFrame.MainFrame.Computers.Visible = true 
				game.Players.LocalPlayer.PlayerGui.GameFrame.MainFrame.Computers.Text.Visible = true 

				repeat 
					game.Players.LocalPlayer.PlayerGui.GameFrame.MainFrame.Computers.Text.Text = game.ReplicatedStorage.GameInformation.Computers.Value .. " computers left"
					task.wait(1)
				until game.ReplicatedStorage.GameInformation.Computers.Value == 0 

				game.Players.LocalPlayer.PlayerGui.GameFrame.MainFrame.Computers.Visible = false 
				game.Players.LocalPlayer.PlayerGui.GameFrame.MainFrame.Computers.Text.Visible = false 

			end)()
		end 



	end)
end


function controller:HammerSwing(character)
	local animation = script.Animation 
	animation.AnimationId = "rbxassetid://13790135038"
	local track = character.Humanoid:LoadAnimation(animation)
	track:Play() 

end

function controller.HostPanel() 
	local HostPanel = game.Players.LocalPlayer.PlayerGui.HostPanel

	HostPanel.MainFrame.Settings.Activated:Connect(function()
		if not HostPanel.Settings.Visible then 
			HostPanel.Settings.Visible = true 
		else 
			HostPanel.Settings.Visible = false 
		end
	end)

	HostPanel.Settings.QuestionAdd.Activated:Connect(function()
		local player = game.Players.LocalPlayer 
		local character = player.Character or player.CharacterAdded:Wait() 

		--/Local Dependencies 

		--[[ Interfacing ]] -- 
		local Gui = player.PlayerGui:WaitForChild("InputQuestionsGui", timeout)

		local Frame = Gui.MainFrame 
		local Input = Frame.Input 
		local Submit = Frame.Submit 
		local Finish = Frame.Finish 
		local Questions = Frame.Questions 

		-- [[ Titles ]] -- 
		local Title = Frame.Title 
		local TitleTwo = Frame.TitleTwo 

		-- [[ Answers ]] --
		local Answers = Frame.Answers 
		local AnswerOne = Answers.AnswerOne
		local AnswerTwo = Answers.AnswerTwo
		local AnswerThree = Answers.AnswerThree
		local AnswerFour = Answers.AnswerFour


		for _,v in(Frame:GetDescendants()) do 
			if v:IsA("TextButton") or v:IsA("TextLabel") then 
				-- 
				v.TextTransparency = 1 
				v.BackgroundTransparency = 1 
			elseif v:IsA("TextBox") then 
				-- 
				v.TextTransparency = 1 
			end
		end

		Gui.Enabled = true 
		for _,v in(Frame:GetDescendants()) do 
			if v:IsA("TextButton") or v:IsA("TextLabel") then 
				TweenBase(v, 1, "TextTransparency", 0)

				if v:GetAttribute("BackgroundTransparency") then 
					TweenBase(v, 1, "BackgroundTransparency", v:GetAttribute("BackgroundTransparency"))
				else 
					TweenBase(v, 1, "BackgroundTransparency", 0)
				end
				--
			elseif v:IsA("TextBox") then 
				TweenBase(v, 1, "TextTransparency", 0)

				if v:GetAttribute("BackgroundTransparency") then 
					TweenBase(v, 1, "BackgroundTransparency", v:GetAttribute("BackgroundTransparency"))
				else 
					TweenBase(v, 1, "BackgroundTransparency", 0)
				end
			end
		end 

	end)

end
--//@Server Module Identifiers 

function controller.ServerAdapter() 


	remote.OnServerEvent:Connect(function(player, Action) 
		if Action == "StartGame" then 
			local fold = game.ServerStorage.Maps:GetChildren()
			local random = math.random(1, #fold)
			local map = fold[random]

			remote:FireAllClients("SendNotification", "Map", "The map for this game will be: " .. map.Name)

			task.wait(3)
			remote:FireAllClients("SendNotification", "Game Start", "The game will be starting now!")
			task.wait(3)
			remote:FireAllClients("SendNotification", "Answer the questions", "Once everyone is done with these questions the game will start!")
			task.wait(3)


			local fold = game.ReplicatedStorage.MainController.Questions:GetChildren()
			local random = math.random(1, #fold)
			local question = fold[random]

			remote:FireAllClients("QueryPlayer", question.Name)
			task.wait(34)

			local fold = game.ReplicatedStorage.MainController.Questions:GetChildren()
			local random = math.random(1, #fold)
			local question = fold[random]
			
			remote:FireAllClients("SendNotification", "Questions", "First Question knocked out! 2 more to go!")
			remote:FireAllClients("QueryPlayer", question.Name)
			task.wait(34)

			local fold = game.ReplicatedStorage.MainController.Questions:GetChildren()
			local random = math.random(1, #fold)
			local question = fold[random]
			
			remote:FireAllClients("SendNotification", "Questions", "Second Question knocked out! 1 more to go!")
			remote:FireAllClients("QueryPlayer", question.Name)
			task.wait(34)
			remote:FireAllClients("SendNotification", "Questions", "Last Question knocked out!")
			task.wait(2)
			remote:FireAllClients("SendNotification", "Game Start", "The game will be starting now.")
			

			TweenBase(game.Lighting.ScreenEffects, 2, "Brightness", -1)

			local newmap = map:Clone() 
			newmap.Parent = workspace 
			
			task.wait(1)

			for _,v in(workspace:GetChildren()) do 
				if v:FindFirstChild("Humanoid") and not v:GetAttribute("Ignored") then 
					v.Parent = workspace.Players
				end
			end


			local fold = workspace.Players:GetChildren()
			local random = math.random(1, #fold)
			local chosenKiller = fold[random]

			chosenKiller:SetAttribute("Killer", true)

			for _,v in(workspace.Players:GetChildren()) do
				v:SetAttribute("InGame", true)
				v.Humanoid.WalkSpeed = 0 
				v.Humanoid.JumpPower = 0 
			end


			for _,v in(workspace.Players:GetChildren()) do 
				if v:FindFirstChild("Humanoid") and v.Parent ~= chosenKiller then  
					v:PivotTo(newmap.RegularSpawn.CFrame + Vector3.new(0,3,0))
				end
			end

			chosenKiller:PivotTo(newmap.KillerSpawn.CFrame + Vector3.new(math.random(-3,3),3,0))

			task.wait(2)
			TweenBase(game.Lighting.ScreenEffects, 2, "Brightness", 0)

			remote:FireAllClients("SendNotification", "Game Start", "The game will be starting in 10 seconds!")
			remote:FireAllClients("Countdown", 10)
			remote:FireAllClients("ShowPlayerFrames")

			task.wait(10)

			for _,v in(workspace.Players:GetChildren()) do
				v.Humanoid.WalkSpeed = 14 
				v.Humanoid.JumpPower = 40 
			end

			if game.Players:FindFirstChild(chosenKiller.Name) then 
				local hammer = game.ReplicatedStorage.Hammer:Clone()
				hammer.Parent = game.Players[chosenKiller.Name].Backpack
				hammer.Handle.Owner.Value = chosenKiller.Name 
			end

			remote:FireAllClients("Countdown", 10)

			for _,v in(workspace.Players:GetChildren()) do 
				if v:FindFirstChild("Humanoid") and v.Parent ~= chosenKiller then  
					v:PivotTo(newmap.RegularSpawn.CFrame + Vector3.new(0,3,0))
				end
			end

			chosenKiller:PivotTo(newmap.KillerSpawn.CFrame + Vector3.new(0,3,0))

			game.ReplicatedStorage.GameInformation.Killer.Value = chosenKiller.Name 
			game.ReplicatedStorage.GameInformation.Computers.Value = 5 

			task.wait(3)
			remote:FireAllClients("GameCountdown", 600)
			remote:FireAllClients("ComputerToggle", true)

		end
	end)




	remote.OnServerEvent:Connect(function(player, Action, QuestionText, AnswerOne, AnswerTwo, AnswerThree, AnswerFour)
		if Action == "CreateQuestion" then 
			local Question = Instance.new("Folder")
			Question.Parent = game.ReplicatedStorage.MainController.Questions
			Question.Name = QuestionText

			--[[ Create Answers for the questions ]] --  
			local Answer1 = Instance.new("BoolValue")
			Answer1.Parent = Question 
			Answer1.Name = AnswerOne
			Answer1.Value = true 
			-- 
			local Answer2 = Instance.new("BoolValue")
			Answer2.Parent = Question 
			Answer2.Name = AnswerThree
			Answer2.Value = false 
			-- 
			local Answer3 = Instance.new("BoolValue")
			Answer3.Parent = Question 
			Answer3.Name = AnswerThree
			Answer3.Value = false  
			-- 
			local Answer4 = Instance.new("BoolValue")
			Answer4.Parent = Question
			Answer4.Name = AnswerFour
			Answer4.Value = false 
		end
	end)

	remote.OnServerEvent:Connect(function(player, Action) 
		if Action == "QueryPlayer" then 
			local fold = game.ReplicatedStorage.MainController.Questions:GetChildren()
			local random = math.random(1, #fold)
			local question = fold[random]

			remote:FireClient(player, "QueryPlayer", question.Name)
		end
		if Action == "QueryAllPlayers" then 
			local fold = game.ReplicatedStorage.MainController.Questions:GetChildren()
			local random = math.random(1, #fold)
			local question = fold[random]

			remote:FireAllClients("QueryPlayer", question.Name)
		end
	end)

	remote.OnServerEvent:Connect(function(player, Action, Computer)
		if Action == "RespondToComputer" then 
			print(Computer)
			
				for _,v in(workspace:GetDescendants()) do 
					if v.Name == Computer then 
						if Computer:GetAttribute("Health") then 
							v:SetAttribute("Health", v:GetAttribute("Health") - 1)
						else 
							v:SetAttribute("Health", 3)
						end 

						if v:GetAttribute("Health") == 0 then 
							game.ReplicatedStorage.GameInformation.Computers.Value -= 1 
							if game.ReplicatedStorage.GameInformation.Computers.Value == 0 then 
								-- WIN HERE 
							end

						end

				end
			end
		end
	end)

end

function controller:QueryPlayer(player, question)
	remote:FireClient(player, "QueryPlayer", question.Name)
end 



return controller
