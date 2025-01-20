extends Node

@export var mapWidth = 30
@export var mapHeight = 30
@export var startX = 0
@export var startY = 0
@export var endX = 0
@export var endY = 0
@export var currentX = 0
@export var currentY = 0
@export var map = []


var rng = RandomNumberGenerator.new()
#"┼": [Y+1, X+1, Y-1, X-1]
var rooms = {
	" ": [false, false, false, false],
	"┼": [true, true, true, true],
	"┴": [true, true, false, true],
	"┬": [false, true, true, true],
	"┤": [true, false, true, true],
	"├": [true, true, true, false],
	"─": [false, true, false, true],
	"│": [true, false, true, false],
	"┌": [false, true, true, false],
	"┐": [false, false, true, true],
	"└": [true, true, false, false],
	"┘": [true, false, false, true],
	"╵": [true, false, false, false],
	"╶": [false, true, false, false],
	"╷": [false, false, true, false],
	"╴": [false, false, false, true]
	#"": [true, true, true, true],
}

var neighbors = {
	" ": [[], [], [], []],
	"┼": [
		["┼", "┬", "┤", "├", "│", "┌", "┐", "╷"], 
		["┼", "┴", "┬", "┤", "─", "┐", "┘", "╴"], 
		["┼", "┴", "┤", "├", "│", "└", "┘", "╵"], 
		["┼", "┴", "┬", "├", "─", "┌", "└", "╶"]
		],
	"┴": [
		["┼", "┬", "┤", "├", "│", "┌", "┐", "╷"], 
		["┼", "┴", "┬", "┤", "─", "┐", "┘", "╴"], 
		[], 
		["┼", "┴", "┬", "├", "─", "┌", "└", "╶"]
		],
	"┬": [
		[], 
		["┼", "┴", "┬", "┤", "─", "┐", "┘", "╴"], 
		["┼", "┴", "┤", "├", "│", "└", "┘", "╵"], 
		["┼", "┴", "┬", "├", "─", "┌", "└", "╶"]
		],
	"┤": [
		["┼", "┬", "┤", "├", "│", "┌", "┐", "╷"], 
		[], 
		["┼", "┴", "┤", "├", "│", "└", "┘", "╵"], 
		["┼", "┴", "┬", "├", "─", "┌", "└", "╶"]
		],
	"├": [
		["┼", "┬", "┤", "├", "│", "┌", "┐", "╷"], 
		["┼", "┴", "┬", "┤", "─", "┐", "┘", "╴"], 
		["┼", "┴", "┤", "├", "│", "└", "┘", "╵"], 
		[]
		],
	"─": [
		[], 
		["┼", "┴", "┬", "┤", "─", "┐", "┘", "╴"], 
		[], 
		["┼", "┴", "┬", "├", "─", "┌", "└", "╶"]
		],
	"│": [
		["┼", "┬", "┤", "├", "│", "┌", "┐", "╷"], 
		[], 
		["┼", "┴", "┤", "├", "│", "└", "┘", "╵"], 
		[]
		],
	"┌": [
		[], 
		["┼", "┴", "┬", "┤", "─", "┐", "┘", "╴"], 
		["┼", "┴", "┤", "├", "│", "└", "┘", "╵"], 
		[]
		],
	"┐": [
		[], 
		[], 
		["┼", "┴", "┤", "├", "│", "└", "┘", "╵"], 
		["┼", "┴", "┬", "├", "─", "┌", "└", "╶"]
		],
	"└": [
		["┼", "┬", "┤", "├", "│", "┌", "┐", "╷"], 
		["┼", "┴", "┬", "┤", "─", "┐", "┘", "╴"], 
		[], 
		[]
		],
	"┘": [
		["┼", "┬", "┤", "├", "│", "┌", "┐", "╷"], 
		[], 
		[], 
		["┼", "┴", "┬", "├", "─", "┌", "└", "╶"]
		],
	"╵": [
		["┼", "┬", "┤", "├", "│", "┌", "┐"], 
		[], 
		[], 
		[]
		],
	"╶": [
		[], 
		["┼", "┴", "┬", "┤", "─", "┐", "┘"], 
		[], 
		[]
		],
	"╷": [
		[], 
		[], 
		["┼", "┴", "┤", "├", "│", "└", "┘"], 
		[]
		],
	"╴": [
		[], 
		[], 
		[], 
		["┼", "┴", "┬", "├", "─", "┌", "└"]
		],
}

func _ready() -> void:
	map = create_map(mapWidth, mapHeight)
	startX = mapWidth/2
	startY = mapHeight/2
	map[startY][startX] = '┼'
	currentX = startX
	currentY = startY
	
	generate(startY, startX)
	createEnd()
	
	#printer() #DEBUG
	#print("debug")

func generate(y, x):
	#printer()

	if rooms[map[y][x]][0]:
		#UP
		if map[y-1][x] == "" and !neighbors[map[y][x]][0].is_empty():
			var doWhile = true
			while doWhile:
				map[y-1][x] = neighbors[map[y][x]][0].pick_random()
				doWhile = !canNeighbor(y-1, x)
			generate(y-1,x)
	
	if rooms[map[y][x]][1]:
		#RIGHT
		if map[y][x+1] == "" and !neighbors[map[y][x]][1].is_empty():
			var doWhile = true
			while doWhile:
				map[y][x+1] = neighbors[map[y][x]][1].pick_random()
				doWhile = !canNeighbor(y, x+1)
			generate(y,x+1)
	
	if rooms[map[y][x]][2]:
		#DOWN
		if map[y+1][x] == "" and !neighbors[map[y][x]][2].is_empty():
			var doWhile = true
			while doWhile:
				map[y+1][x] = neighbors[map[y][x]][2].pick_random()
				doWhile = !canNeighbor(y+1, x)
			generate(y+1,x)
	
	if rooms[map[y][x]][3]:
		#LEFT
		if map[y][x-1] == "" and !neighbors[map[y][x]][3].is_empty():
			var doWhile = true
			while doWhile:
				map[y][x-1] = neighbors[map[y][x]][3].pick_random()
				doWhile = !canNeighbor(y, x-1)
			generate(y,x-1)

func createEnd():
	for y in map.size():
		for x in map[y].size():
			if map[y][x] == "":
				map[y][x] = " "
	
	var doWhile = true #DEBUG if false 
	while doWhile:
		var x = randi_range(0, mapWidth-1)
		var y = randi_range(0, mapHeight-1)
		if map[x][y] != " " and (x != startX and y != startY):
			endX = x
			endY = y
			doWhile = false

func create_map(w, h):
	var m = []
	
	for x in range(h):
		var line = []
		for i in range(w):
			line.append("")
		m.append(line)
	
	for x in range(h):
		m[x][0] = " "
		m[x][w-1] = " "
	
	for x in range(w):
		m[0][x-1] = " "
		m[h-1][x-1] = " "
	
	return m

func canNeighbor(y, x):
	var up = false
	var right = false
	var down = false
	var left = false
	
	if map[y-1][x] == "":
		up = true
	else:
		up = rooms[map[y][x]][0] == rooms[map[y-1][x]][2]
	
	if map[y][x+1] == "":
		right = true
	else:
		right = rooms[map[y][x]][1] == rooms[map[y][x+1]][3]
	
	if map[y+1][x] == "":
		down = true
	else:
		down = rooms[map[y][x]][2] == rooms[map[y+1][x]][0]
	
	if map[y][x-1] == "":
		left = true
	else:
		left = rooms[map[y][x]][3] == rooms[map[y][x-1]][1]
	
	return up and right and down and left

#DEBUG
func printer():
	for y in map.size():
		var s = ""
		for x in map[y].size():
			if map[y][x] == "":
				s = s + "■"
			else:
				s = s + map[y][x]
		print(s)
