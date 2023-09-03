local sha256 = require("modules/sha256/init")

local t = os.clock()
local startgc = gcinfo()

local hash, digest = sha256("abc")
assert(hash == "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad", "(SHA-256) abc hash does not match")
assert(digest[1] == 0xba7816bf, "(SHA-256) first word of abc hash was incorrect")
assert(digest[2] == 0x8f01cfea, "(SHA-256) second word of abc hash was incorrect")
assert(digest[3] == 0x414140de, "(SHA-256) third word of abc hash was incorrect")
assert(digest[4] == 0x5dae2223, "(SHA-256) fourth word of abc hash was incorrect")
assert(digest[5] == 0xb00361a3, "(SHA-256) fifth word of abc hash was incorrect")
assert(digest[6] == 0x96177a9c, "(SHA-256) sixth word of abc hash was incorrect")
assert(digest[7] == 0xb410ff61, "(SHA-256) seventh word of abc hash was incorrect")
assert(digest[8] == 0xf20015ad, "(SHA-256) eighth word of abc hash was incorrect")
assert(table.isfrozen(digest), "(SHA-256) returned digest of abc hash was not frozen")

assert(
	sha256("abc") == "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
	"(SHA-256) abc hash does not match"
)
assert(
	sha256("") == "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
	"(SHA-256) empty hash does not match"
)
assert(
	sha256("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
		== "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1",
	"(SHA-256) 448 bit alphabet hash does not match"
)
assert(
	sha256(
		"abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
	) == "cf5b16a778af8380036ce59e7b0492370b249b11e8f07a51afac45037afee9d1",
	"(SHA-256) 896 bit alphabet hash does not match"
)
assert(
	sha256("foo") == "2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae",
	"(SHA-256) foo hash does not match"
)
assert(
	sha256("bar") == "fcde2b2edba56bf408601fb721fe9b5c338d10ee429ea04fae5511b68fbf8fb9",
	"(SHA-256) bar hash does not match"
)
assert(
	sha256("baz") == "baa5a0964d3320fbc0c6a922140453c8513ea24ab8fd0577034804a967248096",
	"(SHA-256) baz hash does not match"
)
assert(
	sha256("The Fitness-Gram Pacer Test is a multi-stage aerobic capacity test")
		== "8509e3a2478a4b7fb712420a8bc4177c2271de6122b0d8bcb792c2ba4203a330",
	"(SHA-256) Fitness-Gram hash does not match"
)

if true then
	local e = string.rep("e", 199999)
	local a = string.rep("a", 1e6)
	assert(
		sha256(e) == "434cf81dca15a72777e811ed4ae9144f9272ca3c04ff9c2de1533bbbffed5449",
		"(SHA-256) e hash does not match"
	)
	assert(
		sha256(a) == "cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0",
		"(SHA-256) million a hash does not match"
	)
end

print("Change in memory:", gcinfo() - startgc)
print("SHA-256 tests completed. Took", os.clock() - t)
