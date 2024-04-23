local sha384 = require("../modules/sha384")

local t = os.clock()
local startgc = gcinfo()

local hash, digest = sha384("abc")
assert(
	hash == "cb00753f45a35e8bb5a03d699ac65007272c32ab0eded1631a8b605a43ff5bed8086072ba1e7cc2358baeca134c825a7",
	"(SHA-384) abc hash does not match"
)
assert(digest[1] == 0xcb00753f, "(SHA-384) front half of first word of abc hash was incorrect")
assert(digest[2] == 0x45a35e8b, "(SHA-384) back half of first word hash was incorrect")
assert(digest[3] == 0xb5a03d69, "(SHA-384) front half of second word of abc hash was incorrect")
assert(digest[4] == 0x9ac65007, "(SHA-384) back half of second word of abc hash was incorrect")
assert(digest[5] == 0x272c32ab, "(SHA-384) front half of third word of abc hash was incorrect")
assert(digest[6] == 0x0eded163, "(SHA-384) back half of third word of abc hash was incorrect")
assert(digest[7] == 0x1a8b605a, "(SHA-384) front half of fourth word of abc hash was incorrect")
assert(digest[8] == 0x43ff5bed, "(SHA-384) back half of fourth word of abc hash was incorrect")
assert(digest[9] == 0x8086072b, "(SHA-384) front half of fifth word of abc hash was incorrect")
assert(digest[10] == 0xa1e7cc23, "(SHA-384) back half of fifth word of abc hash was incorrect")
assert(digest[11] == 0x58baeca1, "(SHA-384) front half of sixth word of abc hash was incorrect")
assert(digest[12] == 0x34c825a7, "(SHA-384) back half of sixth word of abc hash was incorrect")
assert(digest[13] == nil, "(SHA-384) abc hash was not properly truncated")
assert(digest[14] == nil, "(SHA-384) abc hash was not properly truncated")
assert(digest[15] == nil, "(SHA-384) abc hash was not properly truncated")
assert(digest[16] == nil, "(SHA-384) abc hash was not properly truncated")
assert(table.isfrozen(digest), "(SHA-384) returned digest of abc hash was not frozen")

assert(
	sha384("") == "38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b",
	"(SHA-384) empty hash does not match"
)
assert(
	sha384("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
		== "3391fdddfc8dc7393707a65b1b4709397cf8b1d162af05abfe8f450de5f36bc6b0455a8520bc4e6f5fe95b1fe3c8452b",
	"(SHA-384) 448 bit alphabet hash does not match"
)
assert(
	sha384(
		"abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
	) == "09330c33f71147e83d192fc782cd1b4753111b173b3b05d22fa08086e3b0f712fcc7c71a557e2db966c3e9fa91746039",
	"(SHA-384) 896 bit alphabet hash does not match"
)
assert(
	sha384("foo") == "98c11ffdfdd540676b1a137cb1a22b2a70350c9a44171d6b1180c6be5cbb2ee3f79d532c8a1dd9ef2e8e08e752a3babb",
	"(SHA-384) foo hash does not match"
)
assert(
	sha384("bar") == "14919aaff0da5efeb871fe8a438061c1996e88bfe199e2796b3b5c5c65714f61183adc53d48c3a32734ca6faf7d7fda8",
	"(SHA-384) bar hash does not match"
)
assert(
	sha384("baz") == "967004d25de4abc1bd6a7c9a216254a5ac0733e8ad96dc9f1ea0fad9619da7c32d654ec8ad8ba2f9b5728fed6633bd91",
	"(SHA-384) baz hash does not match"
)
assert(
	sha384("The Fitness-Gram Pacer Test is a multi-stage aerobic capacity test")
		== "7f72ed4ea5a1300eee1e9afdbca7e91cca65daf5f1f183cdc28b11e376c22503ee22d833c8c32f41624567f4517c02dd",
	"(SHA-384) Fitness-Gram hash does not match"
)

assert(
	sha384("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
		== "5d91ac7e74e62b5c728904b40f10784d66b7af9cb6302123e48c92f0432ceb8d2a92c02de77dcb29ed75c4b42bde46f4",
	"(SHA-384) 55 character a hash does not match"
)

assert(
	sha384(
		"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	) == "c2fbb1911d6889e3db556b482236ab82f3c736f00a22c088641a09fdbbca27e3f1e3b6235bad20aee1ca083c76ac590c",
	"(SHA-384) 119 character a hash does not match"
)

assert(
	sha384(
		"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	) == "3c37955051cb5c3026f94d551d5b5e2ac38d572ae4e07172085fed81f8466b8f90dc23a8ffcdea0b8d8e58e8fdacc80a",
	"(SHA-384) 111 character a hash does not match"
)

assert(
	sha384(
		"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	) == "e247c35f4bc1aa38026f8880c8c97305545d00d3f859e00c57d1c1f0a176b3c6b749c4eb081f08bd0fba500969cd056a",
	"(SHA-384) 239 character a hash does not match"
)

if true then
	local e = string.rep("e", 199999)
	local a = string.rep("a", 1e6)
	assert(
		sha384(e) == "69aa2eaa3de72baf7133d2554fe503bc325b63272461460f617a822541ebdc48c04422fe9b15b5d60795692b3126e61f",
		"(SHA-384) e hash does not match"
	)
	assert(
		sha384(a) == "9d0e1809716474cb086e834e310a4a1ced149e9c00f248527972cec5704c2a5b07b8b3dc38ecc4ebae97ddd87f3d8985",
		"(SHA-384) million a hash does not match"
	)
end

print("Change in memory:", gcinfo() - startgc)
print("SHA-384 tests completed. Took", os.clock() - t)
