## Ultra Lord Ui Library

# Iniializ the library

```local UltraLordLib = loadstring(game:HttpGet(('main.lua')))()```

# Create Window 

``local Window = UltraLordLib:MakeWindow({
    Name = "My Window",
    Theme = "UltraLordV2",
    Font = "Gotham" -- Any of the valid fonts listed above
})``

# Notification

``UltraLordLib:MakeNotification({
    Name = "Title",
    Content = "Message content",
    Image = "rbxassetid://4384403532",
    Time = 5
})``

# Create Button

``local Button = UltraLordLib.Elements.Button()
Button.Text = "Click Me"
Button.MouseButton1Click:Connect(function()
    print("Clicked!")
end)``

# Create Silder (Fixes!)

``CreateSlider(Parent, 0, 100, 50, function(value)
    print("Value:", value)
end)``

# Create Toggle

``CreateToggle(Parent, false, function(state)
    print("State:", state)
end)``
