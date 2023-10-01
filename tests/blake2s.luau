local blake2s = require("modules/blake2s/init")

local t = os.clock()
local startgc = gcinfo()

local hash = blake2s("abc", 32)
assert(hash == "508c5e8c327c14e2e1a72ba34eeb452f37458b209ed63a294d999b4c86675982", "(BLAKE2s) abc hash does not match")

assert(
	blake2s("", 32) == "69217a3079908094e11121d042354a7c1f55b6482ca1a51e1b250dfd1ed0eef9",
	"(BLAKE2s) empty hash does not match"
)
assert(
	blake2s("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq", 32)
		== "6f4df5116a6f332edab1d9e10ee87df6557beab6259d7663f3bcd5722c13f189",
	"(BLAKE2s) 448 bit alphabet hash does not match"
)
assert(
	blake2s(
		"abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu",
		32
	) == "358dd2ed0780d4054e76cb6f3a5bce2841e8e2f547431d4d09db21b66d941fc7",
	"(BLAKE2s) 896 bit alphabet hash does not match"
)
assert(
	blake2s("foo", 32) == "08d6cad88075de8f192db097573d0e829411cd91eb6ec65e8fc16c017edfdb74",
	"(BLAKE2s) foo hash does not match"
)
assert(
	blake2s("bar", 32) == "3d9f08067d69177f67c827ac12b23e06c23939813ec80fe347e2a9c2d29c9efd",
	"(BLAKE2s) bar hash does not match"
)
assert(
	blake2s("baz", 32) == "72e45eca20335d5aaf5d1315be9c894f13b72a7cfb08333c2db0446416917a85",
	"(BLAKE2s) baz hash does not match"
)
assert(
	blake2s("The Fitness-Gram Pacer Test is a multi-stage aerobic capacity test", 32)
		== "30c54a159664099dd262c2654dd7516a9af58b5a39e7e007cc98170f91ebe11b",
	"(BLAKE2s) Fitness-Gram hash does not match"
)

assert(
	blake2s(string.rep("!", 64), 32) == "c6eb166cd5e940868e35cbc55297913eef2975fee2d83be813a6ae66e15d5afc",
	"(BLAKE2s) block size hash does not match"
)

if true then
	local e = string.rep("e", 199999)
	local a = string.rep("a", 1e6)
	assert(
		blake2s(e, 32) == "c95a33f8b1fbc9d5c529fd791eb646e203dca4b648feecfebb1faf140bd14812",
		"(BLAKE2s) e hash does not match"
	)
	assert(
		blake2s(a, 32) == "bec0c0e6cde5b67acb73b81f79a67a4079ae1c60dac9d2661af18e9f8b50dfa5",
		"(BLAKE2s) million a hash does not match"
	)
end

print("Change in memory:", gcinfo() - startgc)
print("BLAKE2s tests completed. Took", os.clock() - t)
