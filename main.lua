function love.load()
	debugInfo = false
	initialSeed = os.time()
	initialSeed2 = initialSeed*19 -1993
	initialSeed3 = initialSeed*13-2113
	runs =0
	g=love.graphics
	
	persistence = .5
	octaves = 6

	windowWidth, windowHeight = love.window.getMode()

	islandWidth = 1024
	islandHeight = islandWidth

	seedSize = islandWidth/16
	biomeSize = seedSize --was seedSize/2

	tileSize = windowWidth/islandWidth

	randSize = 25

	g.setBackgroundColor(255,255,255,255)

	count=0;

	staticNum =0
	desertNum =0
	mountainNum = 0
	grassNum = 0
	snowNum = 0
	townNum= 0
	towerNum =0
	caveNum= 0

	drawn = false

	towns = {}
	towers = {}
	caves = {}

	island = genIsland()

	print("Drawing Island")
	g.setFont(g.newFont(5))
	canvas = g.newCanvas()
	g.setCanvas(canvas)
		for i=0,islandWidth-1,1 do
			for j=0,islandHeight-1,1 do
				loc={}
				loc['x']=i
				loc['y']=j
				c = island[i][j]
				g.setColor(c:getColor())
				if c.biome =="static" then
					staticNum = staticNum+1
				elseif c.biome =="desert" then
					desertNum = desertNum+1
				elseif c.biome =="mountain" then
					mountainNum = mountainNum +1
				elseif c.biome =="grass" then
					grassNum = grassNum+1
				elseif c.biome =="snow" then
					snowNum = snowNum +1
				end
				if c.building =="town" then
					townNum = townNum+1
					table.insert(towns,loc)
				elseif c.building=="tower" then
					towerNum =towerNum+1
					table.insert(towers,loc)
				elseif c.building == "cave" then
					caveNum= caveNum+1
					table.insert(caves,loc)
				end
				g.rectangle("fill",i*tileSize,j*tileSize,tileSize,tileSize)
			end
		end
	g.setCanvas()
	
end

function love.update(dt)
	count= count+dt
end

function love.draw()
	g.setColor(255,255,255)
	g.setBlendMode("alpha")
	g.draw(canvas)
	if debugInfo then
		g.setColor(255,255,255)
		local totalBiomes = staticNum+desertNum+mountainNum+grassNum+snowNum
		g.print(round(100*staticNum/totalBiomes).."% Static Zone",0,0)
		g.print(round(100*desertNum/totalBiomes).."% Desert",0,13)
		g.print(round(100*mountainNum/totalBiomes).."% Mountain",0,26)
		g.print(round(100*grassNum/totalBiomes).."% Grasslands",0,39)
		g.print(round(100*snowNum/totalBiomes).."% Snowy",0,52)
		g.print("Useable Land: ",0,65)
		g.print(round(100*totalBiomes/(islandWidth*islandHeight)).."% Land, "..totalBiomes.."",0,78)
		g.print(townNum.." Towns, "..caveNum.." Caves and "..towerNum.." Towers",0,91)
		g.print(love.timer.getFPS(),windowWidth-25,0)
		--print(next(towns))
		for k,t in next,towns,nil do
			i = t['x']
			j= t['y']
			g.setColor(255,128,0)
			g.rectangle("fill",i*tileSize,j*tileSize,tileSize,tileSize)

		end
		for k,t in next,towers,nil do
			i = t['x']
			j= t['y']
			g.setColor(0,0,0)
			g.rectangle("fill",i*tileSize,j*tileSize,tileSize,tileSize)

		end
		for k,t in next,caves,nil do
			i = t['x']
			j= t['y']
			g.setColor(128,128,128)
			g.rectangle("fill",i*tileSize,j*tileSize,tileSize,tileSize)

		end
		g.reset()
	end
	drawn =true
end

function round(t)
	return math.floor(t*100)*.01
end

function genIsland()
	print("Starting Island Gen")
	local midX = math.floor(islandWidth/2)
	local midY = math.floor(islandHeight/2)
	local max = math.sqrt(midX^2 + midY^2)

	local magX = math.floor(math.random(islandWidth/3,2*islandWidth/3)-1)
	local magY = math.floor(math.random(islandHeight/3,2*islandHeight/3)-1)
	local maxM = math.sqrt((2*islandWidth/2)^2 + (2*islandHeight/2)^2)

	local devX = math.floor(math.random(islandWidth/3,2*islandWidth/3)-1)
	local devY = math.floor(math.random(islandHeight/3,2*islandHeight/3)-1)
	local maxD = math.sqrt((2*islandWidth/2)^2 + (2*islandHeight/2)^2)

	
	island ={}
	for i=0,islandWidth-1,1 do
		island[i] = {}
		for j=0,islandHeight-1,1 do
			local noiseVal = (perlin(i/seedSize,j/seedSize,initialSeed)+1)/2
			
			local dist = math.sqrt((midX-i)^2+(midY-j)^2)
			local gradientVal = ((dist)/max)
			local h = (noiseVal-gradientVal)*255

			local distM = math.sqrt((magX-i)^2+(magY-j)^2)
			local mGradi = distM/maxM
			local mVal = (perlin(i/biomeSize,j/biomeSize,initialSeed2)+1)/2
			local m = (mVal-.75*mGradi)*100

			local distD = math.sqrt((devX-i)^2+(devY-j)^2)
			local dGradi = distD/maxD
			local dVal = (perlin(i/biomeSize,j/biomeSize,initialSeed3)+1)/2
			local d = (dVal-.75*dGradi)*100
			--print(h,m,d)
			--print(noiseVal,mVal,dVal)
			require "Terrain"
			island[i][j] = Terrain:new(h,m,d)
			--island[i][j] = gradientVal*255
			if i%32==0 and j==0 then
				print("Col "..i.." Generated.") -- mVal is "..mVal)
			end
			--print(island[i][j].height)
			--print(island[i][j]:getColor())
		end
	end
	--[[for i=0,islandWidth-1,1 do
		for j=0,islandHeight-1,1 do
			if i==0 or j==0 or i==islandWidth-1 or j==islandHeight-1  then
				island[i][j] =0
				--print("0 at Row "..i.." Col "..j)
			elseif (i%seedSize==seedSize-1 and j%seedSize==seedSize-1) then
				c =love.math.random(255) 
				island[i][j]= c
				island[i+1][j] = c
				island[i+1][j+1]=c
				island[i][j+1]=c
				--print(island[i][j])			
			end
		end
	end

	for i=seedSize-1,islandWidth-1,seedSize do
		for j=seedSize-1, islandHeight-1,seedSize do
			topRow =j-(seedSize-1)
			leftCol = i-(seedSize-1)
			botRow = j
			rightCol =i
			--print(island[topRow][leftCol])
			--print(island[topRow][rightCol])
			--print(island[botRow][leftCol])
			--print(island[botRow][rightCol])
			--midpointFractal(island,leftCol,topRow,rightCol,topRow,leftCol,botRow,rightCol,botRow)
			--midpointFractal2(island,seedSize)
			
			--print(island[topRow][leftCol])
			--print(island[topRow][rightCol])
			--print(island[botRow][leftCol])
			--print(island[botRow][rightCol])
		end
		--print(island[i][0])
	end
	--print(island[0][0])
	--]]
	print("Ending Island Gen")
	return island
end

function noise(x,y, seed)
	--return love.math.noise(x,y) *2 -1
	local tempSeed = (math.pi * (.5*(x+y)*(x+y+1)+y) +13) +seed
	--print(seed)
	math.randomseed(tempSeed)
	local num = math.random(-100,100) 
	--print(num)
	return num/100
end

function smoothNoise(x,y,seed)
	local corners = (noise(x-1,y-1,seed)+noise(x+1,y-1,seed)+noise(x-1,y+1,seed)+noise(x+1,y+1,seed)) /16
	local sides = (noise(x-1,y,seed)+noise(x+1,y,seed)+noise(x,y-1,seed)+noise(x,y+1,seed))/8
	local center = noise(x,y,seed)/4

	return corners+sides+center
end

function interpolate(x,y,z)
	ft = z* math.pi
	f = (1-math.cos(ft))*.5
	return x*(1-f)+y*f
end

function interpolatedNoise(x,y,seed)
	local intX = math.floor(x)
	local fracX = x-intX

	local intY = math.floor(y)
	local fracY = y - intY

	local v1 = smoothNoise(intX,intY,seed)
	local v2 = smoothNoise(intX+1,intY,seed)
	local v3 = smoothNoise(intX,intY+1,seed)
	local v4 = smoothNoise(intX+1,intY+1,seed)

	local i1 = interpolate(v1,v2,fracX)
	local i2 = interpolate(v3,v4, fracX)

	return interpolate(i1,i2,fracY)

end

function perlin(x,y,seed)
	local total = 0
	local p = persistence
	local n = octaves -1

	for i=0,n,1 do
		local freq = 2^i
		local amp = p^i

		total = total + interpolatedNoise(x*freq, y*freq,seed)*amp
	end
	--print(total)
	return total
end

function love.keyreleased(key)
	if key=="f3" then
		debugInfo = not debugInfo
	elseif key=="f12" then
		love.load()
	end
end
