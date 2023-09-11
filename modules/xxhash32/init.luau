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

	local words = table.create(math.ceil(messageLen / 4))
	local leftover = messageLen % 4
	local n = 1
	for i = 1, messageLen - leftover, 4 do
		words[n] = string.unpack("<I4", message, i)
		n += 1
	end
	local wordC = 1

	local digest
	if messageLen >= 16 then
		-- We don't need to worry about overflow for addition here
		local accum1 = rSeed + PRIME_1 + PRIME_2
		local accum2 = rSeed + PRIME_2
		local accum3 = rSeed
		local accum4 = rSeed - PRIME_1
		for _ = 0, messageLen - 16, 16 do
			accum1 = mult(bit32.lrotate(accum1 + mult(words[wordC], PRIME_2), 13), PRIME_1)
			accum2 = mult(bit32.lrotate(accum2 + mult(words[wordC + 1], PRIME_2), 13), PRIME_1)
			accum3 = mult(bit32.lrotate(accum3 + mult(words[wordC + 2], PRIME_2), 13), PRIME_1)
			accum4 = mult(bit32.lrotate(accum4 + mult(words[wordC + 3], PRIME_2), 13), PRIME_1)
			wordC += 4
		end
		digest = bit32.lrotate(accum1, 1)
			+ bit32.lrotate(accum2, 7)
			+ bit32.lrotate(accum3, 12)
			+ bit32.lrotate(accum4, 18)
	else
		digest = (rSeed + PRIME_5) % 2 ^ 32
	end
	digest = (digest + messageLen) % 2 ^ 32

	for _ = wordC, n - 1 do
		digest += mult(words[wordC], PRIME_3)
		digest = mult(bit32.lrotate(digest, 17), PRIME_4)
		wordC += 1
	end

	for i = -leftover, -1 do
		digest += mult(string.byte(message, i), PRIME_5)
		digest = mult(bit32.lrotate(digest, 11), PRIME_1)
	end

	digest = mult(bit32.bxor(digest, bit32.rshift(digest, 15)), PRIME_2)
	digest = mult(bit32.bxor(digest, bit32.rshift(digest, 13)), PRIME_3)
	digest = bit32.bxor(digest, bit32.rshift(digest, 16))

	return digest
end

return xxhash32
