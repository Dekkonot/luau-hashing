local blake2s = require("../modules/blake2s")

local t = os.clock()
local startgc = gcinfo()

assert(
	blake2s("abc", 32) == "508c5e8c327c14e2e1a72ba34eeb452f37458b209ed63a294d999b4c86675982",
	"(BLAKE2s) abc hash does not match"
)
assert(
	blake2s("abc", 32, "508c5e8c327c14e2e1a72ba34eeb452f")
		== "1e3ed5414ca157217cdf3d99bbdcdcd852f3239426d1fae9fcbc9c8224381a52",
	"(BLAKE2s) abc hash with key does not match"
)

assert(
	blake2s("abc", 24) == "1e2ed10fcdbc46e0ab3ea3f268a6c288083ae04e3d63a8de",
	"(BLAKE2s) 24 byte abc hash does not match"
)
assert(blake2s("abc", 16) == "aa4938119b1dc7b87cbad0ffd200d0ae", "(BLAKE2s) 16 byte abc hash does not match")
assert(blake2s("abc", 8) == "972e9d2cd6de6402", "(BLAKE2s) 8 byte abc hash does not match")
assert(blake2s("abc", 4) == "df7101d3", "(BLAKE2s) 4 byte abc hash does not match")
assert(blake2s("abc", 2) == "d8ce", "(BLAKE2s) 2 byte abc hash does not match")
assert(blake2s("abc", 1) == "0d", "(BLAKE2s) 1 byte abc hash does not match")

assert(
	blake2s("abc", 32, "972e9d2cd6de6402") == "4fa189d3cbc9d46f2ddf4d191ec7df1b4e7692fd86ac59baad9ec4142ac29aaa",
	"(BLAKE2s) abc hash with 16 byte key does not match"
)
assert(
	blake2s("abc", 32, "df7101d3") == "edc95d536a0c0b9246b7049da3f4c93d1107b408b979b907e0335a5c587b0098",
	"(BLAKE2s) abc hash with 8 byte key does not match"
)
assert(
	blake2s("abc", 32, "d8ce") == "414cd323f567172cbadcd550f44c6bc55401464890fa0558948669dda8001c0d",
	"(BLAKE2s) abc hash with 4 byte key does not match"
)
assert(
	blake2s("abc", 32, "0d") == "1320e01ea2e1a43455a1151b9b0b66b9e0080863548de404baf81e7b0683a1b1",
	"(BLAKE2s) abc hash with 2 byte key does not match"
)
assert(
	blake2s("abc", 32, "!") == "7eb68f58048d5338c25ed1bfb7fc1da7c2d081e085ee614166cbf04bc39097b8",
	"(BLAKE2s) abc hash with 1 byte key does not match"
)

assert(
	blake2s("", 32) == "69217a3079908094e11121d042354a7c1f55b6482ca1a51e1b250dfd1ed0eef9",
	"(BLAKE2s) empty hash does not match"
)
assert(
	blake2s("", 32, "69217a3079908094e11121d042354a7c")
		== "8406a898942510f828424cd7d4f72f41a64d9cda64ba05fd48a3f0dd829e1da0",
	"(BLAKE2s) empty hash with key does not match"
)

assert(
	blake2s("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq", 32)
		== "6f4df5116a6f332edab1d9e10ee87df6557beab6259d7663f3bcd5722c13f189",
	"(BLAKE2s) 448 bit alphabet hash does not match"
)
assert(
	blake2s("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq", 32, "6f4df5116a6f332edab1d9e10ee87df6")
		== "c45765e894725e81476fc92a1d9581a297e6ff8841512cc29f0a8057e0bf66d8",
	"(BLAKE2s) 448 bit alphabet hash with key does not match"
)

assert(
	blake2s(
		"abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu",
		32
	) == "358dd2ed0780d4054e76cb6f3a5bce2841e8e2f547431d4d09db21b66d941fc7",
	"(BLAKE2s) 896 bit alphabet hash does not match"
)
assert(
	blake2s(
		"abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu",
		32,
		"358dd2ed0780d4054e76cb6f3a5bce28"
	) == "de16ae3d2b7a991ce0dc8b159be527690e710bc8875161b997d9b0d5784ab0cf",
	"(BLAKE2s) 896 bit alphabet hash with key does not match"
)

assert(
	blake2s("foo", 32) == "08d6cad88075de8f192db097573d0e829411cd91eb6ec65e8fc16c017edfdb74",
	"(BLAKE2s) foo hash does not match"
)
assert(
	blake2s("foo", 32, "08d6cad88075de8f192db097573d0e82")
		== "069b70e4116be3b0e97d387cdda4f1d70a578e95245044b681cfe73e906b8735",
	"(BLAKE2s) foo hash with key does not match"
)

assert(
	blake2s("bar", 32) == "3d9f08067d69177f67c827ac12b23e06c23939813ec80fe347e2a9c2d29c9efd",
	"(BLAKE2s) bar hash does not match"
)
assert(
	blake2s("bar", 32, "3d9f08067d69177f67c827ac12b23e06")
		== "05bb25ef9904619c35082954770bb1930cd3d89e6d583b3d3d9bd2883a5d5b3c",
	"(BLAKE2s) bar hash with key does not match"
)

assert(
	blake2s("baz", 32) == "72e45eca20335d5aaf5d1315be9c894f13b72a7cfb08333c2db0446416917a85",
	"(BLAKE2s) baz hash does not match"
)
assert(
	blake2s("baz", 32, "72e45eca20335d5aaf5d1315be9c894f")
		== "6b67a68821709d1fe804225e0a921a069bdc3839ce32359fd46e82289d2987f9",
	"(BLAKE2s) baz hash with key does not match"
)

assert(
	blake2s("The Fitness-Gram Pacer Test is a multi-stage aerobic capacity test", 32)
		== "30c54a159664099dd262c2654dd7516a9af58b5a39e7e007cc98170f91ebe11b",
	"(BLAKE2s) Fitness-Gram hash does not match"
)
assert(
	blake2s(
		"The Fitness-Gram Pacer Test is a multi-stage aerobic capacity test",
		32,
		"30c54a159664099dd262c2654dd7516a"
	) == "3f9000a9abeae3e051df3df67158a31f040ec2f558853c11f1a18694bea4b9f6",
	"(BLAKE2s) Fitness-Gram hash with key does not match"
)

assert(
	blake2s(string.rep("!", 64), 32) == "c6eb166cd5e940868e35cbc55297913eef2975fee2d83be813a6ae66e15d5afc",
	"(BLAKE2s) block size hash does not match"
)
assert(
	blake2s(string.rep("!", 64), 32, "c6eb166cd5e940868e35cbc55297913e")
		== "141298c1c32245af1a0be43a1673830abb5e386f5dfb24c8fb9c37234782d392",
	"(BLAKE2s) block size hash with key does not match"
)

if true then
	local e = string.rep("e", 199999)
	local a = string.rep("a", 1e6)
	assert(
		blake2s(e, 32) == "c95a33f8b1fbc9d5c529fd791eb646e203dca4b648feecfebb1faf140bd14812",
		"(BLAKE2s) e hash does not match"
	)
	assert(
		blake2s(e, 32, "c95a33f8b1fbc9d5c529fd791eb646e2")
			== "aabcabcf10521774a73a11532649c23f8da9f05c5054e7cf7070efc23a670175",
		"(BLAKE2s) e hash with key does not match"
	)

	assert(
		blake2s(a, 32) == "bec0c0e6cde5b67acb73b81f79a67a4079ae1c60dac9d2661af18e9f8b50dfa5",
		"(BLAKE2s) million a hash does not match"
	)

	assert(
		blake2s(a, 32, "bec0c0e6cde5b67acb73b81f79a67a40")
			== "43ddf787fa4a73ab85039e5fe4d3a234a6282bf084f531c8fb39dfb4fed5cf70",
		"(BLAKE2s) million a hash with key does not match"
	)
end

print("Change in memory:", gcinfo() - startgc)
print("BLAKE2s tests completed. Took", os.clock() - t)
