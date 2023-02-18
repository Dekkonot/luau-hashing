--selene: allow(incorrect_standard_library_use)
local sha1 = require("src/init")

-- local t = os.clock()

local hash, digest = sha1("abc")
assert(hash == "a9993e364706816aba3e25717850c26c9cd0d89d", "(SHA-1) abc hash does not match")
assert(digest[1] == 0xa9993e36, "(SHA-1) first word of abc hash was incorrect")
assert(digest[2] == 0x4706816a, "(SHA-1) second word of abc hash was incorrect")
assert(digest[3] == 0xba3e2571, "(SHA-1) third word of abc hash was incorrect")
assert(digest[4] == 0x7850c26c, "(SHA-1) fourth word of abc hash was incorrect")
assert(digest[5] == 0x9cd0d89d, "(SHA-1) fifth word of abc hash was incorrect")
assert(table.isfrozen(digest), "(SHA-1) returned digest of abc hash was not frozen")

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

	-- local t2 = os.clock()
	assert(sha1(e) == "07fe6fab7549089cb7b256545b1f31fe7ed74207", "(SHA-1) e hash does not match")
	-- print(`e hash took {os.clock() - t2}`)

	-- t2 = os.clock()
	assert(sha1(a) == "34aa973cd4c4daa4f61eeb2bdbad27316534016f", "(SHA-1) million a hash does not match")
	-- print(`million a hash took {os.clock() - t2}`)
end

-- print("SHA-1 tests completed. Took", os.clock() - t)
