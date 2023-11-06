--!strict
--#selene: allow(incorrect_standard_library_use)

-- This is kind of a nightmare, but it gives intellisense without
-- having to disable type checking.
type Fs = typeof(require(".lune/.typedefs/fs"))
type Process = typeof(require(".lune/.typedefs/process"))

local fs = (require :: any)("@lune/fs") :: Fs
local process = (require :: any)("@lune/process") :: Process

-- TODO: Change the format of test outputs so that this isn't necessary
local function testInfo(msg: string): (string, string, string)
	local memory = string.match(msg, "^Change in memory:%s*(%d+)")
	local name, elapsed = string.match(msg, "([%w_%-]+) tests completed. Took%s*(%S+)%s*$")
	if not (memory and name and elapsed) then
		error("could not parse test output result!", 2)
	end
	return name, elapsed, memory
end

local tests = fs.readDir("tests")
local results = table.create(#tests)

local function runTests(options)
	local maxName, maxElapsed, maxMem = -1, -1, -1

	for i, testFile in fs.readDir("tests") do
		local test = process.spawn("luau", { "tests/" .. testFile, table.unpack(options) })
		if test.ok then
			local name, elapsed, memory = testInfo(test.stdout)
			maxName = math.max(maxName, #name)
			maxElapsed = math.max(maxElapsed, #elapsed)
			maxMem = math.max(maxMem, #memory)
			results[i] = { name, elapsed, memory }
		else
			error(`Test '{testFile}' failed!`, 2)
		end
	end
	local fmt = `Test %-{maxName}s  took %-{maxElapsed}s  [%-{maxMem}s byte change in memory]`
	for _, result in results do
		print(string.format(fmt, result[1], result[2], result[3]))
	end
end

print("Running standard tests...")
runTests({ "-O2" })
print()
print("Running codegen tests...")
runTests({ "-O2", "--codegen" })
