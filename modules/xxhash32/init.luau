--!strict
--!optimize 2

local PRIME_1 = 0x9e3779B1
local PRIME_2 = 0x85ebca77
local PRIME_3 = 0xc2B2ae3d
local PRIME_4 = 0x27d4eb2f
local PRIME_5 = 0x165667b1

--[=[
    Calculates `a * b` mod 32
]=]
local function mult(a: number, b: number): number
	local ah, al = bit32.rshift(a, 16), a % 2 ^ 16
	local bh, bl = bit32.rshift(b, 16), b % 2 ^ 16
	return bit32.lshift((ah * bl) + (al * bh), 16) + (al * bl)
end

local function xxhash32(message: string, seed: number?): number
	local rSeed = if seed == nil then 0 else seed % 2 ^ 32
	local messageLen = #message

	local wordC = 1

	local i = 1
	local digest
	if messageLen >= 16 then
		-- We don't need to worry about overflow for addition here
		local accum1 = rSeed + PRIME_1 + PRIME_2
		local accum2 = rSeed + PRIME_2
		local accum3 = rSeed
		local accum4 = rSeed - PRIME_1
		for _ = 0, messageLen - 16, 16 do
			local a, b, c, d = string.unpack("I4I4I4I4", message, i)
			accum1 = mult(bit32.lrotate(accum1 + mult(a, PRIME_2), 13), PRIME_1)
			accum2 = mult(bit32.lrotate(accum2 + mult(b, PRIME_2), 13), PRIME_1)
			accum3 = mult(bit32.lrotate(accum3 + mult(c, PRIME_2), 13), PRIME_1)
			accum4 = mult(bit32.lrotate(accum4 + mult(d, PRIME_2), 13), PRIME_1)
			wordC += 4
			i += 16
		end
		digest = bit32.lrotate(accum1, 1)
			+ bit32.lrotate(accum2, 7)
			+ bit32.lrotate(accum3, 12)
			+ bit32.lrotate(accum4, 18)
	else
		digest = (rSeed + PRIME_5) % 2 ^ 32
	end
	digest = (digest + messageLen) % 2 ^ 32

	for _ = wordC, math.floor(messageLen / 4) do
		digest += mult(string.unpack("I4", message, i), PRIME_3)
		digest = mult(bit32.lrotate(digest, 17), PRIME_4)
		wordC += 1
		i += 4
	end

	for j = -(messageLen % 4), -1 do
		digest += mult(string.byte(message, j), PRIME_5)
		digest = mult(bit32.lrotate(digest, 11), PRIME_1)
	end

	digest = mult(bit32.bxor(digest, bit32.rshift(digest, 15)), PRIME_2)
	digest = mult(bit32.bxor(digest, bit32.rshift(digest, 13)), PRIME_3)
	digest = bit32.bxor(digest, bit32.rshift(digest, 16))

	return digest
end

return xxhash32
