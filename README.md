# skynet_timer

一个为skynet框架写的定时器，全程只有一个skynet.timeout在运行

## How to use

##### 1.Require module

	require "timer"

##### 2.Register a class

Using:

	local t = timer:new()
	
	t:init()

	t:register(5, function()
		--callback
	end)

## Tips

	init可以传心跳的interval间隔，默认为1s
