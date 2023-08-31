--!strict
--!optimize 2

--- Takes a u64 and returns it as an array of 8 bytes.
local function u64ToBytes(value: number): { number }
	if value < 2 ^ 32 then
        --stylua: ignore
		return 
            {0, 0, 0, 0,
            bit32.extract(value, 24, 8), bit32.extract(value, 16, 8), bit32.extract(value, 08, 8), bit32.extract(value, 00, 8),
        }
	else
		-- This is technically inefficient but since this function runs once
		-- per hash, it doesn't matter.
		return { string.unpack("BBBBBBBB", string.pack(">L", value)) }
	end
end

--- Preprocesses the message, making sure it has the right size and formatting
--- for hashing.
local function preprocess(message: string): { number }
	local initLen = #message
	local msgLen = initLen + 9
	local nullCount = 64 - msgLen % 64

	local data = table.create(msgLen + nullCount, 0x00)
	for i = 1, initLen do
		data[i] = string.byte(message, i)
	end
	data[initLen + 1] = 0x80

	local b = u64ToBytes(initLen * 8)
	table.move(b, 1, 8, initLen + nullCount + 2, data)

	-- assert(#data % 64 == 0, "SHA preprocessed message size was wrong")
	return data
end

--- Processes a single block of 80 bytes.
--- Accepts the digest table and the block.
--
-- This is currently where the bulk of execution takes place and represents
-- over half the runtime of the hashing. Any improvement would be welcome.
local function processBlock(digest: { number }, block: { number }): nil
	local a = digest[1]
	local b = digest[2]
	local c = digest[3]
	local d = digest[4]
	local e = digest[5]

	-- Unrolling these loops technically saves time but it's a trivial amount.
	-- Given how much of a maintenance hell it would be, I decided against it.
	local f, temp
	for t = 1, 20 do
		-- F(B,C,D) = CH(X,Y,Z) = ternary for bits
		-- e.g. if x_bit == 1 then bit = y_bit else bit = z_bit
		-- reference implemention, this is: (X AND Y) XOR ((NOT X) AND Z)
		-- However, the XOR is equivalent to addition if you don't carry
		-- Since we're using bit32 (which truncates), we don't carry.
		-- So we're left with:
		-- (X AND Y) + ((NOT X) AND Z)
		-- Also, NOT X is equivalent to -1 - X
		-- So we can drop another bitwise op:
		f = bit32.band(b, c) + bit32.band(-1 - b, d)
		temp = bit32.band(bit32.lrotate(a, 5) + f + e + 0x5A827999 + block[t])
		e, d, c, b, a = d, c, bit32.lrotate(b, 30), a, temp
	end
	for t = 21, 40 do
		f = bit32.bxor(b, c, d)
		temp = bit32.band(bit32.lrotate(a, 5) + f + e + 0x6ED9EBA1 + block[t])
		e, d, c, b, a = d, c, bit32.lrotate(b, 30), a, temp
	end
	for t = 41, 60 do
		f = bit32.bor(bit32.band(b, c), bit32.band(d, bit32.bor(b, c)))
		temp = bit32.band(bit32.lrotate(a, 5) + f + e + 0x8F1BBCDC + block[t])
		e, d, c, b, a = d, c, bit32.lrotate(b, 30), a, temp
	end
	for t = 61, 80 do
		f = bit32.bxor(b, c, d)
		temp = bit32.band(bit32.lrotate(a, 5) + f + e + 0xCA62C1D6 + block[t])
		e, d, c, b, a = d, c, bit32.lrotate(b, 30), a, temp
	end

	digest[1] += a
	digest[2] += b
	digest[3] += c
	digest[4] += d
	digest[5] += e

	return
end

--[=[
	Computes the SHA-1 hash for `message` and returns it.
	This function returns both a hexadecimal encoded string of the hash
	and returns a **read-only** table containing the five 32-bit integers
	that make up the hash.
	
	@param message -- The payload to compute the SHA-1 hash of
	@return string -- The computed SHA-1 hash as a string of hexadecimal digits
	@return {number} -- The computed SHA-1 hash as an array of 5 integers
]=]
local function sha1(message: string): (string, { number })
	local bytes = preprocess(message)

	local digest = {
		0x67452301,
		0xEFCDAB89,
		0x98BADCFE,
		0x10325476,
		0xC3D2E1F0,
	}

	local block = table.create(80)
	for i = 1, #bytes, 64 do
		local j = i
		for t = 1, 16 do
			block[t] = bit32.bor(
				bit32.lshift(bytes[j], 24),
				bit32.lshift(bytes[j + 1], 16),
				bit32.lshift(bytes[j + 2], 8),
				bytes[j + 3]
			)
			j += 4
		end

		-- Unrolled loop for initializing the block
		-- Unwieldy but it halves the amount of time this section takes
		--
		-- equivalent to this loop:
		-- for t = 17, 80 do
		-- 	block[t] = bit32.lrotate(bit32.bxor(block[t - 3], block[t - 8], block[t - 14], block[t - 16]), 1)
		-- end
		do
			block[17] = bit32.lrotate(bit32.bxor(block[14], block[9], block[3], block[1]), 1)
			block[18] = bit32.lrotate(bit32.bxor(block[15], block[10], block[4], block[2]), 1)
			block[19] = bit32.lrotate(bit32.bxor(block[16], block[11], block[5], block[3]), 1)
			block[20] = bit32.lrotate(bit32.bxor(block[17], block[12], block[6], block[4]), 1)
			block[21] = bit32.lrotate(bit32.bxor(block[18], block[13], block[7], block[5]), 1)
			block[22] = bit32.lrotate(bit32.bxor(block[19], block[14], block[8], block[6]), 1)
			block[23] = bit32.lrotate(bit32.bxor(block[20], block[15], block[9], block[7]), 1)
			block[24] = bit32.lrotate(bit32.bxor(block[21], block[16], block[10], block[8]), 1)
			block[25] = bit32.lrotate(bit32.bxor(block[22], block[17], block[11], block[9]), 1)
			block[26] = bit32.lrotate(bit32.bxor(block[23], block[18], block[12], block[10]), 1)
			block[27] = bit32.lrotate(bit32.bxor(block[24], block[19], block[13], block[11]), 1)
			block[28] = bit32.lrotate(bit32.bxor(block[25], block[20], block[14], block[12]), 1)
			block[29] = bit32.lrotate(bit32.bxor(block[26], block[21], block[15], block[13]), 1)
			block[30] = bit32.lrotate(bit32.bxor(block[27], block[22], block[16], block[14]), 1)
			block[31] = bit32.lrotate(bit32.bxor(block[28], block[23], block[17], block[15]), 1)
			block[32] = bit32.lrotate(bit32.bxor(block[29], block[24], block[18], block[16]), 1)
			block[33] = bit32.lrotate(bit32.bxor(block[30], block[25], block[19], block[17]), 1)
			block[34] = bit32.lrotate(bit32.bxor(block[31], block[26], block[20], block[18]), 1)
			block[35] = bit32.lrotate(bit32.bxor(block[32], block[27], block[21], block[19]), 1)
			block[36] = bit32.lrotate(bit32.bxor(block[33], block[28], block[22], block[20]), 1)
			block[37] = bit32.lrotate(bit32.bxor(block[34], block[29], block[23], block[21]), 1)
			block[38] = bit32.lrotate(bit32.bxor(block[35], block[30], block[24], block[22]), 1)
			block[39] = bit32.lrotate(bit32.bxor(block[36], block[31], block[25], block[23]), 1)
			block[40] = bit32.lrotate(bit32.bxor(block[37], block[32], block[26], block[24]), 1)
			block[41] = bit32.lrotate(bit32.bxor(block[38], block[33], block[27], block[25]), 1)
			block[42] = bit32.lrotate(bit32.bxor(block[39], block[34], block[28], block[26]), 1)
			block[43] = bit32.lrotate(bit32.bxor(block[40], block[35], block[29], block[27]), 1)
			block[44] = bit32.lrotate(bit32.bxor(block[41], block[36], block[30], block[28]), 1)
			block[45] = bit32.lrotate(bit32.bxor(block[42], block[37], block[31], block[29]), 1)
			block[46] = bit32.lrotate(bit32.bxor(block[43], block[38], block[32], block[30]), 1)
			block[47] = bit32.lrotate(bit32.bxor(block[44], block[39], block[33], block[31]), 1)
			block[48] = bit32.lrotate(bit32.bxor(block[45], block[40], block[34], block[32]), 1)
			block[49] = bit32.lrotate(bit32.bxor(block[46], block[41], block[35], block[33]), 1)
			block[50] = bit32.lrotate(bit32.bxor(block[47], block[42], block[36], block[34]), 1)
			block[51] = bit32.lrotate(bit32.bxor(block[48], block[43], block[37], block[35]), 1)
			block[52] = bit32.lrotate(bit32.bxor(block[49], block[44], block[38], block[36]), 1)
			block[53] = bit32.lrotate(bit32.bxor(block[50], block[45], block[39], block[37]), 1)
			block[54] = bit32.lrotate(bit32.bxor(block[51], block[46], block[40], block[38]), 1)
			block[55] = bit32.lrotate(bit32.bxor(block[52], block[47], block[41], block[39]), 1)
			block[56] = bit32.lrotate(bit32.bxor(block[53], block[48], block[42], block[40]), 1)
			block[57] = bit32.lrotate(bit32.bxor(block[54], block[49], block[43], block[41]), 1)
			block[58] = bit32.lrotate(bit32.bxor(block[55], block[50], block[44], block[42]), 1)
			block[59] = bit32.lrotate(bit32.bxor(block[56], block[51], block[45], block[43]), 1)
			block[60] = bit32.lrotate(bit32.bxor(block[57], block[52], block[46], block[44]), 1)
			block[61] = bit32.lrotate(bit32.bxor(block[58], block[53], block[47], block[45]), 1)
			block[62] = bit32.lrotate(bit32.bxor(block[59], block[54], block[48], block[46]), 1)
			block[63] = bit32.lrotate(bit32.bxor(block[60], block[55], block[49], block[47]), 1)
			block[64] = bit32.lrotate(bit32.bxor(block[61], block[56], block[50], block[48]), 1)
			block[65] = bit32.lrotate(bit32.bxor(block[62], block[57], block[51], block[49]), 1)
			block[66] = bit32.lrotate(bit32.bxor(block[63], block[58], block[52], block[50]), 1)
			block[67] = bit32.lrotate(bit32.bxor(block[64], block[59], block[53], block[51]), 1)
			block[68] = bit32.lrotate(bit32.bxor(block[65], block[60], block[54], block[52]), 1)
			block[69] = bit32.lrotate(bit32.bxor(block[66], block[61], block[55], block[53]), 1)
			block[70] = bit32.lrotate(bit32.bxor(block[67], block[62], block[56], block[54]), 1)
			block[71] = bit32.lrotate(bit32.bxor(block[68], block[63], block[57], block[55]), 1)
			block[72] = bit32.lrotate(bit32.bxor(block[69], block[64], block[58], block[56]), 1)
			block[73] = bit32.lrotate(bit32.bxor(block[70], block[65], block[59], block[57]), 1)
			block[74] = bit32.lrotate(bit32.bxor(block[71], block[66], block[60], block[58]), 1)
			block[75] = bit32.lrotate(bit32.bxor(block[72], block[67], block[61], block[59]), 1)
			block[76] = bit32.lrotate(bit32.bxor(block[73], block[68], block[62], block[60]), 1)
			block[77] = bit32.lrotate(bit32.bxor(block[74], block[69], block[63], block[61]), 1)
			block[78] = bit32.lrotate(bit32.bxor(block[75], block[70], block[64], block[62]), 1)
			block[79] = bit32.lrotate(bit32.bxor(block[76], block[71], block[65], block[63]), 1)
			block[80] = bit32.lrotate(bit32.bxor(block[77], block[72], block[66], block[64]), 1)
		end

		processBlock(digest, block)

		digest[1] %= 2 ^ 32
		digest[2] %= 2 ^ 32
		digest[3] %= 2 ^ 32
		digest[4] %= 2 ^ 32
		digest[5] %= 2 ^ 32
	end

	return string.format("%08x%08x%08x%08x%08x", digest[1], digest[2], digest[3], digest[4], digest[5]),
		table.freeze(digest)
end

return sha1
