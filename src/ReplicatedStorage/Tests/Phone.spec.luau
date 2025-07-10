return function()
	local Phone = require(game.ReplicatedStorage:WaitForChild("Source").ModuleScripts.Phone)

	Phone.init()

	describe("Initialization", function()
		it("should not error", function()
			expect(2).to.equal(2)
		end)
	end)
end
