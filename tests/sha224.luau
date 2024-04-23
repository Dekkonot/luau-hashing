local sha224 = require("../modules/sha224")

local t = os.clock()
local startgc = gcinfo()

local hash, digest = sha224("abc")
assert(hash == "23097d223405d8228642a477bda255b32aadbce4bda0b3f7e36c9da7", "(SHA-224) abc hash does not match")
assert(digest[1] == 0x23097d22, "(SHA-224) first word of abc hash was incorrect")
assert(digest[2] == 0x3405d822, "(SHA-224) second word of abc hash was incorrect")
assert(digest[3] == 0x8642a477, "(SHA-224) third word of abc hash was incorrect")
assert(digest[4] == 0xbda255b3, "(SHA-224) fourth word of abc hash was incorrect")
assert(digest[5] == 0x2aadbce4, "(SHA-224) fifth word of abc hash was incorrect")
assert(digest[6] == 0xbda0b3f7, "(SHA-224) sixth word of abc hash was incorrect")
assert(digest[7] == 0xe36c9da7, "(SHA-224) seventh word of abc hash was incorrect")
assert(digest[8] == nil, "(SHA-224) abc hash was not properly truncated")
assert(table.isfrozen(digest), "(SHA-224) returned digest of abc hash was not frozen")

assert(sha224("") == "d14a028c2a3a2bc9476102bb288234c415a2b01f828ea62ac5b3e42f", "(SHA-224) empty hash does not match")
assert(
	sha224("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
		== "75388b16512776cc5dba5da1fd890150b0c6455cb4f58b1952522525",
	"(SHA-224) 448 bit alphabet hash does not match"
)
assert(
	sha224(
		"abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
	) == "c97ca9a559850ce97a04a96def6d99a9e0e0e2ab14e6b8df265fc0b3",
	"(SHA-224) 896 bit alphabet hash does not match"
)
assert(sha224("foo") == "0808f64e60d58979fcb676c96ec938270dea42445aeefcd3a4e6f8db", "(SHA-224) foo hash does not match")
assert(sha224("bar") == "07daf010de7f7f0d8d76a76eb8d1eb40182c8d1e7a3877a6686c9bf0", "(SHA-224) bar hash does not match")
assert(sha224("baz") == "1846d1bd30922b6492a1a28bc940fd00efcd2d9bfb00e34e94bf8048", "(SHA-224) baz hash does not match")
assert(
	sha224("The Fitness-Gram Pacer Test is a multi-stage aerobic capacity test")
		== "795f46c7974e93ca25ba2abf56525c5a234563b43b774904bc25fd27",
	"(SHA-224) Fitness-Gram hash does not match"
)

assert(
	sha224("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
		== "fb0bd626a70c28541dfa781bb5cc4d7d7f56622a58f01a0b1ddd646f",
	"(SHA-224) 55 character a hash does not match"
)

assert(
	sha224(
		"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	) == "e000e6709d26667b631faa7fc1bd404eb4774003c5fb4f51a0184875",
	"(SHA-224) 119 character a hash does not match"
)

assert(
	sha224(
		"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	) == "4aeec1a49b2c1bc663abf2809b36faaa64359523d4f26d02dbc2cba3",
	"(SHA-224) 111 character a hash does not match"
)

assert(
	sha224(
		"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	) == "9da4e535cdffdbb7ee783ef7c6b61cbda7bcd4b15ce59d6ce5c2f099",
	"(SHA-224) 239 character a hash does not match"
)

if true then
	local e = string.rep("e", 199999)
	local a = string.rep("a", 1e6)
	assert(sha224(e) == "386146cd6a85d13e8d66b8131bbb6c61e08d84a514ae845c59c13fd0", "(SHA-224) e hash does not match")
	assert(
		sha224(a) == "20794655980c91d8bbb4c1ea97618a4bf03f42581948b2ee4ee7ad67",
		"(SHA-224) million a hash does not match"
	)
end

print("Change in memory:", gcinfo() - startgc)
print("SHA-224 tests completed. Took", os.clock() - t)
