function love.draw()
	if funny then
		love.graphics.clear()
		love.graphics.draw(funnitable[funnycount], 0, 0)
	elseif playing then
		love.graphics.draw(board, 0, 0)
		love.graphics.draw(player1mod, curplayer1x, curplayer1y)
		love.graphics.draw(player2mod, curplayer2x, curplayer2y)
		drawPlayer1Stats()
		drawPlayer2Stats()
		love.graphics.draw(dice1, 360, 110)
		love.graphics.draw(dice2, 360,360)
		
		if player == 1 then
			highlight(1)
		elseif player==2 then
			highlight(2)
		end
	elseif finished then
		print(loser)
		str = "Player "..tostring(loser).." lost... what a loser"
		love.graphics.print(str, 100, 100)		
	elseif startup then		
		love.graphics.setBackgroundColor(0, 0, 255)		
		love.graphics.print("Only two players at a time", 50, 30)
		love.graphics.print("To choose a character press the corresponding key!", 50, 50)
		love.graphics.print("1..2", 260, 80)
		love.graphics.print("3..4", 260, 100)
		love.graphics.print("5..6", 260, 120)
		love.graphics.draw(shoe, 60, 60)
		love.graphics.draw(racecar, 60, 160)
		love.graphics.draw(battleship, 60, 260)
		
		love.graphics.draw(dog, 180, 60)
		love.graphics.draw(iron, 180, 160)
		love.graphics.draw(tophat, 180, 260)
		
		love.graphics.print("B to buy property", 180, 350)
		love.graphics.print("R to roll the die, alternates between players", 180, 370)
		love.graphics.print("E to end your turn", 180, 390)
	end
	love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 10, 10)	
end

function love.keypressed(key)
	if not playing then
		if key==1 or key=="1" then
			print("Key 1")
			if player1==true then
				player1 = false
				player1mod = shoe
			elseif player2==true then
				player2 = false
				player2mod = shoe
			end
		elseif key==2 or key=="2" then
			if player1==true then
				player1 = false
				player1mod = dog
			elseif player2==true then
				player2 = false
				player2mod = dog
			end
		elseif key==3 or key=="3" then
			if player1==true then
				player1 = false
				player1mod = racecar
			elseif player2==true then
				player2 = false
				player2mod = racecar
			end
		elseif key==4 or key=="4" then
			if player1==true then
				player1 = false
				player1mod = iron
			elseif player2==true then
				player2 = false
				player2mod = iron
			end
		elseif key==5 or key=="5" then
			if player1==true then
				player1 = false
				player1mod = battleship
			elseif player2==true then
				player2 = false
				player2mod = battleship
			end
		elseif key==6 or key=="6" then
			if player1==true then
				player1 = false
				player1mod = tophat
			elseif player2==true then
				player2 = false
				player2mod = tophat
			end
		end
	else
		if (key=="r" or key=="R") and not rolled then
			rolled = true
			print("Rolling for player "..player)
			die1 = roll()
			die2 = roll()
			dice1 = dicetable[die1]
			dice2 = dicetable[die2]
			move(die1+die2)			
		elseif key=="b" or key=="B" then
			if player==1 and ownership[player1boardloc]==none then
				love.graphics.print("Buying this property for "..costs[player1boardloc], 105,127)
				removeMonies(1,costs[player1boardloc])
				ownership[player1boardloc] = "Player 1"
			elseif player==2 and ownership[player2boardloc]==none then
				--love.graphics.print("Buying this property for"..costs[player2boardloc]. 105, 355)
				removeMonies(2, costs[player2boardloc])
				ownership[player2boardloc] = "Player 2"
			end
		elseif key=="e" or key=="E" then
			rolled = false
			if player == 1 then
				processloc(1)
				player = 2
			else
				processloc(2)
				player = 1
			end
		end
		
	end
	--print(key)
	if key=="lctrl" then
		--print("lctrl")
		if funny then
			funny = false
			playing = true
			funnycount=funnycount+1
			if funnycount>table.getn(funnitable) then
				funnycount = 1
			end
		else
			funny = true
			playing = false
			
		end
		
		--print(funnycount)
	end
end
function love.load()
	--love.audio.play(love.audio.newSource("aoeIII.mp3"))
	love.graphics.setMode(500, 500, false, false)
	loadBoard()
	loadPlayers()
	loadDice()
	loadFunny()
end

function love.update()
	if player1~=true and player2~=true then
		playing = true
		startup = false
	end
	if curplayer1x == destplayer1x and curplayer1y == destplayer1y then
		--do nothing things are where they are supposed to be
	else
		--
		if curplayer1x<destplayer1x then			
			curplayer1x = curplayer1x + 1
		elseif curplayer1y<destplayer1y then
			curplayer1y = curplayer1y +1
		end		
		if curplayer1x>destplayer1x then
			curplayer1x = curplayer1x - 1
		elseif curplayer1y>destplayer1y then
			curplayer1y = curplayer1y - 1
		end	
	end
	if curplayer2x == destplayer2x and curplayer2y == destplayer2y then
	
	else
		--player2
		if curplayer2x<destplayer2x then			
			curplayer2x = curplayer2x + 1
		elseif curplayer2y<destplayer2y then
			curplayer2y = curplayer2y +1
		end		
		if curplayer2x>destplayer2x then
			curplayer2x = curplayer2x - 1
		elseif curplayer2y>destplayer2y then
			curplayer2y = curplayer2y - 1
		end
	end 
	if player1amt <= 0 then
		lose(1)
	elseif player2amt <=0 then
		lose(2)
	end	
end

function roll()
	return math.random(5)+1
end

function move(number)
	if player == 1 then
		if number+player1boardloc>=27 then
			player1boardloc = (player1boardloc+number)-27			
		else 
			player1boardloc = player1boardloc+number
		end
		if player1boardloc==0 then
			player1boardloc=1
		end
		loc = locs1[player1boardloc]
		print(player1boardloc)
		print("Moving to;"..loc[1]..", "..loc[2])
		destplayer1x = loc[1]
		destplayer1y = loc[2]		
	elseif player==2 then
		if number+player2boardloc>=27 then
			player2boardloc = (player2boardloc+number)-27
		else
			player2boardloc = player2boardloc+number
		end
		if player2boardloc==0 then
			player2boardloc=1
		end
		loc = locs1[player2boardloc]
		print(player2boardloc)
		print("Moving to;"..loc[1]..", "..loc[2])
		destplayer2x = loc[1]
		destplayer2y = loc[2]
	end
end

function add(playerno, amount)
	if playerno == 1 then
		player1amt= player1amt+amount
	else
		player2amt = player2amt+amount
	end
end

function removeMonies(playerno, amount)
	if playerno == 1 then
		player1amt = player1amt - tonumber(amount)
	else
		player2amt = player2amt - tonumber(amount)
	end 

end

function lose(playerno)
	loser = playerno
	playing = false
	finished = true
end

function loadBoard()
	print("Loading Board")
	board = love.graphics.newImage("board.png")
end

function loadPlayers()
	print("Loading players")
	racecar = love.graphics.newImage("racecar.png") --palindrome motherfucker
	battleship = love.graphics.newImage("battleship.png")
	shoe = love.graphics.newImage("shoe.png")
	iron = love.graphics.newImage("iron.png")
	dog = love.graphics.newImage("dog.png")
	tophat = love.graphics.newImage("tophat.png")
end

function loadDice()
	dir = "dice/"
	print("Loading dice")
	one = love.graphics.newImage(dir.."one.png")
	two = love.graphics.newImage(dir.."two.png")
	three = love.graphics.newImage(dir.."three.png")
	four = love.graphics.newImage(dir.."four.png")
	five = love.graphics.newImage(dir.."five.png")
	six = love.graphics.newImage(dir.."six.png")
	dice1 = two
	dice2 = one
	dicetable = {one, two, three, four, five, six}
end

function loadFunny()
	dir = "funny/"
	print("Loading mah funnies!")
	jesus = love.graphics.newImage(dir.."jesus.png")
	cat = love.graphics.newImage(dir.."cat.png")
	thuglife = love.graphics.newImage(dir.."thuglife.png")
	funnitable = {jesus, cat, thuglife}
end

function drawPlayer1Stats()
	love.graphics.setColor(0,0,0)
	love.graphics.print("Player 1:", 105, 105)
	love.graphics.print("Monies: "..player1amt, 105, 115)
	love.graphics.print("Cost of current property: "..costs[player1boardloc], 105, 127)
	love.graphics.print("Rent: "..rents[player1boardloc], 105, 138)
	love.graphics.print("Owned by: "..ownership[player1boardloc], 105, 149)
	love.graphics.setColor(255,255,255)
end

function drawPlayer2Stats()
	love.graphics.setColor(0,0,0)
	love.graphics.print("Player 2",105, 335)
	love.graphics.print("Monies: "..player2amt, 105, 345)
	love.graphics.print("Cost of current property: "..costs[player2boardloc], 105, 355)
	love.graphics.print("Rent: "..rents[player2boardloc], 105, 365)
	love.graphics.print("Owned by: "..ownership[player2boardloc], 105, 375)
	love.graphics.setColor(255,255,255)
end

function highlight(number)
	love.graphics.setColor(0,0,0)
	love.graphics.print("Player "..number.."'s turn", 200, 315)
	love.graphics.setColor(255,255,255)
end

function processloc(number)
	if number == 1 then
		if ownership[player1boardloc] == "Player 2" then
			removeMonies(1, rents[player1boardloc])
			add(2, rents[player1boardloc])
		elseif ownership[player1boardloc] == master then
			print("Who dares disturb the dungeon master?")
		end
	elseif number == 2 then
		if ownership[player2baordloc] == "Player 1" then
			removeMonies(2, rents[player2boardloc])
			add(1, rents[player2boardloc])
		elseif ownership[player2boardloc] == master then
			print("Who dares disturb the dungeon master?")
		end
	end
end

rolling = false
moving = false
playing = false
players = 2
player = 1

player1 = true
curplayer1x = 400
curplayer1y = 400

destplayer1x = 400
destplayer1y = 400

player1amt = 100

player2 = true
curplayer2y = 400
curplayer2x = 400

destplayer2x = 400
destplayer2y = 400

player1boardloc = 1
player2boardloc = 1

player2amt = 100


locs1 = {
{400,400}, {350,400}, {300,400}, {250,400}, {200,400}, {150,400}, {100,400},
{50,350}, {50,300}, {50,250}, {50,200}, {50,150}, {50,100}, {50, 50},
{150, 50}, {200,50}, {250, 50},{300, 50},{350, 50},{400,50},
{400, 100},{400, 150},{400, 200},{400, 250},{400, 300},{400, 350}
}
locs2 = {
{450,450}, {400, 450}, {350, 450}, {300, 450}, {250, 450}, {200, 450},
{200,400}, {200, 350}, {200, 300}, {200, 250}, {200, 200}, {200, 150},
{250, 150}, {300, 150}, {350, 150}, {400, 150}, {450,150}, {500, 150},
{500, 200}, {500, 250}, {500,300}, {500, 350}, {500, 400}, {500,450}
}

costs = {
"Nothing", 50, 50, 60, 100, "Nothing", 120,
"Nothing", 140, "Nothing", 200, 150, 150, 160,
"Nothing", 200, "Nothing", 140, 190, 190, 200,
"Nothing", 300, 310, "Nothing", 400, 400, 410
}

rents = {
"Nothing", 5, 5, 5, 10, "Nothing", 12,
"Nothing", 14, "Nothing", 100, 15, 15, 16,
"Nothing", 100, "Nothing", 14, 19, 19, 20,
"Nothing", 30, 31, "Nothing", 40, 40, 41
}
master = "Dungenon Master"
none = "No One"
ownership = {
master, none, none, none, none, master, none,
master, none, master, none, none, none, none,
master, none, master, none, none, none, none,
master, none, none, none, master, none, none
}

rolled = false

funnycount = 1

startup = true

property1 = {}

property2 = {}
--[[
player board loc as follows:
bottom strip 0-6
left strip 7-13
top strip 14-20
right strip 21-27


--]]