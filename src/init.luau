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
		return { string.unpack("BBBBBBBB", string.pack("<L", value)) }
	end
end

--- Preprocesses the message, making sure it has the appropriate characteristics.
--- Accepts a single string and returns an array of bytes.
local function preprocess(message: string): { number }
	local initLen = #message
	local msgLen = initLen + 9
	local nullCount = 64 - msgLen % 64

	local data = table.create(msgLen + nullCount)
	for i = 1, initLen do
		data[i] = string.byte(message, i)
	end
	data[initLen + 1] = 0x80
	for i = 1, nullCount do
		data[initLen + i + 1] = 0x00
	end

	local b = u64ToBytes(initLen * 8)
	table.move(b, 1, 8, #data + 1, data)

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
		f = bit32.bxor(d, bit32.band(b, bit32.bxor(c, d)))
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
	Computes the SHA-1 hash for `message` and returns the hex-sequence of it.
	
	@param message -- The payload to compute the SHA-1 hash of
	@return string -- The computed SHA-1 hash
]=]
local function sha1(message: string): string
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

	return string.format("%08x%08x%08x%08x%08x", digest[1], digest[2], digest[3], digest[4], digest[5])
end

if true then
	local t = os.clock()

	assert(sha1("abc") == "a9993e364706816aba3e25717850c26c9cd0d89d", "(SHA-1) abc hash does not match")
	assert(sha1("") == "da39a3ee5e6b4b0d3255bfef95601890afd80709", "(SHA-1) empty hash does not match")
	assert(
		sha1("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq") == "84983e441c3bd26ebaae4aa1f95129e5e54670f1",
		"(SHA-1) 448 bit alphabet hash does not match"
	)
	assert(
		sha1(
			"abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
		) == "a49b2446a02c645bf419f995b67091253a04a259",
		"(SHA-1) 896 bit alphabet hash does not match"
	)
	assert(sha1("foo") == "0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33", "(SHA-1) foo hash does not match")
	assert(sha1("bar") == "62cdb7020ff920e5aa642c3d4066950dd1f01f4d", "(SHA-1) bar hash does not match")
	assert(sha1("baz") == "bbe960a25ea311d21d40669e93df2003ba9b90a2", "(SHA-1) baz hash does not match")
	assert(
		sha1("The Fitness-Gram Pacer Test is a multi-stage aerobic capacity test")
			== "fe32af74bc982dc5da23e54055f5515e948a10bd",
		"(SHA-1) Fitness-Gram hash does not match"
	)
	if true then
		local e = string.rep("e", 199999)
		local a = string.rep("a", 1e6)

		local t2 = os.clock()
		assert(sha1(e) == "07fe6fab7549089cb7b256545b1f31fe7ed74207", "(SHA-1) e hash does not match")
		print(`e hash took {os.clock() - t2}`)

		t2 = os.clock()
		assert(sha1(a) == "34aa973cd4c4daa4f61eeb2bdbad27316534016f", "(SHA-1) million a hash does not match")
		print(`million a hash took {os.clock() - t2}`)
	end

	print("SHA-1 tests completed. Took", os.clock() - t)
end

return sha1
