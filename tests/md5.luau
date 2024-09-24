local md5 = require("../modules/md5")

local t = os.clock()
local startgc = gcinfo()

local hash, digest = md5("abc")
assert(hash == "900150983cd24fb0d6963f7d28e17f72", "(MD5) abc hash does not match")
assert(digest[1] == 0x90015098, "(MD5) first word of abc hash was incorrect")
assert(digest[2] == 0x3cd24fb0, "(MD5) second word of abc hash was incorrect")
assert(digest[3] == 0xd6963f7d, "(MD5) third word of abc hash was incorrect")
assert(digest[4] == 0x28e17f72, "(MD5) fourth word of abc hash was incorrect")
assert(table.isfrozen(digest), "(MD5) returned digest of abc hash was not frozen")

assert(md5("") == "d41d8cd98f00b204e9800998ecf8427e", "(MD5) empty hash does not match")
assert(
	md5("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq") == "8215ef0796a20bcaaae116d3876c664a",
	"(MD5) 448 bit alphabet hash does not match"
)
assert(
	md5(
		"abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
	) == "03dd8807a93175fb062dfb55dc7d359c",
	"(MD5) 896 bit alphabet hash does not match"
)
assert(md5("foo") == "acbd18db4cc2f85cedef654fccc4a4d8", "(MD5) foo hash does not match")
assert(md5("bar") == "37b51d194a7513e45b56f6524f2d51f2", "(MD5) bar hash does not match")
assert(md5("baz") == "73feffa4b7f6bb68e44cf984c85f6e88", "(MD5) baz hash does not match")
assert(
	md5("The Fitness-Gram Pacer Test is a multi-stage aerobic capacity test") == "eaed1e8132c94f0fc9ae8fe181b2cd2c",
	"(MD5) Fitness-Gram hash does not match"
)

assert(
	md5("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa") == "ef1772b6dff9a122358552954ad0df65",
	"(MD5) 55 character a hash does not match"
)

assert(
	md5(
		"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	) == "8a7bd0732ed6a28ce75f6dabc90e1613",
	"(MD5) 119 character a hash does not match"
)

assert(
	md5(
		"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	) == "089f243d1e831c5879aa375ee364a06e",
	"(MD5) 111 character a hash does not match"
)

assert(
	md5(
		"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	) == "b7b40d64ffccebd78abcf522376b3aae",
	"(MD5) 239 character a hash does not match"
)

if true then
	local e = string.rep("e", 199999)
	local a = string.rep("a", 1e6)

	-- local t2 = os.clock()
	assert(md5(e) == "40015f794f5a3748aea71502c750033b", "(MD5) e hash does not match")
	-- print(`e hash took {os.clock() - t2}`)

	-- t2 = os.clock()
	assert(md5(a) == "7707d6ae4e027c70eea2a935c2296f21", "(MD5) million a hash does not match")
	-- print(`million a hash took {os.clock() - t2}`)
end

print("Change in memory:", gcinfo() - startgc)
print("MD5 tests completed. Took", os.clock() - t)
