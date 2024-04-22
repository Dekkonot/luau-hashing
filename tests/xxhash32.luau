local xxhash32 = require("../modules/xxhash32")

local t = os.clock()
local startgc = gcinfo()

assert(xxhash32("abc") == 0x32d153ff, "(XXH32) abc hash does not match")
-- 852579327
assert(xxhash32("abc", 0x32d153ff) == 0x9041e0d8, "(XXH32) abc hash with seed does not match")

assert(xxhash32("") == 0x02cc5d05, "(XXH32) empty hash does not match")
--46947589
assert(xxhash32("", 0x02cc5d05) == 0xf6114164, "(XXH32) empty hash with seed does not match")
assert(
	xxhash32("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq") == 0x89ea60c3,
	"(XXH32) 448 bit alphabet hash does not match"
)
--2313838787
assert(
	xxhash32("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq", 0x89ea60c3) == 0x404871e3,
	"(XXH32) 448 bit alphabet hash with seed does not match"
)
assert(
	xxhash32(
		"abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
	) == 0x590b4165,
	"(XXH32) 896 bit alphabet hash does not match"
)
-- 1493909861
assert(
	xxhash32(
		"abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu",
		0x590b4165
	) == 0xc033cd93,
	"(XXH32) 896 bit alphabet hash with seed does not match"
)
assert(xxhash32("foo") == 0xe20f0dd9, "(XXH32) foo hash does not match")
--3792637401
assert(xxhash32("foo", 0xe20f0dd9) == 0xf4d3f6c9, "(XXH32) foo hash with seed does not match")
assert(xxhash32("bar") == 0x41a22b2c, "(XXH32) bar hash does not match")
--1101146924
assert(xxhash32("bar", 0x41a22b2c) == 0x9ad4ead3, "(XXH32) bar hash with seed does not match")
assert(xxhash32("baz") == 0x9bab0987, "(XXH32) baz hash does not match")
--2611677575
assert(xxhash32("baz", 0x9bab0987) == 0x23af9b99, "(XXH32) baz hash with seed does not match")
assert(
	xxhash32("The Fitness-Gram Pacer Test is a multi-stage aerobic capacity test") == 0xbea696a7,
	"(XXH32) Fitness-Gram hash does not match"
)
--3198588583
assert(
	xxhash32("The Fitness-Gram Pacer Test is a multi-stage aerobic capacity test", 0xbea696a7) == 0x3c6ef7ed,
	"(XXH32) Fitness-Gram hash with seed does not match"
)
if true then
	local e = string.rep("e", 199999)
	local a = string.rep("a", 1e6)

	-- local t2 = os.clock()
	assert(xxhash32(e) == 0xb27dd558, "(XXH32) e hash does not match")
	--2994591064
	assert(xxhash32(e, 0xb27dd558) == 0x6174a9bd, "(XXH32) e hash with seed does not match")
	-- print(`e hash took {os.clock() - t2}`)

	-- t2 = os.clock()
	assert(xxhash32(a) == 0xe1155920, "(XXH32) million a hash does not match")
	--3776272672
	assert(xxhash32(a, 0xe1155920) == 0xc0c7beae, "(XXH32) million a hash with seed does not match")
	-- print(`million a hash took {os.clock() - t2}`)
end

print("Change in memory:", gcinfo() - startgc)
print("XXH32 tests completed. Took", os.clock() - t)
