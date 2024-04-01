MemoryPrinter = {
	log = function(self, event)
		print(string.format("%s - memory usage (%d bytes)", event, collectgarbage("count") * 1024))
	end,
}
MemoryPrinter:log("init")
