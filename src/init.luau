local function u64ToBytes(value: number): { number }
	if value < 2 ^ 32 then
        --stylua: ignore
		return 
            {0, 0, 0, 0,
            bit32.extract(value, 24, 8), bit32.extract(value, 16, 8), bit32.extract(value, 08, 8), bit32.extract(value, 00, 8),
        }
	else
		--TODO find a better way
		local front = (value / 2 ^ 32) % 2 ^ 32
		local back = value % 2 ^ 32
        --stylua: ignore
		return {
            bit32.extract(front, 24, 8), bit32.extract(front, 16, 8), bit32.extract(front, 08, 8), bit32.extract(front, 00, 8),
            bit32.extract(back, 24, 8), bit32.extract(back, 16, 8), bit32.extract(back, 08, 8), bit32.extract(back, 00, 8),
        }
	end
end

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

	assert(#data % 64 == 0, "data size was wrong")
	return data
end

local function processBlock(digest: { number }, block: { number })
	local a = digest[1]
	local b = digest[2]
	local c = digest[3]
	local d = digest[4]
	local e = digest[5]

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
end

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
			block[t] = bit32.lshift(bytes[j], 24)
				+ bit32.lshift(bytes[j + 1], 16)
				+ bit32.lshift(bytes[j + 2], 8)
				+ bytes[j + 3]
			j += 4
		end

		for t = 17, 80 do
			block[t] = bit32.lrotate(bit32.bxor(block[t - 3], block[t - 8], block[t - 14], block[t - 16]), 1)
		end

		processBlock(digest, block)

		digest[1] %= 2 ^ 32
		digest[2] %= 2 ^ 32
		digest[3] %= 2 ^ 32
		digest[4] %= 2 ^ 32
		digest[5] %= 2 ^ 32
	end

	return string.format("%08x%08x%08x%08x%08x", table.unpack(digest))
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
