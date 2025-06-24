-- Saga's Epic Adventure
-- A super long text-based adventure game for A-shell in Lua

-- Helper functions
local function slowPrint(text, delay)
    delay = delay or 0.02
    for i = 1, #text do
        io.write(text:sub(i,i))
        io.flush()
        os.execute("sleep " .. delay)
    end
    print()
end

local function prompt(options)
    print()
    for i, opt in ipairs(options) do
        print(i .. ") " .. opt)
    end
    io.write("> ")
    local choice = tonumber(io.read())
    while not choice or choice < 1 or choice > #options do
        io.write("Invalid choice. Try again: ")
        choice = tonumber(io.read())
    end
    return choice
end

-- Game state
local state = {
    name = "Saga",
    health = 100,
    inventory = {},
    location = "start",
    quests = {},
    flags = {},
}

-- Inventory helper
local function hasItem(item)
    for _, v in ipairs(state.inventory) do
        if v == item then return true end
    end
    return false
end

local function addItem(item)
    if not hasItem(item) then
        table.insert(state.inventory, item)
        slowPrint("You have acquired: " .. item)
    end
end

local function removeItem(item)
    for i, v in ipairs(state.inventory) do
        if v == item then
            table.remove(state.inventory, i)
            slowPrint("You have lost: " .. item)
            return
        end
    end
end

-- Show status
local function showStatus()
    print("\n--- STATUS ---")
    print("Name: " .. state.name)
    print("Health: " .. state.health)
    io.write("Inventory: ")
    if #state.inventory == 0 then
        print("Empty")
    else
        print(table.concat(state.inventory, ", "))
    end
    print("--------------\n")
end

-- Locations and story branches

local function start()
    slowPrint("Welcome, Saga. Your journey begins at the edge of the ancient forest of Eldoria.")
    slowPrint("You stand at a fork in the road. To the left, a dark path leads into the deep woods.")
    slowPrint("To the right, the road climbs a rocky hill where you see the ruins of an old tower.")
    
    local choice = prompt({
        "Take the dark path into the forest.",
        "Climb the rocky hill towards the tower ruins.",
        "Check your status.",
        "Quit the adventure."
    })

    if choice == 1 then
        state.location = "forest_path"
        forestPath()
    elseif choice == 2 then
        state.location = "tower_ruins"
        towerRuins()
    elseif choice == 3 then
        showStatus()
        start()
    else
        slowPrint("Farewell, Saga. Your adventure ends here.")
    end
end

local function forestPath()
    slowPrint("The forest grows darker and the air cooler as you step deeper.")
    slowPrint("Suddenly, you hear a rustling noise. A wild wolf appears, growling menacingly!")
    
    local choice = prompt({
        "Fight the wolf.",
        "Try to scare it away.",
        "Run back to the fork in the road.",
        "Check your status."
    })

    if choice == 1 then
        fightWolf()
    elseif choice == 2 then
        scareWolf()
    elseif choice == 3 then
        state.location = "start"
        start()
    else
        showStatus()
        forestPath()
    end
end

local function fightWolf()
    slowPrint("You prepare to fight the wolf!")
    if hasItem("Rusty Sword") then
        slowPrint("You draw your Rusty Sword and strike the wolf.")
        slowPrint("After a fierce battle, you defeat the wolf but suffer some injuries.")
        state.health = state.health - 20
        if state.health <= 0 then
            gameOver("The wolf's attack was fatal. You have perished.")
        else
            slowPrint("You survived the fight but your health is now " .. state.health .. ".")
            addItem("Wolf Pelt")
            forestClearing()
        end
    else
        slowPrint("You have no weapon! The wolf attacks you fiercely.")
        gameOver("Without a weapon, you stand no chance. The wolf kills you.")
    end
end

local function scareWolf()
    slowPrint("You shout loudly and wave your arms.")
    slowPrint("The wolf hesitates, then snarls and backs away slowly into the shadows.")
    forestClearing()
end

local function forestClearing()
    slowPrint("You find a small clearing with strange glowing flowers.")
    slowPrint("In the middle, there's an old chest covered with vines.")
    
    local choice = prompt({
        "Open the chest.",
        "Pick some glowing flowers.",
        "Return to the fork in the road.",
        "Check your status."
    })
    
    if choice == 1 then
        slowPrint("You open the chest and find a finely crafted bow.")
        addItem("Elven Bow")
        forestClearing()
    elseif choice == 2 then
        slowPrint("You pick some glowing flowers and put them in your pouch.")
        addItem("Glowing Flowers")
        forestClearing()
    elseif choice == 3 then
        state.location = "start"
        start()
    else
        showStatus()
        forestClearing()
    end
end

local function towerRuins()
    slowPrint("You climb the rocky hill and reach the crumbling ruins of an ancient tower.")
    slowPrint("Inside, you see a spiral staircase leading down into darkness.")
    
    local choice = prompt({
        "Descend the staircase.",
        "Search the tower ruins outside.",
        "Return to the fork in the road.",
        "Check your status."
    })

    if choice == 1 then
        state.location = "underground"
        underground()
    elseif choice == 2 then
        slowPrint("You find some old scraps of paper with strange symbols.")
        addItem("Ancient Scroll")
        towerRuins()
    elseif choice == 3 then
        state.location = "start"
        start()
    else
        showStatus()
        towerRuins()
    end
end

local function underground()
    slowPrint("You carefully descend into the darkness below the tower.")
    slowPrint("The air is damp and you hear the distant sound of dripping water.")
    slowPrint("Suddenly, you see a faint light ahead and a shadowy figure blocking the path!")
    
    local choice = prompt({
        "Approach the figure peacefully.",
        "Prepare to fight.",
        "Try to sneak around.",
        "Go back upstairs."
    })

    if choice == 1 then
        talkToFigure()
    elseif choice == 2 then
        fightFigure()
    elseif choice == 3 then
        sneakAround()
    else
        towerRuins()
    end
end

local function talkToFigure()
    slowPrint("You step forward calmly and greet the figure.")
    slowPrint("The figure reveals itself to be an ancient guardian spirit.")
    slowPrint("\"Only the worthy may proceed,\" it says.")
    
    if hasItem("Ancient Scroll") then
        slowPrint("You show the Ancient Scroll. The guardian smiles and steps aside.")
        secretChamber()
    else
        slowPrint("Without proof of your worth, the guardian does not allow you to pass.")
        underground()
    end
end

local function fightFigure()
    slowPrint("You ready your weapon and attack!")
    if hasItem("Elven Bow") then
        slowPrint("Using your Elven Bow, you land a precise shot and the guardian vanishes.")
        secretChamber()
    else
        slowPrint("You have no suitable weapon and the guardian's magic overwhelms you.")
        gameOver("You were defeated by the guardian spirit.")
    end
end

local function sneakAround()
    slowPrint("You try to sneak past the figure.")
    local success = math.random() < 0.5
    if success then
        slowPrint("You successfully sneak past and enter a hidden chamber.")
        secretChamber()
    else
        slowPrint("The guardian notices you and attacks.")
        gameOver("You were caught sneaking and defeated.")
    end
end

local function secretChamber()
    slowPrint("Inside the secret chamber, you find a pedestal with a glowing gem.")
    slowPrint("The gem pulses with ancient power.")
    
    local choice = prompt({
        "Take the glowing gem.",
        "Leave it alone and explore further.",
        "Return upstairs."
    })
    
    if choice == 1 then
        slowPrint("As you take the gem, a surge of energy flows through you.")
        addItem("Glowing Gem")
        state.health = math.min(state.health + 50, 100)
        slowPrint("Your health is restored to " .. state.health .. ".")
        secretChamber()
    elseif choice == 2 then
        slowPrint("You find a hidden passage leading out of the tower ruins.")
        state.location = "forest_exit"
        forestExit()
    else
        underground()
    end
end

local function forestExit()
    slowPrint("You emerge from the tower ruins back to the forest edge.")
    slowPrint("With the glowing gem in your possession, your adventure continues...")
    
    local choice = prompt({
        "Venture deeper into the forest.",
        "Return to the fork in the road.",
        "Check your status.",
        "Quit the adventure."
    })
    
    if choice == 1 then
        deepForest()
    elseif choice == 2 then
        state.location = "start"
        start()
    elseif choice == 3 then
        showStatus()
        forestExit()
    else
        slowPrint("You decide to end your journey here. Farewell, Saga.")
    end
end

local function deepForest()
    slowPrint("You push deeper into the forest, where ancient magic hums in the air.")
    slowPrint("Suddenly, you are faced with a massive stone door with strange runes.")
    
    if hasItem("Glowing Gem") then
        slowPrint("The gem pulses and the runes glow brighter.")
        slowPrint("You place the gem into a socket on the door, which slowly opens...")
        finalChallenge()
    else
        slowPrint("The door is sealed tight. You need something to unlock it.")
        forestExit()
    end
end

local function finalChallenge()
    slowPrint("Beyond the door lies a cavern filled with shadows and a towering dragon!")
    slowPrint("The dragon eyes you fiercely, smoke curling from its nostrils.")
    
    local choice = prompt({
        "Fight the dragon.",
        "Try to talk to the dragon.",
        "Use the glowing gem to attempt a magical defense.",
        "Run away."
    })
    
    if choice == 1 then
        fightDragon()
    elseif choice == 2 then
        talkDragon()
    elseif choice == 3 then
        useGemOnDragon()
    else
        slowPrint("You escape safely but your quest remains unfinished.")
        forestExit()
    end
end

local function fightDragon()
    slowPrint("You charge the dragon with all your might!")
    if hasItem("Elven Bow") and hasItem("Rusty Sword") then
        slowPrint("Using your weapons skillfully, you battle fiercely.")
        slowPrint("After a long fight, you slay the dragon!")
        slowPrint("Congratulations, Saga! You have completed your epic adventure!")
    else
        slowPrint("Without powerful weapons, the dragon overpowers you.")
        gameOver("You were slain by the dragon.")
    end
end

local function talkDragon()
    slowPrint("You attempt to speak with the dragon.")
    if hasItem("Ancient Scroll") then
        slowPrint("Showing the Ancient Scroll, the dragon calms and listens.")
        slowPrint("The dragon tells you ancient secrets and grants you a wish.")
        slowPrint("You win the adventure with newfound wisdom!")
    else
        slowPrint("The dragon does not understand and burns you with fire.")
        gameOver("You were burned to ashes.")
    end
end

local function useGemOnDragon()
    slowPrint("You raise the glowing gem, and it emits a protective shield.")
    slowPrint("The dragon's fire bounces off and you get a chance to escape.")
    forestExit()
end

local function gameOver(reason)
    slowPrint(reason)
    slowPrint("Game Over. Thank you for playing Saga's Epic Adventure.")
    os.exit()
end

-- Start the game
math.randomseed(os.time())
slowPrint("Loading Saga's Epic Adventure...")
start()
