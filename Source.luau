local Teleport = function(Argument)
    local Success, Error = pcall(function() 
        local Get_Vehicle = function()
            for Index, Value in Workspace:GetChildren() do
                if string.match(tostring(Value), "'s Car") and Value.CarType.Value ~= "Bike" and Value.CarType.Value ~= "Humvee" and Value:FindFirstChild("DriveSeat") then
                    if Value.DriveSeat.Occupant == nil then
                        for _Index, _Value in Value.Body:GetChildren() do
                            if _Value:IsA("Seat") then
                                if _Value.Occupant ~= nil then 
                                    continue
                                    else
                                    return Value
                                end
                            end
                        end
                    end
                end
            end
        end

        local Car = Get_Vehicle()

        if typeof(Argument) == "string" or (typeof(Argument) == "Instance" and Argument:IsA("Player")) then
            for Index, Value in game:GetService("Players"):GetPlayers() do
                if Value == game:GetService("Players").LocalPlayer then continue end

                if string.match(tostring(Value):lower(), tostring(Argument):lower()) or string.find(tostring(Value):lower(), tostring(Argument):lower()) then
                    Argument = Value.Character.HumanoidRootPart.CFrame

                    break
                end   
            end
        end

        if typeof(Argument) == "Vector3" then
            Argument = CFrame.new(Argument.X, Argument.Y, Argument.Z)
        end

        if typeof(Argument) == "Instance" then
            pcall(function()
                Argument = Argument:IsA("Model") and Argument.WorldPivot or Argument.CFrame
            end)
        end

        Car.Body:FindFirstChildOfClass("Seat"):Sit(game:GetService("Players").LocalPlayer.Character.Humanoid)

        task.wait(1.5)

        Car.PrimaryPart = Car.Body:FindFirstChildOfClass("Part")

        local Old_Pos = Car.PrimaryPart.CFrame

        Car:SetPrimaryPartCFrame(Argument + Vector3.new(0,2,0))

        task.wait(0.25)

        game:GetService("ReplicatedStorage"):WaitForChild("DoorService"):FireServer("HOP", Car)

        task.wait(0.5)

        Car:SetPrimaryPartCFrame(Old_Pos)
    end)

    if Success == false and Error then
        if Error:find("index nil with 'Body'") then
            return warn("[KNOWN TELEPORTATION ERROR] : NO CAR FOUND")
        end

        if Error:find("is not a valid member of Players") then
            return warn("[KNOWN TELEPORTATION ERROR] : PLAYER NOT FOUND")
        end

        if Error:find(`HumanoidRootPart is not a valid member of Model {'"Workspace'}`) then
            return warn("[KNOWN TELEPORTATION ERROR] : NO CAR FOUND")
        end

        return warn("[UNKNOWN TELEPORTATION ERROR] :", Error)
    end

    return "Success"
end

return Teleport
