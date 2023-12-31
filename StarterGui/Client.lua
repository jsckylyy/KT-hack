local Controller = require(game.ReplicatedStorage.MainController)

Controller.SetupQueries()
Controller.OnQuery()
Controller.ClientListener()
Controller.HostPanel() 
--
local Gui = game.Players.LocalPlayer.PlayerGui:WaitForChild("InputQuestionsGui", 3)

local Frame = Gui.MainFrame 
local Input = Frame.Input 
local Submit = Frame.Submit 
local Finish = Frame.Finish 
local Questions = Frame.Questions 
local Close = Frame.Cancel


-- [[ Titles ]] -- 
local Title = Frame.Title 
local TitleTwo = Frame.TitleTwo 

-- [[ Answers ]] --
local Answers = Frame.Answers 
local AnswerOne = Answers.AnswerOne
local AnswerTwo = Answers.AnswerTwo
local AnswerThree = Answers.AnswerThree
local AnswerFour = Answers.AnswerFour

Submit.Activated:Connect(function()
	Controller:AddQuery()
end)

Finish.Activated:Connect(function()
	Controller:CloseQueries()
end)

Close.Activated:Connect(function()
	Controller:CloseGui()
end)