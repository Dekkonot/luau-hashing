local sha512 = require("modules/sha512/init")

local t = os.clock()
local startgc = gcinfo()

local hash, digest = sha512("abc")
assert(
	hash
		== "ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f",
	"(SHA-512) abc hash does not match"
)
assert(digest[1] == 0xddaf35a1, "(SHA-512) front half of first word of abc hash was incorrect")
assert(digest[2] == 0x93617aba, "(SHA-512) back half of first word hash was incorrect")
assert(digest[3] == 0xcc417349, "(SHA-512) front half of second word of abc hash was incorrect")
assert(digest[4] == 0xae204131, "(SHA-512) back half of second word of abc hash was incorrect")
assert(digest[5] == 0x12e6fa4e, "(SHA-512) front half of third word of abc hash was incorrect")
assert(digest[6] == 0x89a97ea2, "(SHA-512) back half of third word of abc hash was incorrect")
assert(digest[7] == 0x0a9eeee6, "(SHA-512) front half of fourth word of abc hash was incorrect")
assert(digest[8] == 0x4b55d39a, "(SHA-512) back half of fourth word of abc hash was incorrect")
assert(digest[9] == 0x2192992a, "(SHA-512) front half of fifth word of abc hash was incorrect")
assert(digest[10] == 0x274fc1a8, "(SHA-512) back half of fifth word of abc hash was incorrect")
assert(digest[11] == 0x36ba3c23, "(SHA-512) front half of sixth word of abc hash was incorrect")
assert(digest[12] == 0xa3feebbd, "(SHA-512) back half of sixth word of abc hash was incorrect")
assert(digest[13] == 0x454d4423, "(SHA-512) front half of seventh word of abc hash was incorrect")
assert(digest[14] == 0x643ce80e, "(SHA-512) back half of seventh word of abc hash was incorrect")
assert(digest[15] == 0x2a9ac94f, "(SHA-512) front half of eighth word of abc hash was incorrect")
assert(digest[16] == 0xa54ca49f, "(SHA-512) back half of eighth word of abc hash was incorrect")
assert(table.isfrozen(digest), "(SHA-512) returned digest of abc hash was not frozen")

assert(
	sha512("")
		== "cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e",
	"(SHA-512) empty hash does not match"
)
assert(
	sha512("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
		== "204a8fc6dda82f0a0ced7beb8e08a41657c16ef468b228a8279be331a703c33596fd15c13b1b07f9aa1d3bea57789ca031ad85c7a71dd70354ec631238ca3445",
	"(SHA-512) 448 bit alphabet hash does not match"
)
assert(
	sha512(
		"abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
	)
		== "8e959b75dae313da8cf4f72814fc143f8f7779c6eb9f7fa17299aeadb6889018501d289e4900f7e4331b99dec4b5433ac7d329eeb6dd26545e96e55b874be909",
	"(SHA-512) 896 bit alphabet hash does not match"
)
assert(
	sha512("foo")
		== "f7fbba6e0636f890e56fbbf3283e524c6fa3204ae298382d624741d0dc6638326e282c41be5e4254d8820772c5518a2c5a8c0c7f7eda19594a7eb539453e1ed7",
	"(SHA-512) foo hash does not match"
)
assert(
	sha512("bar")
		== "d82c4eb5261cb9c8aa9855edd67d1bd10482f41529858d925094d173fa662aa91ff39bc5b188615273484021dfb16fd8284cf684ccf0fc795be3aa2fc1e6c181",
	"(SHA-512) bar hash does not match"
)
assert(
	sha512("baz")
		== "22b41602570746d784cef124fa6713eec180f93af02a1bfee05528e94a1b053e4136b446015161d04e9900849575bd8f95f857773868a205dbed42413cd054f1",
	"(SHA-512) baz hash does not match"
)
assert(
	sha512("The Fitness-Gram Pacer Test is a multi-stage aerobic capacity test")
		== "e6511df683e77e5233c274f41bc94892e96efbe20ee5abc763ebed33a7bb8c26c8c6d57ae31fb6b636f5431e4c33042c1c83563d60c5561a0de4fa6c4bbf15d4",
	"(SHA-512) Fitness-Gram hash does not match"
)

if true then
	local e = string.rep("e", 199999)
	local a = string.rep("a", 1e6)
	assert(
		sha512(e)
			== "954960c0efb4746f545ca84f52096a8748d909d8de6f9134c6fb1964f96dbbd9a89ffbd68c22ddb56ceaf7873fd11daf27a9e41b3797ab3edfcaa2d6e0ca0174",
		"(SHA-512) e hash does not match"
	)
	assert(
		sha512(a)
			== "e718483d0ce769644e2e42c7bc15b4638e1f98b13b2044285632a803afa973ebde0ff244877ea60a4cb0432ce577c31beb009c5c2c49aa2e4eadb217ad8cc09b",
		"(SHA-512) million a hash does not match"
	)
end

print("Change in memory:", gcinfo() - startgc)
print("SHA-512 tests completed. Took", os.clock() - t)
