local blake2b = require("../modules/blake2b")

local t = os.clock()
local startgc = gcinfo()

assert(
	blake2b("abc", 64)
		== "ba80a53f981c4d0d6a2797b69f12f6e94c212f14685ac4b74b12bb6fdbffa2d17d87c5392aab792dc252d5de4533cc9518d38aa8dbf1925ab92386edd4009923",
	"(BLAKE2b) abc hash does not match"
)


--stylua: ignore start
assert(blake2b("abc", 60) == "bdc0b8b38bd714f166d1cf227148c8de5a5ed75da184589212d8a584cccd73a02422f43c4dd1a427b8fbad742d348eb81d8cb7492efe626fce490618", "(BLAKE2b) 60 byte abc hash does not match")
assert(blake2b("abc", 56) == "13ee23af59cf24b95795d6417d2592f96d772eb6c4866e51698ecf6d4848539251ae2ee731a28758ecbcd5cb5f3f005c202f509cc32975b1", "(BLAKE2b) 56 byte abc hash does not match")
assert(blake2b("abc", 52) == "9a5803f1993120dfbf7af41936779ae2192dee216146b264e8080aae7dc602926e8d533565d775b43be548cb67c49aa7cde9e063", "(BLAKE2b) 52 byte abc hash does not match")
assert(blake2b("abc", 48) == "6f56a82c8e7ef526dfe182eb5212f7db9df1317e57815dbda46083fc30f54ee6c66ba83be64b302d7cba6ce15bb556f4", "(BLAKE2b) 48 byte abc hash does not match")
assert(blake2b("abc", 44) == "db1ccc0bf65b615c7269cf24b45ba65c665cb228ef77057ce4f9bec0b2821af9f9ffdd5441bd260ea1158084", "(BLAKE2b) 44 byte abc hash does not match")
assert(blake2b("abc", 40) == "8ad6d6166cdc8c2ffd5f25c5e7f957513b4a0e6661e998c3744a101363ac6e352858b0d412d5c322", "(BLAKE2b) 40 byte abc hash does not match")
assert(blake2b("abc", 36) == "b2b77f50103450a6aaed6b3b080dbe5bacde149c9587a0096149418264d1fee0b98dac2b", "(BLAKE2b) 36 byte abc hash does not match")
assert(blake2b("abc", 32) == "bddd813c634239723171ef3fee98579b94964e3bb1cb3e427262c8c068d52319", "(BLAKE2b) 32 byte abc hash does not match")
assert(blake2b("abc", 28) == "9bd237b02a29e43bdd6738afa5b53ff0eee178d6210b618e4511aec8", "(BLAKE2b) 28 byte abc hash does not match")
assert(blake2b("abc", 24) == "56a17e38cc371a46b12c32f18e0c61de2a84e9c2555b114e", "(BLAKE2b) 24 byte abc hash does not match")
assert(blake2b("abc", 16) == "cf4ab791c62b8d2b2109c90275287816", "(BLAKE2b) 16 byte abc hash does not match")
assert(blake2b("abc", 8) == "d8bb14d833d59559", "(BLAKE2b) 8 byte abc hash does not match")
assert(blake2b("abc", 4) == "63906248", "(BLAKE2b) 4 byte abc hash does not match")
assert(blake2b("abc", 2) == "ae1e", "(BLAKE2b) 2 byte abc hash does not match")
assert(blake2b("abc", 1) == "6b", "(BLAKE2b) 1 byte abc hash does not match")

-- No tricks up my sleeve: I'm pulling these keys from the hashes above

assert(blake2b("abc", 64, "ba80a53f981c4d0d6a2797b69f12f6e94c212f14685ac4b74b12bb6fdbffa2d1")
	== "c2f2d6db0908b89406dfd636c55abd50f31be6b13767a6258f61e476aca87416f876ce17bd336c3d3f6b6a2652f42b8480c3edd1ae66657f587f925b87ab8416", "(BLAKE2b) abc with 64 byte key hash does not match")
assert(blake2b("abc", 64, "bdc0b8b38bd714f166d1cf227148c8de5a5ed75da184589212d8a584cccd")
	== "0a1af64a08b611489317551c2fab679ee167f522063f185dd9401abb9a98168fa28020d7a630d8f95890a9cde3d3caaee40e925b6ef4fbc6bef19b982b7afb07", "(BLAKE2b) abc with 60 byte key hash does not match")
assert(blake2b("abc", 64, "13ee23af59cf24b95795d6417d2592f96d772eb6c4866e51698ecf6d")
	== "5898daa9ef3e553095d750fb92c53d531350abdae57b590cd319ecc6dc8d0a41370e063344505f0016bf59b09ba5b5282f68830f5bbb40f117c74bfb678d6a5d", "(BLAKE2b) abc with 56 byte key hash does not match")
assert(blake2b("abc", 64, "6f56a82c8e7ef526dfe182eb5212f7db9df1317e57815dbd")
	== "be0a08a35fa7bac9f2441b52d41abc0b19981a14f1161575e70c28c18a7154edd2fb764cb45f17e87bec23a22a3454266b03777fb770be817c59ff80e349cd86", "(BLAKE2b) abc with 48 byte key hash does not match")
assert(blake2b("abc", 64, "db1ccc0bf65b615c7269cf24b45ba65c665cb228ef77")
	== "6dda971e92cd392f866c7442b585ca16a3b8e7e052b0cff9ce2cb63db3cd0e9bf88b3f9379d83d0e00e800d791db9b95cc375a4958effc68135e7d84d4fb98e3", "(BLAKE2b) abc with 44 byte key hash does not match")
assert(blake2b("abc", 64, "8ad6d6166cdc8c2ffd5f25c5e7f957513b4a0e66")
	== "4bfd84ddcc52b007d929ce27feed940295fe37b8f6d28bd6ce101fd53a95bed870df7e2d88a4ac50bd7772d1b245af3d663cb6bdb6a8b1fa5eda24a859dc433d", "(BLAKE2b) abc with 40 byte key hash does not match")
assert(blake2b("abc", 64, "b2b77f50103450a6aaed6b3b080dbe5bacde")
	== "4d396810a9f4f1448f35f9de94610fc5067b44a3544fa746af327ccae319e7ea05b9f6d4705e1d668639db9ba636541ee582484528b6eb5310f8beff797a9e8a", "(BLAKE2b) abc with 36 byte key hash does not match")
assert(blake2b("abc", 64, "bddd813c634239723171ef3fee98579b")
	== "a9ac1196ebf670f73f4764fd2d820c5c40818423a6f333fff98a6bb159aa24b20da24f44929c66c401c8a1d06d5d0f4af97633f276fabeddde3ed810c2385039", "(BLAKE2b) abc with 32 byte key hash does not match")
assert(blake2b("abc", 64, "cf4ab791c62b8d2b")
	== "e1ca64e8abc97d6b08fade1e242f7c39340d74d4a9b0d3317ef9d2fbbf28a25a05fe83f4a7470e0220db8d1818f62029f57281d2aa608ebad9154a865ac2da70", "(BLAKE2b) abc with 16 byte key hash does not match")
assert(blake2b("abc", 64, "d8bb14d8")
	== "bde1a9f80f3c88258053723754fff9d5155a5694a34669f7892c6469c0b9db6019b56b97ec25fa6b82173318fc27b67caee576cacd21e61f312bb6ea3c49c414", "(BLAKE2b) abc with 8 byte key hash does not match")
assert(blake2b("abc", 64, "6390")
	== "bef63af934a11a46a647ca0496bd03844cd52206bcf6eb95e8d1e815f7ca30415461cbeb269bfd09b8652518253fe00bb614e854a3f55900486799b474807736", "(BLAKE2b) abc with 4 byte key hash does not match")
assert(blake2b("abc", 64, "ae")
	== "15cf17d6b18fcc83f2b4235492df9b98176ae9dba2de5b7ce29c8eb47b921fbbca7bd60ef779c437361a404090d30589626bf9d6edddf84027a7eef217c30bc5", "(BLAKE2b) abc with 2 byte key hash does not match")
assert(blake2b("abc", 64, "6")
	== "968ff3c3b73ad7825542c57d18f755ea5879894cf4ebd7a0720972ec627e563334f05c132cd62f3373b003564d7b87831f9fa306ae86b37ae9e8fe5977cc4836", "(BLAKE2b) abc with 1 byte key hash does not match")
--stylua: ignore end

assert(
	blake2b("", 64)
		== "786a02f742015903c6c6fd852552d272912f4740e15847618a86e217f71f5419d25e1031afee585313896444934eb04b903a685b1448b755d56f701afe9be2ce",
	"(BLAKE2b) empty hash does not match"
)
assert(
	blake2b("", 64, "786a02f742015903c6c6fd852552d272912f4740e15847618a86e217f71f5419")
		== "0532e878558d08b3586bb2771609976c0d7d521e23447086aff388ff65b2d643b11b180f894ded8fad97a1bf2c4ac48caf2234d85699e44a5c40187dea2c21f5",
	"(BLAKE2b) empty hash with key does not match"
)

assert(
	blake2b("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq", 64)
		== "7285ff3e8bd768d69be62b3bf18765a325917fa9744ac2f582a20850bc2b1141ed1b3e4528595acc90772bdf2d37dc8a47130b44f33a02e8730e5ad8e166e888",
	"(BLAKE2b) 448 bit alphabet hash does not match"
)
assert(
	blake2b(
		"abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
		64,
		"7285ff3e8bd768d69be62b3bf18765a325917fa9744ac2f582a20850bc2b1141"
	)
		== "e1988e2c9f4888f90e0d299a1f1ea651802c441edda1444931bad0e3f5cd0ad6840259504c54bf4bee74400ded9f7b9d824cdbbb354722b609cd8423c4e004de",
	"(BLAKE2b) 448 bit alphabet hash with key does not match"
)

assert(
	blake2b(
		"abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu",
		64
	)
		== "ce741ac5930fe346811175c5227bb7bfcd47f42612fae46c0809514f9e0e3a11ee1773287147cdeaeedff50709aa716341fe65240f4ad6777d6bfaf9726e5e52",
	"(BLAKE2b) 896 bit alphabet hash does not match"
)
assert(
	blake2b(
		"abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu",
		64,
		"ce741ac5930fe346811175c5227bb7bfcd47f42612fae46c0809514f9e0e3a11"
	)
		== "d64e6645fc551fcb490f6cdb97fc70679c02f38ede8ef9be5a65d2ea5fbd0e61581aada01a1af6986070659e3a4c7343f069d510aaf8246b30dd3290c8e03831",
	"(BLAKE2b) 896 bit alphabet hash with key does not match"
)

assert(
	blake2b("foo", 64)
		== "ca002330e69d3e6b84a46a56a6533fd79d51d97a3bb7cad6c2ff43b354185d6dc1e723fb3db4ae0737e120378424c714bb982d9dc5bbd7a0ab318240ddd18f8d",
	"(BLAKE2b) foo hash does not match"
)
assert(
	blake2b("foo", 64, "ca002330e69d3e6b84a46a56a6533fd79d51d97a3bb7cad6c2ff43b354185d6d")
		== "1863442c12970f0f698383d9c8b3864e852c01cb49dff1a4e4a7f0aea90ed73177caf460b7396aee9739c2d991e8666b232965633c2a78b548f3f7535de8d3b0",
	"(BLAKE2b) foo hash with key does not match"
)

assert(
	blake2b("bar", 64)
		== "76aafe37ce69887569c3c1a51f14b639191fb2180cb0c87b566529496636712868556a9adf069d59769bf7e2393d215f195d8e7694f26fc7e20d92195973add8",
	"(BLAKE2b) bar hash does not match"
)
assert(
	blake2b("bar", 64, "76aafe37ce69887569c3c1a51f14b639191fb2180cb0c87b5665294966367128")
		== "aee2742827f9eeb2270fa21a8b630c59633855886791b43021d70c6fd5c8d9c590a339c629c2653c6eb8959de89a4bdac2fbde208434a1d0b6c0f363c856927e",
	"(BLAKE2b) bar hash with key does not match"
)

assert(
	blake2b("baz", 64)
		== "2305476f21a28dd31ba7aaa4bcbd92780ff6c3ee77d45ea025dfec737e6bc725ce391585326dc22208f77c2643ca4afa34334042858a6f250e9094c8f77c82f6",
	"(BLAKE2b) baz hash does not match"
)
assert(
	blake2b("baz", 64, "2305476f21a28dd31ba7aaa4bcbd92780ff6c3ee77d45ea025dfec737e6bc725")
		== "cf757dd4a0cfec70bf13dcd160852845560b9b3e8ce8020348825dd0f0e29716a081d5703983646957008ac2f1f6fd043a9c47bfbb9480176eeddc6cb6ee1e4f",
	"(BLAKE2b) baz hash with key does not match"
)

assert(
	blake2b("The Fitness-Gram Pacer Test is a multi-stage aerobic capacity test", 64)
		== "7a17312276da3e41be9ef397aa035eadffe426afa70856d11155395f5af77932021e7db7995c536a86fbf9e840763f177d7bb2287c726a70b75494b018b6700c",
	"(BLAKE2b) Fitness-Gram hash does not match"
)
assert(
	blake2b(
		"The Fitness-Gram Pacer Test is a multi-stage aerobic capacity test",
		64,
		"7a17312276da3e41be9ef397aa035eadffe426afa70856d11155395f5af77932"
	)
		== "d4ad49ad88892b37a5067739e07d3af18fece632f023dd266a2027668b6628424d21cca8daa6fbffca724bb3e623526995a3a808e2e01553eda36e3ae2f74a8f",
	"(BLAKE2b) Fitness-Gram hash with key does not match"
)

assert(
	blake2b(string.rep("!", 128), 64)
		== "cc28dceb6925b2e02a177a961a0f819f464e3fa78c34be6117ea8ac6fbe02b58e6c91a1faf5605d3be43b23414a99c0322ada77a088f3454f980be1d3df68813",
	"(BLAKE2b) block size hash does not match"
)

assert(
	blake2b(string.rep("!", 128), 64, "cc28dceb6925b2e02a177a961a0f819f464e3fa78c34be6117ea8ac6fbe02b58")
		== "a58b0e2f33b9fac979f77a58e30031a0ae5ec6c8946180bb1e03aaacbed8e94585f26c62925d1877e341076cbd5ae0ece4ac114009af2b6cf0f9e3671626eae4",
	"(BLAKE2b) block size hash with key does not match"
)

if true then
	local e = string.rep("e", 199999)
	local a = string.rep("a", 1e6)
	assert(
		blake2b(e, 64)
			== "720d7925523d2ca4e39e11e91231890446abaffd09f5e69628b326e5ad0295a4c0335726da08fc56120e52f378042a8146e2e56f38187f33bd23e8ec42b88f35",
		"(BLAKE2b) e hash does not match"
	)
	assert(
		blake2b(e, 64, "720d7925523d2ca4e39e11e91231890446abaffd09f5e69628b326e5ad0295a4")
			== "9ac0a89038f6d3a82b681a8ad902e9c4e520b2597c7478184639084ce4ba5ab05c16f40859269a185837b208888cf870b4e2aa0d60e8a6cb0b1e2643b69d5526",
		"(BLAKE2b) e hash with key does not match"
	)

	assert(
		blake2b(a, 64)
			== "98fb3efb7206fd19ebf69b6f312cf7b64e3b94dbe1a17107913975a793f177e1d077609d7fba363cbba00d05f7aa4e4fa8715d6428104c0a75643b0ff3fd3eaf",
		"(BLAKE2b) million a hash does not match"
	)

	assert(
		blake2b(a, 64, "98fb3efb7206fd19ebf69b6f312cf7b64e3b94dbe1a17107913975a793f177e1")
			== "a01e874c2a19010ac02b16ea0eba0c03c434c00aeccb45fbe05b658111eff7dd254800b26c65819e420e4173e8731b4274a6561e3c7888db2d34cc488e315480",
		"(BLAKE2b) million a hash with key does not match"
	)
end

print("Change in memory:", gcinfo() - startgc)
print("BLAKE2b tests completed. Took", os.clock() - t)
