--!strict
--!optimize 2

--- The initial values used for the hasher state.
local IV = { 0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A, 0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19 }

--- A list of offsets to use for each round in the compression algorithm.
local SIGMA = {
	{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
	{ 15, 11, 5, 9, 10, 16, 14, 7, 2, 13, 1, 3, 12, 8, 6, 4 },
	{ 12, 9, 13, 1, 6, 3, 16, 14, 11, 15, 4, 7, 8, 2, 10, 5 },
	{ 8, 10, 4, 2, 14, 13, 12, 15, 3, 7, 6, 11, 5, 1, 16, 9 },
	{ 10, 1, 6, 8, 3, 5, 11, 16, 15, 2, 12, 13, 7, 9, 4, 14 },
	{ 3, 13, 7, 11, 1, 12, 9, 4, 5, 14, 8, 6, 16, 15, 2, 10 },
	{ 13, 6, 2, 16, 15, 14, 5, 11, 1, 8, 7, 4, 10, 3, 9, 12 },
	{ 14, 12, 8, 15, 13, 2, 4, 10, 6, 1, 16, 5, 9, 7, 3, 11 },
	{ 7, 16, 15, 10, 12, 4, 1, 9, 13, 3, 14, 8, 2, 5, 11, 6 },
	{ 11, 3, 9, 5, 8, 7, 2, 6, 16, 12, 10, 15, 4, 13, 14, 1 },
}

--[=[
	Swaps the byte order of `n`. This is in effect changing the endianness
	of an integer.

	@param n The number to swap the byte order of.
	@return The endianness-swapped number.
]=]
local function byteswap(n: number): number
	return bit32.bor(
		bit32.lshift(n, 24),
		bit32.band(bit32.lshift(n, 8), 0xFF0000),
		bit32.band(bit32.rshift(n, 8), 0xFF00),
		bit32.rshift(n, 24)
	)
end

--[=[
	Mixes `x` and `y` into `v`, using the words located at
	`a`, `b`, `c`, and `d` in the vector.

	@param v A vector utilized internally for the state of the hasher
	@param a The location of a word in `v`
	@param b The location of a word in `v`
	@param c The location of a word in `v`
	@param d The location of a word in `v`
	@param x A word to mix into the vector using the provided locations
	@param y A word to mix into the vector using the provided locations
]=]
local function G(v: { number }, a, b, c, d, x, y)
	-- Addition would be MOD 2 ^ 32 but bit32 takes care of that :D
	v[a] += v[b] + x
	v[d] = bit32.rrotate(bit32.bxor(v[d], v[a]), 16)
	v[c] += v[d]
	v[b] = bit32.rrotate(bit32.bxor(v[b], v[c]), 12)
	v[a] += v[b] + y
	v[d] = bit32.rrotate(bit32.bxor(v[d], v[a]), 8)
	v[c] += v[d]
	v[b] = bit32.rrotate(bit32.bxor(v[b], v[c]), 7)
end

--[=[
	The BLAKE2S compression function.

	@param h The internal digest for the algorithm
	@param m A block of bytes utilized for rounds
	@param t A counter for how many bytes fed into the hasher so far, including this set
	@param f Whether or not this call is the final one
]=]
local function F(h: { number }, m: { number }, t: number, f: boolean)
	local v = table.create(16)
	for i = 1, 8 do
		v[i] = h[i]
		v[i + 8] = IV[i]
	end
	v[13] = bit32.bxor(v[13], t % 2 ^ 32)
	-- this is not using an rshift because `t` might be very big
	v[14] = bit32.bxor(v[14], math.floor(t / 2 ^ 32))
	if f then
		v[15] = bit32.bnot(v[15])
	end

	for _, s in SIGMA do
		G(v, 1, 5, 9, 13, m[s[1]], m[s[2]])
		G(v, 2, 6, 10, 14, m[s[3]], m[s[4]])
		G(v, 3, 7, 11, 15, m[s[5]], m[s[6]])
		G(v, 4, 8, 12, 16, m[s[7]], m[s[8]])

		G(v, 1, 6, 11, 16, m[s[9]], m[s[10]])
		G(v, 2, 7, 12, 13, m[s[11]], m[s[12]])
		G(v, 3, 8, 9, 14, m[s[13]], m[s[14]])
		G(v, 4, 5, 10, 15, m[s[15]], m[s[16]])
	end

	h[1] = bit32.bxor(h[1], v[1], v[1 + 8])
	h[2] = bit32.bxor(h[2], v[2], v[2 + 8])
	h[3] = bit32.bxor(h[3], v[3], v[3 + 8])
	h[4] = bit32.bxor(h[4], v[4], v[4 + 8])
	h[5] = bit32.bxor(h[5], v[5], v[5 + 8])
	h[6] = bit32.bxor(h[6], v[6], v[6 + 8])
	h[7] = bit32.bxor(h[7], v[7], v[7 + 8])
	h[8] = bit32.bxor(h[8], v[8], v[8 + 8])
end

--[=[
	Calculates the BLAKE2S hash of `message` and emits it as a hash of `outSize`
	bytes. If provided, `key` is used as a [pepper][Pepper] for the hash.

	@param message The string to perform the hashing algorithm on
	@param outSize The length of the returned value in bytes. Must be between 1 and 32.
	@param key A pepper to use when performing the hashing algorithm. Must be no longer than 32 bytes.

	@return The computed hash as a hexadecimal string. This string will be `outSize * 2` bytes long.

	[Pepper]: https://en.wikipedia.org/wiki/Pepper_(cryptography)
]=]
local function blake2s(message: string, outSize: number, key: string?): string
	local rKey = if key then key else ""
	local keyLen = #rKey

	assert(math.clamp(outSize, 1, 32) == outSize, "outSize must be in the range [1, 32]")
	assert(math.clamp(keyLen, 0, 32) == keyLen, "key length must be in the range [0, 32]")

	local h = table.clone(IV)
	h[1] = bit32.bxor(h[1], 0x0101_0000, bit32.lshift(keyLen, 8), outSize)

	local messageLen = #message
	local t = if keyLen > 0 then 64 else 0

	local block = table.create(16)
	if keyLen > 0 then
		-- This is technically bad for performance, but I don't really care
		-- since it happens at most once per hash
		rKey ..= string.rep("\0", -keyLen + 64)
		local j = 1
		for i = 1, 16 do
			local d, c, b, a = string.byte(rKey, j, j + 3)
			block[i] = bit32.bor(bit32.lshift(a, 24), bit32.lshift(b, 16), bit32.lshift(c, 8), d)
			j += 4
		end
		F(h, block, 64, false)
	end

	-- We have to process a final non-zero block, so if the number is a
	-- clean multiple of 64 we have to stop early.
	local finish = messageLen - messageLen % 64
	if messageLen % 64 == 0 then
		finish -= 64
	end

	for i = 1, finish, 64 do
		for j = 1, 16 do
			local d, c, b, a = string.byte(message, i, i + 3)
			block[j] = bit32.bor(bit32.lshift(a, 24), bit32.lshift(b, 16), bit32.lshift(c, 8), d)
			i += 4
		end
		t += 64
		F(h, block, t, false)
	end

	-- There's no way to tell the difference between a 0 length message and
	-- one that's exactly 64 bytes using the method we use, so it has to
	-- be special cased.
	if messageLen == 0 then
		for i = 1, 16 do
			block[i] = 0
		end
	else
		local finalMessage = table.concat({
			string.sub(message, -(messageLen - finish)),
			string.rep("\0", 64 - (messageLen - finish)),
		})
		local i = 1
		for j = 1, 16 do
			local d, c, b, a = string.byte(finalMessage, i, i + 3)
			block[j] = bit32.bor(bit32.lshift(a, 24), bit32.lshift(b, 16), bit32.lshift(c, 8), d)
			i += 4
		end
		t += messageLen - finish
	end
	F(h, block, t, true)

	-- TODO efficiency
	local digest = string.format(
		"%08x%08x%08x%08x%08x%08x%08x%08x",
		byteswap(h[1]),
		byteswap(h[2]),
		byteswap(h[3]),
		byteswap(h[4]),
		byteswap(h[5]),
		byteswap(h[6]),
		byteswap(h[7]),
		byteswap(h[8])
	)

	return string.sub(digest, 1, outSize * 2)
end

return blake2s
