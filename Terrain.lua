Terrain = {}
Terrain.__index = Terrain
-- Constructor
function Terrain:new(h,m,d)
	-- define our parameters here
	

	self = setmetatable({}, Terrain)
	self.height=h
	self.magic=m
	self.developed = d
	self.biome = ""
	self.building = ""
	self.isWalkable = false
	self.__index = self
	return self
end

function Terrain:getColor()
	--print(height,magic,developed)
	--print(self.height,self.magic,self.developed)
	
	if self.height<15 then
		self.isWalkable = false
		return 0,0,205 --Ocean
	elseif self.height<30 then
		self.isWalkable = false
		return 0,191,255 --Shallow Water
	elseif self.height<35 then
		self.isWalkable = true
		return 255,255,55 --Beach
	end

	if self.magic>30 and math.floor(self.magic*1000)%1500==420 then
		self.isWalkable = true
		self.building = "tower"
	elseif self.developed>30 and math.floor(self.developed*100)%1200==313 then
		self.isWalkable = true
		self.building = "town"
	elseif self.developed <=35 and math.floor(self.developed*100)%500==257 then
		self.isWalkable = true
		self.building = "cave"
	end	
	
	if self.developed<=20 and self.magic >=40 then
		self.isWalkable = true
		self.biome = "static"
		return 47,79,79 --Static Zone
	elseif self.developed <=35 then
		if self.magic<=35 then
			self.isWalkable = true
			self.biome = "desert"
			return 218,165,96--Desert		
		else
			self.isWalkable = true
			self.biome = "mountain"
			return 160,82,45 --Mountain
		end
	elseif self.magic<=40 then
		self.isWalkable = true
		self.biome = "grass"
		return 0,100,0 --Grasslands
	else
		self.isWalkable = true
		self.biome = "snow"
		return 255,255,255 --Snowy
	end
end

function Terrain:biome()
	return self.biome
end

function Terrain:getBuildingColor()
	if self.building =="town" then
		return 255,128,0
	elseif self.building =="tower" then
		return 0,0,0
	elseif self.building == "cave" then
		return 128,128,128
	else
		return nil
	end
end

function Terrain:isWalkable()
	return self.isWalkable
end
