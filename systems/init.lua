-- This could be significantly simplified, possibly as a loop in main?

local PATH = (...):gsub('%.init$', '')

require(PATH..".animation")
require(PATH..".draw")
require(PATH..".hang")
require(PATH..".input")
require(PATH..".physics")
require(PATH..".player_physics")
require(PATH..".spider")
