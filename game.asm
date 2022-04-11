##################################################################### 
# 
# CSCB58 Winter 2022 Assembly Final Project 
# University of Toronto, Scarborough 
# 
# Student: Justin Wang, 1007187660, wang2111, justinx.wang@mail.utoronto.ca
# 
# Bitmap Display Configuration: 
# - Unit width in pixels: 8 (update this as needed)  
# - Unit height in pixels: 8 (update this as needed) 
# - Display width in pixels: 512 (update this as needed) 
# - Display height in pixels: 512 (update this as needed) 
# - Base Address for Display: 0x10008000 ($gp) 
# 
# Which milestones have been reached in this submission? 
# (See the assignment handout for descriptions of the milestones) 
# - Milestone 3
# 
# Which approved features have been implemented for milestone 3? 
# (See the assignment handout for the list of additional features) 
# 1. Score [2 marks]
# 2. Fail condition [1 mark]
# 3. Win condition [1 mark]
# 4. Moving platforms [2 marks]
# 5. Different levels [2 marks]
# 6. Mid-air dash! [2 or 3 marks]
# 7. Jet Pack [2 marks] 
# 
# Link to video demonstration for final submission: 
# - https://play.library.utoronto.ca/watch/a1211b681cb9c398d7c0964c08f96caf
# 
# Are you OK with us sharing the video with people outside course staff? 
# - yes, and please share this project github link as well!
# 
# Any additional information that the TA needs to know: 
# - Github project link: 
# https://github.com/JvstnX/CSCB58-Final-Project
# 
##################################################################### 
# Bitmap display starter code 
# 
# Bitmap Display Configuration: 
# - Unit width in pixels: 8           
# - Unit height in pixels: 8
# - Display width in pixels: 512 
# - Display height in pixels: 512 
# - Base Address for Display: 0x10008000 ($gp) 
.eqv  	BASE_ADDRESS		0x10008000 
.eqv	KEYPRESS_ADDRESS	0xFFFF0000
.eqv	SLEEP_TIME		40

# Colours
.eqv	TRANSPARENT	-1
.eqv	RED		0xFF0000
.eqv 	DARK_RED	0x2A0000
.eqv	ORANGE		0xDEA712
.eqv	YELLOW		0xD6F53D
.eqv	GREEN		0x00CC00
.eqv	DARK_GREEN	0x3F8839
.eqv	LIGHT_BLUE	0xC1E6E6
.eqv	BLUE		0x0089FF
.eqv	DARK_BLUE	0x040071
.eqv	LIGHT_PURPLE	0xB4A9D3
.eqv	PURPLE		0x8049C8
.eqv	DARK_PURPLE	0x3C008A
.eqv	BLACK		0x000000
.eqv	WHITE		0xFFFFFF

# Screen
.eqv	WIDTH 		64
.eqv	HEIGHT		64
.eqv	WIDTH_TIMES_4 	256
.eqv	HEIGHT_TIMES_4	256
.eqv 	UNIT_WIDTH 	8
.eqv	UNIT_HEIGHT	8
.eqv	AREA		4096
.eqv	AREA_TIMES_4	16384

# Platform
.eqv	PLATFORM_WIDTH	10
.eqv	PLATFORM_HEIGHT	1
.eqv	PLATFORM_INDICATOR		0
.eqv	BALLOON_PLATFORM_INDICATOR	1
.eqv	LEFT_MOVING_PLATFORM_INDICATOR	2
.eqv	RIGHT_MOVING_PLATFORM_INDICATOR	3
.eqv	BALLOON_PLATFORM_CHANCE		30
.eqv	MOVING_PLATFORM_CHANCE		7

# Sky Object
.eqv 	SKY_OBJECT_WIDTH	8
.eqv	SKY_OBJECT_HEIGHT	8
.eqv	SKY_OBJECT_X		52
.eqv	SKY_OBJECT_Y 		4

# Lava
.eqv	FIRE_WIDTH	4
.eqv	FIRE_HEIGHT	4

# Score
.eqv	SCORE_DIGIT_WIDTH	4
.eqv	SCORE_DIGIT_HEIGHT	5
.eqv 	SCORE_X			1
.eqv	SCORE_Y			1

# Balloon
.eqv	BALLOON_WIDTH		5
.eqv	BALLOON_HEIGHT		11
.eqv 	BALLOON_X_LEFT_OFFSET	2
.eqv	BALLOON_X_RIGHT_OFFSET	1

# Doodler
.eqv	DOODLER_WIDTH	8
.eqv	DOODLER_HEIGHT	8
.eqv	START_X		0
.eqv	START_Y		35

# Message
.eqv	GAME_OVER_WIDTH		32
.eqv	GAME_OVER_HEIGHT	16
.eqv	GAME_OVER_X		16
.eqv	GAME_OVER_Y		8
.eqv	GAME_WIN_WIDTH		24
.eqv	GAME_WIN_HEIGHT		16
.eqv	GAME_WIN_X		20
.eqv	GAME_WIN_Y		8

# Mechanics
.eqv 	LEFT_MOVEMENT		-1
.eqv	RIGHT_MOVEMENT		1
.eqv	UP_MOVEMENT		-1
.eqv	DOWN_MOVEMENT		1
.eqv	JUMP_HEIGHT		14
.eqv	DASH_DISTANCE		12
.eqv	DASH_SPEED		3
.eqv 	BALLOON_AIR_TIME	64
.eqv	BALLOON_CHANCE		20
.eqv	SCROLL_POINT		25
.eqv	STAGE_TWO_THRES		200	# 200
.eqv	STAGE_THREE_THRES	500	# 500
.eqv	MAX_SCORE		1000
.eqv	MAX_DIFFICULTY		2
.eqv	PLATFORM_HEIGHT_OFFSET	3

.data

colourArray: TRANSPARENT, RED, DARK_RED, ORANGE, YELLOW, GREEN, DARK_GREEN, LIGHT_BLUE, BLUE, DARK_BLUE, LIGHT_PURPLE, PURPLE, DARK_PURPLE, BLACK, WHITE

# Numbers
zeroBitmap:	.word	13, 13, 13, 0
		.word	13, 0, 13, 0
		.word	13, 0, 13, 0
		.word	13, 0, 13, 0
		.word	13, 13, 13, 0
		
oneBitmap:	.word	0, 13, 0, 0
		.word	13, 13, 0, 0
		.word	0, 13, 0, 0
		.word	0, 13, 0, 0
		.word	13, 13, 13, 0
		
twoBitmap:	.word	13, 13, 13, 0
		.word	0, 0, 13, 0
		.word	13, 13, 13, 0
		.word	13, 0, 0, 0
		.word	13, 13, 13, 0
		
threeBitmap:	.word	13, 13, 13, 0
		.word	0, 0, 13, 0
		.word	13, 13, 13, 0
		.word	0, 0, 13, 0
		.word	13, 13, 13, 0
		
fourBitmap:	.word	13, 0, 13, 0
		.word	13, 0, 13, 0
		.word	13, 13, 13, 0
		.word	0, 0, 13, 0
		.word	0, 0, 13, 0
		
fiveBitmap:	.word	13, 13, 13, 0
		.word	13, 0, 0, 0
		.word	13, 13, 13, 0
		.word	0, 0, 13, 0
		.word	13, 13, 13, 0
		
sixBitmap:	.word	13, 13, 13, 0
		.word	13, 0, 0, 0
		.word	13, 13, 13, 0
		.word	13, 0, 13, 0
		.word	13, 13, 13, 0
		
sevenBitmap:	.word	13, 13, 13, 0
		.word	0, 0, 13, 0
		.word	0, 0, 13, 0
		.word	0, 0, 13, 0
		.word	0, 0, 13, 0

eightBitmap:	.word	13, 13, 13, 0
		.word	13, 0, 13, 0
		.word	13, 13, 13, 0
		.word	13, 0, 13, 0
		.word	13, 13, 13, 0
		
nineBitmap:	.word	13, 13, 13, 0
		.word	13, 0, 13, 0
		.word	13,13, 13, 0
		.word	0, 0, 13, 0
		.word	13, 13, 13, 0

numberBitmapArray: zeroBitmap, oneBitmap, twoBitmap, threeBitmap, fourBitmap, fiveBitmap, sixBitmap, sevenBitmap, eightBitmap, nineBitmap

# Sky
daySkyBitmap:		.word	7:AREA
nightSkyBitmap:		.word	9:AREA
eclipseSkyBitmap:	.word	2:AREA
skyBitmapArray:	daySkyBitmap, nightSkyBitmap, eclipseSkyBitmap

# Sky Object
sunBitmap:	.word	3, 3, 0, 3, 3, 0, 3, 3
		.word	3, 0, 4, 4, 4, 4, 0, 3
		.word	0, 4, 4, 4, 4, 4, 4, 0
		.word	3, 4, 4, 4, 4, 4, 4, 3
		.word	3, 4, 4, 4, 4, 4, 4, 3
		.word	0, 4, 4, 4, 4, 4, 4, 0
		.word	3, 0, 4, 4, 4, 4, 0, 3
		.word	3, 3, 0, 3, 3, 0, 3, 3
		
moonBitmap:	.word	0, 0, 10, 14, 14, 14, 0, 0
		.word	0, 10, 14, 10, 0, 0, 10, 0
		.word	10, 14, 14, 0, 0, 0, 0, 0
		.word	14, 14, 14, 0, 0, 0, 0, 0
		.word	14, 14, 14, 0, 0, 0, 0, 0
		.word	10, 14, 14, 10, 0, 0, 0, 10
		.word	0, 10, 14, 14, 14, 14, 10, 0
		.word	0, 0, 10, 10, 10, 10, 0, 0

eclipseBitmap:	.word	0, 0, 3, 3, 3, 3, 0, 0
		.word	0, 3, 13, 13, 13, 13, 3, 0
		.word	3, 13, 13, 13, 13, 13, 13, 3
		.word	3, 13, 13, 13, 13, 13, 13, 3
		.word	3, 13, 13, 13, 13, 13, 13, 3
		.word	3, 13, 13, 13, 13, 13, 13, 3
		.word	0, 3, 13, 13, 13, 13, 3, 0
		.word	0, 0, 3, 3, 3, 3, 0, 0

skyObjectBitmapArray: sunBitmap, moonBitmap, eclipseBitmap

# Platform
platformBitmap:		.word	5:PLATFORM_WIDTH

balloonPlatformBitmap:	.word	1:PLATFORM_WIDTH

movingPlatformBitmap:	.word	8:PLATFORM_WIDTH
			
platformLocations:	.word	-1:HEIGHT

initialPlatformLocations:	.word	11, -1, -1, -1, -1, -1, -1, -1
				.word	21, -1, -1, -1, -1, -1, -1, -1
				.word	11, -1, -1, 51, -1, -1, -1, -1
				.word	1, -1, -1, -1, 41, -1, -1, -1
				.word	11, -1, -1, -1, -1, -1, -1, -1
				.word	21, -1, -1, -1, -1, -1, -1, -1
				.word	11, 35, 52, -1, -1, -1, -1, -1
				.word	1, -1, -1, -1, -1, -1, -1, -1	
				
# Lava
redFireBitmap:	.word	0, 0, 1, 0
		.word	0, 1, 3, 1
		.word	1, 3, 4, 3
		.word	3, 4, 4, 3
		
blueFireBitmap:	.word	0, 0, 8, 0
		.word	0, 8, 7, 8
		.word	8, 7, 14, 7
		.word	7, 14, 14, 7
		
purpleFireBitmap:	.word	0, 0, 12, 0
			.word	0, 12, 11, 12
			.word	12, 11, 10, 11
			.word	11, 10, 10, 11
		
fireBitmapArray: redFireBitmap, blueFireBitmap, purpleFireBitmap

# Balloon
balloonBitmapLeft:	.word	0, 1, 1, 1, 0
			.word	1, 1, 1, 1, 1
			.word	1, 1, 1, 1, 1
			.word	1, 1, 1, 1, 1
			.word	0, 1, 1, 1, 0
			.word	0, 0, 1, 0, 0
			.word	0, 0, 13, 0, 0
			.word	0, 0, 0, 13, 0
			.word	0, 0, 13, 0, 0
			.word	0, 13, 0, 0, 0
			.word	0, 0, 13, 0, 0

balloonBitmapRight:	.word	0, 1, 1, 1, 0
			.word	1, 1, 1, 1, 1
			.word	1, 1, 1, 1, 1
			.word	1, 1, 1, 1, 1
			.word	0, 1, 1, 1, 0
			.word	0, 0, 1, 0, 0
			.word	0, 0, 13, 0, 0
			.word	0, 13, 0, 0, 0
			.word	0, 0, 13, 0, 0
			.word	0, 0, 0, 13, 0
			.word	0, 0, 13, 0, 0

# Doodler
doodlerBitmapLeft:	.word	0, 0, 0, 4, 4, 4, 4, 0
			.word	0, 0, 4, 4, 4, 4, 4, 4
			.word	4, 0, 4, 13, 4, 13, 4, 4
			.word	4, 4, 4, 4, 4, 4, 4, 4
			.word	4, 0, 4, 4, 4, 4, 4, 4
			.word	0, 0, 6, 6, 6, 6, 6, 6
			.word	0, 0, 6, 6, 6, 6, 6, 6
			.word	0, 13, 0, 13, 0, 13, 0, 13

doodlerBitmapRight:	.word	0, 4, 4, 4, 4, 0, 0, 0
			.word	4, 4, 4, 4, 4, 4, 0, 0
			.word	4, 4, 13, 4, 13, 4, 0, 4
			.word	4, 4, 4, 4, 4, 4, 4, 4
			.word	4, 4, 4, 4, 4, 4, 0, 4
			.word	6, 6, 6, 6, 6, 6, 0, 0
			.word	6, 6, 6, 6, 6, 6, 0, 0
			.word	13, 0, 13, 0, 13, 0, 13, 0
			
doodlerX:		.word	0
doodlerY:		.word	0
facing:			.word	0	# 0 for left, 1 for right
onPlatform:		.word	0	# 0 for not on platform, 1 for on platform
airTimeLeft:		.word 	0
balloonAirTimeLeft:	.word	0
platformChance: 	.word	0	# lower = higher chance, 1 is guaranteed, max is JUMP_HEIGHT - 1
dashAvailable:		.word	0
dashDirection:		.word	0	# 0 for left, 1 for right
dashLeft:		.word	0

# Score
score:		.word 0
stage:		.word 0		# 0 for daytime, 1 for nighttime, 2 for eclipse

# Messages
gameOverBitmap:	.word	0, 0, 13, 13, 13, 13, 13, 0, 0, 0, 13, 13, 13, 0, 0, 0, 13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 13, 13, 13, 13, 13, 0
		.word	0, 13, 13, 0, 0, 0, 0, 0, 0, 13, 13, 0, 13, 13, 0, 0, 13, 13, 13, 0, 13, 13, 13, 0, 13, 13, 0, 0, 0, 0, 0, 0
		.word	13, 13, 0, 0, 0, 0, 0, 0, 13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 13, 13, 13, 13, 13, 0, 13, 13, 0, 0, 0, 0, 0, 0
		.word	13, 13, 0, 0, 13, 13 13, 0, 13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 13, 13, 13, 13, 13, 0, 13, 13, 13, 13, 13, 13, 0, 0
		.word	13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 13, 13, 13, 13, 13, 0, 13, 13, 0, 13, 0, 13, 13, 0, 13, 13, 0, 0, 0, 0, 0, 0
		.word	0, 13, 13, 0, 0, 13, 13, 0, 13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 0, 0, 0, 0, 0, 0
		.word	0, 0, 13, 13, 13, 13, 13, 0, 13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 13, 13, 13, 13, 13, 0
		.word	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		.word	0, 13, 13, 13, 13, 13, 0, 0, 13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 13, 13, 13, 13, 13, 0, 13, 13, 13, 13, 13, 13, 0, 0
		.word	13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 0, 0, 0, 0, 0, 0, 13, 13, 0, 0, 0, 13, 13, 0
		.word	13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 0, 0, 0, 0, 0, 0, 13, 13, 0, 0, 0, 13, 13, 0
		.word	13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 13, 0, 13, 13, 13, 0, 13, 13, 13, 13, 13, 13, 0, 0, 13, 13, 0, 0, 13, 13, 13, 0
		.word	13, 13, 0, 0, 0, 13, 13, 0, 0, 13, 13, 13, 13, 13, 0, 0, 13, 13, 0, 0, 0, 0, 0, 0, 13, 13, 13, 13, 13, 0, 0, 0
		.word	13, 13, 0, 0, 0, 13, 13, 0, 0, 0, 13, 13, 13, 0, 0, 0, 13, 13, 0, 0, 0, 0, 0, 0, 13, 13, 0, 13, 13, 13, 0, 0
		.word	0, 13, 13, 13, 13, 13, 0, 0, 0, 0, 0, 13, 0, 0, 0, 0, 13, 13, 13, 13, 13, 13, 13, 0, 13, 13, 0, 0, 13, 13, 13, 0
		.word	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		
gameWinBitmap:	.word	13, 13, 0, 0, 0, 13, 13, 0, 0, 13, 13, 13, 13, 13, 0, 0, 13, 13, 0, 0, 0, 13, 13, 0
		.word	13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 0, 0, 0, 13, 13, 0
		.word	13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 0, 0, 0, 13, 13, 0
		.word	0, 13, 13, 13 13, 13, 0, 0, 13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 0, 0, 0, 13, 13, 0
		.word	0, 0, 13, 13, 13, 0, 0, 0, 13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 0, 0, 0, 13, 13, 0
		.word	0, 0, 13, 13, 13, 0, 0, 0, 13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 0, 0, 0, 13, 13, 0
		.word	0, 0, 13, 13, 13, 0, 0, 0, 0, 13, 13, 13, 13, 13, 0, 0, 0, 13, 13, 13, 13, 13, 0, 0
		.word	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		.word	13, 13, 0, 0, 0, 13, 13, 0, 0, 13, 13, 13, 13, 13, 0, 0, 13, 13, 0, 0, 0, 13, 13, 0
		.word	13, 13, 0, 0, 0, 13, 13, 0, 0, 0, 13, 13, 13, 0, 0, 0, 13, 13, 13, 0, 0, 13, 13, 0
		.word	13, 13, 0, 0, 0, 13, 13, 0, 0, 0, 13, 13, 13, 0, 0, 0, 13, 13, 13, 13, 0, 13, 13, 0
		.word	13, 13, 0, 13, 0, 13, 13, 0, 0, 0, 13, 13, 13, 0, 0, 0, 13, 13, 13, 13, 13, 13, 13, 0
		.word	13, 13, 13, 13, 13, 13, 13, 0, 0, 0, 13, 13, 13, 0, 0, 0, 13, 13, 0, 13, 13, 13, 13, 0
		.word	13, 13, 13, 0, 13, 13, 13, 0, 0, 0, 13, 13, 13, 0, 0, 0, 13, 13, 0, 0, 13, 13, 13, 0
		.word	13, 13, 0, 0, 0, 13, 13, 0, 0, 13, 13, 13, 13, 13, 0, 0, 13, 13, 0, 0, 0, 13, 13, 0
		.word 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

# Display
displayBuffer:	.space	AREA_TIMES_4

# Strings
newLine: .asciiz "\n"

.text 

.globl main

# Reset the game
reset_game:
	# Save default values to variables
	li $t0, START_X
	sw $0, doodlerX
	
	li $t0, START_Y
	sw $t0, doodlerY
	
	sw $zero, facing
	
	sw $zero, onPlatform
	
	sw $zero, airTimeLeft
	
	sw $zero, balloonAirTimeLeft
	
	li $t0, 1
	sw $t0, dashAvailable
	
	sw $zero, dashDirection
	
	sw $zero, dashLeft
	
	sw $zero, score
	
	sw $zero, stage

	li $t0, JUMP_HEIGHT
	subi $t0, $t0, PLATFORM_HEIGHT_OFFSET
	sw $t0, platformChance	
	
	la $t0, platformLocations		# $t0 = address of platformLocations
	la $t1, initialPlatformLocations	# $t1 = address of initialPlatformLocations
	move $t2, $zero		# i = 0
	
for_i_in_initial_platforms:
	beq $t2, HEIGHT_TIMES_4, for_i_in_initial_platforms_exit	# if i == HEIGHT_TIMES_4
	
	add $t3, $t2, $t0	# $t3 = address of platformLocations[i]
	add $t4, $t2, $t1	# $t4 = address of initialPlatformLocations[i]
	
	li $t5, PLATFORM_INDICATOR
	lw $t4, 0($t4)		# $t4 = initialPlatformLocations[i]
	sb $t4, 0($t3)		# platformLocations[i] = initialPlatformLocations[i]
	sb $t5, 1($t3)
	
for_i_in_initial_platforms_update:
	addi $t2, $t2, 4
	j for_i_in_initial_platforms

for_i_in_initial_platforms_exit:

reset_game_exit:
	jr $ra

# Draw everything from display buffer to screen
draw_to_screen:
	la $t0, displayBuffer	# $t0 = address of displayBuffer
	
	move $t1, $zero		# i = 0
	
for_i_in_buffer:
	beq $t1, AREA_TIMES_4, for_i_in_buffer_exit	# if i == AREA
	
	add $t2, $t0, $t1			# $t2 = address of displayBuffer[i]
	addi $t3, $t1, BASE_ADDRESS		# $t3 = address of displayScreen[i]
	
	lw $t2, 0($t2)		# $t2 = displayBuffer[i]
	sw $t2, 0($t3)		# displayScreen[i] = displayBuffer[i]

for_i_in_buffer_update:
	addi $t1, $t1, 4	# i = i + 4
	j for_i_in_buffer	# loop back

for_i_in_buffer_exit:
	jr $ra

# Edit display buffer
draw_to_display_buffer:
	la $t0, displayBuffer	# $t0 = address of displayBuffer
	lw $t1, 0($sp)		# $t1 = bitmap address
	
	move $t2, $a0		# $t2 = x starting coordinate
	move $t3, $a1		# $t3 = y starting coordinate
	move $t4, $a2		# $t4 = width
	move $t5, $a3		# $t5 = height
	
	move $t8, $zero		# i = 0
	move $t9, $zero		# j = 0
	
for_i_in_bitmap:
	beq $t8, $t4, for_i_in_bitmap_exit	# if i == width
for_j_in_bitmap:
	beq $t9, $t5, for_j_in_bitmap_exit	# if j == height
	
	sll $t6, $t8, 2			# $t6 = i * 4
	sll $t7, $t9, 2			# $t7 = j * 4
	mul $t7, $t7, $t4		# $t7 = j * 4 * WIDTH
	add $t6, $t6, $t7		# $t6 = i * 4 + j * 4 * WIDTH
	add $t6, $t6, $t1		# $t6 = address of (i, j) in bitmap
	
	lw $t6, 0($t6)			# $t6 = index in colourArray of (i, j)
	sll $t6, $t6, 2			# $t6 = index in colourArray of (i, j) in bytes
	la $t7, colourArray		# $t7 = address of colourArray
	add $t7, $t7, $t6		# $t7 = address of colourArray code of (i, j)
	lw $s0, 0($t7)			# $s0 = colour code of (i, j)
	
	bltz $s0, for_j_in_bitmap_update	# if colour is transparent, skip any colouring
	
	add $s1, $t8, $t2		# $s1 = starting x + i
	add $s2, $t9, $t3		# $s2 = starting y + j
	sll $s1, $s1, 2			# $s1 = (starting x + i) * 4
	mul $s2, $s2, WIDTH_TIMES_4	# $s2 = (starting y + j) * WIDTH_TIMES_4
	add $s1, $s1, $s2		# $s1 = (starting x + i) * 4 + (starting y + j) * WIDTH_TIMES_4
	add $s1, $s1, $t0		# $s1 = displayBuffer[starting x + i][starting y + j]
	sw $s0, 0($s1)			# displayBuffer[starting x + i][starting y + j] = $s0
	
for_j_in_bitmap_update:
	addi $t9, $t9, 1	# j = j + 1
	j for_j_in_bitmap	# loop back

for_j_in_bitmap_exit:
	move $t9, $zero		# reset j = 0

for_i_in_bitmap_update:	
	addi $t8, $t8, 1	# i = i + 1
	j for_i_in_bitmap	# loop back
	
for_i_in_bitmap_exit:

draw_to_bitmap_exit:
	jr $ra

# Draw game over screen
draw_game_over:
	addi $sp, $sp, -8		# allocate space in stack
	sw $ra, 4($sp)			# save $ra to stack
	
	la $t0, gameOverBitmap		# $t0 = address of skyBitmapArray
	sw $t0, 0($sp)			# save $t0 to stack
	
	li $a0, GAME_OVER_X		# x starting coordinate
	li $a1,	GAME_OVER_Y		# y starting coordinate
	li $a2, GAME_OVER_WIDTH		# width
	li $a3, GAME_OVER_HEIGHT	# height
	
	jal draw_to_display_buffer

draw_game_over_exit:
	lw $ra, 4($sp)		# load $ra from stack 
	addi $sp, $sp, 8	# reclaim space in stack
	jr $ra
	
# Draw win screen
draw_game_win:
	addi $sp, $sp, -8		# allocate space in stack
	sw $ra, 4($sp)			# save $ra to stack
	
	la $t0, gameWinBitmap		# $t0 = address of skyBitmapArray
	sw $t0, 0($sp)			# save $t0 to stack
	
	li $a0, GAME_WIN_X		# x starting coordinate
	li $a1,	GAME_WIN_Y		# y starting coordinate
	li $a2, GAME_WIN_WIDTH		# width
	li $a3, GAME_WIN_HEIGHT	# height
	
	jal draw_to_display_buffer

draw_game_win_exit:
	lw $ra, 4($sp)		# load $ra from stack 
	addi $sp, $sp, 8	# reclaim space in stack
	jr $ra
	
# Draw sky
draw_sky:
	addi $sp, $sp, -8		# allocate space in stack
	sw $ra, 4($sp)			# save $ra to stack
	
	la $t0, skyBitmapArray		# $t0 = address of skyBitmapArray
	lw $t1, stage			# $t1 = stage
	sll $t1, $t1, 2
	add $t0, $t0, $t1		# $t0 - address of skyBitmapArray[stage]
	lw $t0, 0($t0)			# $t0 = skyBitmapArray[stage]
	sw $t0, 0($sp)			# save $t0 to stack
	
	move $a0, $zero		# x starting coordinate
	move $a1, $zero		# y starting coordinate
	li $a2, WIDTH		# width
	li $a3, HEIGHT		# height
	
	jal draw_to_display_buffer

draw_sky_exit:
	lw $ra, 4($sp)		# load $ra from stack 
	addi $sp, $sp, 8	# reclaim space in stack
	jr $ra
	
# Draw platforms
draw_platforms:
	addi $sp, $sp, -16	# allocate space in stack
	sw $ra, 12($sp)		# save $ra to stack
	
	la $t0, platformLocations	# $t0 = address of platformLocations
	move $t1, $zero 	# i = 0
	
for_i_in_platforms:
	beq $t1, HEIGHT, draw_platforms_exit	# if i == HEIGHT
	
	sll $t2, $t1, 2		# i = i * 4
	add $t2, $t2, $t0	# $t2 = address of platformLocations[i * 4]
	lb $t3, 0($t2)		# $t2 = platformLocations[i * 4]
	
	blt $t3, $zero, for_i_in_platforms_update	# if platformLocations[i * 4] < 0

if_platform_exists:
	move $a0, $t3			# x starting coordinate
	move $a1, $t1			# y starting coordinate
	li $a2, PLATFORM_WIDTH		# width
	li $a3, PLATFORM_HEIGHT		# height

	lb $t3, 1($t2)
	
	beq $t3, BALLOON_PLATFORM_INDICATOR, if_draw_balloon_platform
	beq $t3, LEFT_MOVING_PLATFORM_INDICATOR, if_draw_moving_platform
	beq $t3, RIGHT_MOVING_PLATFORM_INDICATOR, if_draw_moving_platform
	
	la $t3, platformBitmap		# $t3 = address of platformBitmap
	
	j draw_platform_continue

if_draw_balloon_platform:
	la $t3, balloonPlatformBitmap		# $t3 = address of balloonPlatformBitmap
	
	j draw_platform_continue

if_draw_moving_platform:
	la $t3, movingPlatformBitmap		# $t3 = address of movingPlatformBitmap

draw_platform_continue:
	sw $t0, 8($sp)			# save $t0 to stack
	sw $t1, 4($sp)			# save $t1 to stack
	sw $t3, 0($sp)			# save $t3 to stack
	
	jal draw_to_display_buffer
	
	lw $t0, 8($sp)			# $t0 = address of platformLocations
	lw $t1, 4($sp)			# $t1 = i

for_i_in_platforms_update:
	addi $t1, $t1, 1	# i = i + 1
	j for_i_in_platforms	# loop back
	
draw_platforms_exit:
	lw $ra, 12($sp)		# load $ra from stack
	addi $sp, $sp, 16	# reclaim space in stack
	jr $ra

# Draw sky objects
draw_sky_object:
	addi $sp, $sp, -8		# allocate space in stack
	sw $ra, 4($sp)			# save $ra to stack
	
	la $t0, skyObjectBitmapArray		# $t0 = address of skyObjectBitmapArray
	lw $t1, stage			# $t1 = stage
	sll $t1, $t1, 2
	add $t0, $t0, $t1		# $t0 - address of skyObjectBitmapArray[stage]
	lw $t0, 0($t0)			# $t0 = skyObjectBitmapArray[stage]
	sw $t0, 0($sp)			# save $t0 to stack
	
	li $a0, SKY_OBJECT_X		# x starting coordinate
	li $a1, SKY_OBJECT_Y		# y starting coordinate
	li $a2, SKY_OBJECT_WIDTH	# width
	li $a3, SKY_OBJECT_HEIGHT	# height
	
	jal draw_to_display_buffer

draw_sky_object_exit:
	lw $ra, 4($sp)		# load $ra from stack 
	addi $sp, $sp, 8	# reclaim space in stack
	jr $ra

# Draw fire
draw_fire:
	addi $sp, $sp, -12		# allocate space in stack
	sw $ra, 8($sp)			# save $ra to stack
	
	la $t0, fireBitmapArray		# $t0 = address of fireBitmapArray
	lw $t1, stage			# $t1 = stage
	sll $t1, $t1, 2
	add $t0, $t0, $t1		# $t0 - address of fireBitmapArray[stage]
	lw $t0, 0($t0)			# $t0 = fireBitmapArray[stage]
	sw $t0, 0($sp)			# save $t0 to stack
	
	li $t0, HEIGHT
	subi $t0, $t0, FIRE_HEIGHT	# $t0 = HEIGHT - FIRE_HEIGHT
	move $a1, $t0			# y starting coordinate
	li $a2, FIRE_WIDTH		# width
	li $a3, FIRE_HEIGHT		# height
	
	move $t1, $zero			# i = 0
	
for_i_in_fire:
	beq $t1, WIDTH, draw_fire_exit
	
	move $a0, $t1		# x starting coordinate
	sw $t1, 4($sp)		# save i to stack
	
	jal draw_to_display_buffer
	
	lw $t1, 4($sp)		# load i from stack
	
for_i_in_fire_update:
	addi $t1, $t1, 4
	j for_i_in_fire

draw_fire_exit:
	lw $ra, 8($sp)		# load $ra from stack 
	addi $sp, $sp, 12	# reclaim space in stack
	jr $ra
	
# Draw the score
draw_score:
	addi $sp, $sp, -24		# allocate space in stack
	sw $ra, 20($sp)			# save $ra to stack
	
	la $t0, numberBitmapArray	# $t0 = address of numberBitmapArray
	lw $t1, score			# $t1 = score
	
	li $a1, SCORE_Y			# y starting coordinate
	li $a2, SCORE_DIGIT_WIDTH	# width
	li $a3, SCORE_DIGIT_HEIGHT	# height
	
	li $t2, MAX_SCORE	# i = MAX_SCORE
	li $t3, SCORE_X			# j = SCORE_X
	
for_i_in_score:
	beqz $t2, draw_score_exit
	
	move $a0, $t3			# x starting coordinate
	
	div $t4, $t1, $t2		# $t4 = score / i
	sll $t5, $t4, 2			# $t5 = score / i * 4; the index in numberBitmapArray corresponding to score / i
	add $t5, $t5, $t0		# $t5 = address of numberBitmapArray[i]
	lw $t5, 0($t5)			# $t5 = numberBitmapArray[i]
	
	mul $t4, $t4, $t2		# $t4 = (score / i) * i
	sub $t1, $t1, $t4		# $t1 = score - (score / i) * i
	
	sw $t0, 16($sp)			# save address of numberBitmapArray to stack
	sw $t1, 12($sp)			# save score to stack
	sw $t2, 8($sp)			# save i to stack
	sw $t3, 4($sp)			# save j to stack
	sw $t5, 0($sp)			# save numberBitmapArray[i] to stack
	
	jal draw_to_display_buffer
	
	lw $t0, 16($sp)			# load address of numberBitmapArray from stack
	lw $t1, 12($sp)			# load score from stack
	lw $t2, 8($sp)			# load i from stack
	lw $t3, 4($sp)			# load j from stack
	
for_i_in_score_update:
	div $t2, $t2, 10		# i = i / 10
	add $t3, $t3, SCORE_DIGIT_WIDTH	# j = j + SCORE_WIDTH
	j for_i_in_score

draw_score_exit:
	lw $ra, 20($sp)		# load $ra from stack 
	addi $sp, $sp, 24	# reclaim space in stack
	jr $ra
	

# Draw the doodler
draw_doodler:
	addi $sp, $sp, -8	# allocate space in stack
	sw $ra, 4($sp)		# save $ra to stack
	
	lw $t0, doodlerX	# $t0 = doodlerX
	lw $t1, doodlerY	# $t1 = doodlerY
	lw $t2, facing		# $t2 = facing
	
	move $a0, $t0		# x starting coordiante
	move $a1, $t1		# y starting coordinate
	li $a2, DOODLER_WIDTH	# width
	li $a3, DOODLER_HEIGHT	# height
	
	beqz $t2, if_facing_left	# if facing == 0

if_facing_right:	
	la $t3, doodlerBitmapRight	# $t3 = address of doodlerBitmapRight
	
	j continue_draw_doodler		

if_facing_left:
	la $t3, doodlerBitmapLeft	# $t3 = address of doodlerBitmapLeft
	
continue_draw_doodler:
	sw $t3, 0($sp)			# save $t3 to stack
	jal draw_to_display_buffer

draw_doodler_exit:
	lw $ra, 4($sp)		# load $ra from stack
	addi $sp, $sp, 8	# reclaim space in stack
	jr $ra
	
# Draw balloon
draw_balloon:
	addi $sp, $sp, -8	# allocate space in stack
	sw $ra, 4($sp)		# save $ra to stack
	
	lw $t0, balloonAirTimeLeft
	beqz $t0, draw_balloon_exit
	
	lw $t0, doodlerX	# $t0 = doodlerX
	lw $t1, doodlerY	# $t1 = doodlerY
	lw $t2, facing		# $t2 = facing
	
	subi $a1, $t1, BALLOON_HEIGHT	# y starting coordinate
	li $a2, BALLOON_WIDTH		# width
	li $a3, BALLOON_HEIGHT		# height
	
	beqz $t2, if_balloon_facing_left	# if facing == 0

if_balloon_facing_right:	
	addi $a0, $t0, BALLOON_X_RIGHT_OFFSET	# x starting coordiante
	la $t3, balloonBitmapRight		# $t3 = address of balloonBitmapRight
	
	j continue_draw_balloon		

if_balloon_facing_left:
	addi $a0, $t0, BALLOON_X_LEFT_OFFSET	# x starting coordiante
	la $t3, balloonBitmapLeft		# $t3 = address of balloonBitmapLeft
	
continue_draw_balloon:
	sw $t3, 0($sp)			# save $t3 to stack
	jal draw_to_display_buffer
	
draw_balloon_exit:
	lw $ra, 4($sp)		# load $ra from stack
	addi $sp, $sp, 8	# reclaim space in stack
	jr $ra
	
# Handle dash
handle_dash:
	lw $t0, dashLeft
	beqz $t0, handle_dash_exit
	
	lw $t1, doodlerX
	
	lw $t2, dashDirection
	bgtz $t2, handle_dash_right
	
handle_dash_left:
	subi $t1, $t1, DASH_SPEED
	
	bltz $t1, out_of_bounds_left
	
	sw $t1, doodlerX
	
	subi $t0, $t0, DASH_SPEED
	sw $t0, dashLeft
	
	j handle_dash_exit
	
out_of_bounds_left:
	sw $zero, doodlerX
	sw $zero, dashLeft
	
	j handle_dash_exit

handle_dash_right:
	addi $t1, $t1, DASH_SPEED
	
	li $t2, WIDTH				# $t2 = WIDTH
	subi $t2, $t2, DOODLER_WIDTH		# $t2 = $t2 - DOODLER_WIDTH
	bgt $t1, $t2, out_of_bounds_right	# if $t1 + RIGHT_MOVEMENT > $t2 - DOODLER_WIDTH
	
	sw $t1, doodlerX
	
	subi $t0, $t0, DASH_SPEED
	sw $t0, dashLeft
	
	j handle_dash_exit

out_of_bounds_right:
	sw $t2, doodlerX
	sw $zero, dashLeft
	
handle_dash_exit:
	jr $ra
	
# Handle scrolling down
handle_scrolling:
	addi $sp, $sp, -8	# allocate space in stack
	sw $ra, 4($sp)		# save $ra to stack
	
	la $t0, platformLocations	# $t1 = address of platformLocations
	lw $t1, doodlerY		# $t1 = doodlerY
	
	bge $t1, SCROLL_POINT, handle_scrolling_exit # if doodlerY >= SCROLL_POINT
	
handle_scroll_down:	
	li $t2, HEIGHT_TIMES_4		# i = HEIGHT_TIMES_4

for_i_in_platform_scroll:
	beq $t2, $zero, for_i_in_platform_scroll_exit	# if i == 0
	
	add $t3, $t2, $t0	# $t3 = platformPositions[i]
	lw $t4, -4($t3)		# $t4 = platformPositions[i - 4]
	sw $t4, 0($t3)		# platformPositions[i] = platformPositions[i - 4]

for_i_in_platform_scroll_update:
	addi $t2, $t2, -4		# i = i - 4
	j for_i_in_platform_scroll	# loop back
	
for_i_in_platform_scroll_exit:
	addi $t1, $t1, 1		 
	sw $t1, doodlerY		# doodlerY = doodlerY + 1 (offset the height increase from scrolling down)
	
	lw $t1, score
	addi $t1, $t1, 1
	sw $t1, score
	
handle_scroll_down_exit:
	lb $t1, 4($t0)				
	bgez $t1, fi_generate_new_platform

	# Generate random number from 0 to platformChance
	li $v0, 42
	move $a0, $zero
	lw $a1, platformChance
	syscall
	move $t1, $a0
	
	lw $t2,	stage		# $t2 = difficultyScale
	li $t3, MAX_DIFFICULTY
	sub $t2, $t3, $t2
	bgt $t1, $t2, fi_generate_new_platform	# if $t1 > MAX_DIFFICULTY - stage

if_generate_new_platform:
	# Generate random number from 0 to WIDTH - PLATFORM_WIDTH
	li $v0, 42
	move $a0, $zero
	li $a1, SKY_OBJECT_X
	subi $a1, $a1, PLATFORM_WIDTH
	syscall
	move $t1, $a0
	
	sb $t1, 0($t0)		# platformLocations[0] = $t1
	
	li $t1, JUMP_HEIGHT		# $t1 = JUMP_HEIGHT
	subi $t1, $t1, PLATFORM_HEIGHT_OFFSET
	sw $t1, platformChance		# platformChance = JUMP_HEIGHT - PLATFORM_HEIGHT_OFFSET
	
	# Generate random number from 0 to balloonPlatformChance
	li $v0, 42
	move $a0, $zero
	li $a1, BALLOON_PLATFORM_CHANCE
	syscall
	move $t1, $a0
	
	beqz $t1, if_generate_balloon_platform

	# Generate random number from 0 to movingPlatformChance
	li $v0, 42
	move $a0, $zero
	li $a1, MOVING_PLATFORM_CHANCE
	syscall
	move $t1, $a0
	
	lw $t2, stage
	blt $t1, $t2, if_generate_moving_platform
	
	li $t2, PLATFORM_INDICATOR
	sb $t2, 1($t0)
	j handle_scrolling_exit
	
if_generate_balloon_platform:
	li $t2, BALLOON_PLATFORM_INDICATOR
	sb $t2, 1($t0)
	
	j handle_scrolling_exit

if_generate_moving_platform:
	li $t2, LEFT_MOVING_PLATFORM_INDICATOR
	sb $t2, 1($t0)
	
	j handle_scrolling_exit

fi_generate_new_platform:	
	li $t1, -1
	sb $t1, 0($t0)		# platformLocations[0] = -1
	
	lw $t1, platformChance	# $t1 = platformChance
	addi $t1, $t1, -1
	sw $t1, platformChance	# platformChance = platformChance - 1 
	
handle_scrolling_exit:
	lw $ra, 4($sp)		# load $ra from stack
	addi $sp, $sp, 8	# reclaim space in stack
	jr $ra
	
# Handle updating moving platforms
handle_moving_platforms:
	la $t0, platformLocations	# $t0 = address of platformLocations
	move $t1, $zero 	# i = 0
	
for_i_in_moving_platforms:
	beq $t1, HEIGHT, handle_moving_platforms_exit	# if i == HEIGHT
	
	sll $t2, $t1, 2		# i = i * 4
	add $t2, $t2, $t0	# $t2 = address of platformLocations[i * 4]
	lb $t3, 0($t2)		# $t2 = platformLocations[i * 4]
	
	blt $t3, $zero, for_i_in_moving_platforms_update	# if platformLocations[i * 4] < 0
	
	lb $t4, 1($t2)
	
	beq $t4, LEFT_MOVING_PLATFORM_INDICATOR, move_platform_left
	beq $t4, RIGHT_MOVING_PLATFORM_INDICATOR, move_platform_right
	
	j for_i_in_moving_platforms_update

move_platform_left:
	beqz $t3, change_to_right
	
	addi $t3, $t3, -1
	sb $t3, 0($t2)
	
	j for_i_in_moving_platforms_update

change_to_right:
	li $t5, RIGHT_MOVING_PLATFORM_INDICATOR
	sb $t5, 1($t2)
	j move_platform_right
	
move_platform_right:
	li $t5, SKY_OBJECT_X
	subi $t5, $t5, PLATFORM_WIDTH
	
	beq $t3, $t5 change_to_left
	
	addi $t3, $t3, 1
	sb $t3, 0($t2)
	
	j for_i_in_moving_platforms_update

change_to_left:
	li $t5, LEFT_MOVING_PLATFORM_INDICATOR
	sb $t5, 1($t2)
	j move_platform_left

for_i_in_moving_platforms_update:
	addi $t1, $t1, 1	# i = i + 1
	j for_i_in_moving_platforms	# loop back
	
handle_moving_platforms_exit:
	jr $ra
	
# Handle updating the stage
handle_stage:
	lw $t0, stage	# $t0 = stage
	lw $t1, score	# $t1 = score
	
	bge $t1, STAGE_THREE_THRES, update_to_stage_three	# if score >= STAGE_THREE_THRES
	bge $t1, STAGE_TWO_THRES, update_to_stage_two		# if score >= STAGE_TWO_THRES
	
	j handle_stage_exit
	
update_to_stage_two:
	beq $t0, 1, handle_stage_exit
	li $t2, 1
	sw $t2, stage
	
	j handle_stage_exit

update_to_stage_three:
	beq $t0, 2, handle_stage_exit
	li $t2, 2
	sw $t2, stage

handle_stage_exit:
	jr $ra

# Handle horizontal movement
handle_horizontal_movement:
	beq $a0, 0x61, handle_key_A	# if $a0 = 'a'
	beq $a0, 0x64, handle_key_D	# if $a0 = 'd'
	beq $a0, 0x6A, handle_key_J	# if $a0 = 'j'
	beq $a0, 0x6C, handle_key_L	# if $a0 = 'l
	beq $a0, 0x70, handle_key_P	# if $a0 = 'p'
	
	j handle_horizontal_movement_exit
	
handle_key_A:
	lw $t1, doodlerX		# $t1 = doodlerX
	addi $t1, $t1, LEFT_MOVEMENT	# $t1 = $t1 + LEFT_MOVEMENT
	
	blt $t1, $zero, handle_horizontal_movement_exit	# if $t1 + LEFT_MOVEMENT < 0
	
	sw $t1, doodlerX		# doodlerX = $t1
	sw $zero, facing		# facing = 0; Faces doodler left
	j handle_horizontal_movement_exit
	
handle_key_D:
	lw $t1, doodlerX		# $t1 = doodlerX
	addi $t1, $t1, RIGHT_MOVEMENT	# $t1 = $t1 + RIGHT_MOVEMENT
	
	li $t2, WIDTH				# $t2 = WIDTH
	subi $t2, $t2, DOODLER_WIDTH		# $t2 = $t2 - DOODLER_WIDTH
	bgt $t1, $t2, handle_horizontal_movement_exit	# if $t1 + RIGHT_MOVEMENT > $t2 - DOODLER_WIDTH
	
	sw $t1, doodlerX		# doodlerX = $t1
	li $t1, 1
	sw $t1, facing			# facing = 1; Faces doodler right
	j handle_horizontal_movement_exit
	
handle_key_J:
	lw $t0, dashAvailable
	beqz $t0, handle_horizontal_movement_exit
	
	sw $zero, dashDirection
	
	li $t0, DASH_DISTANCE
	sw $t0, dashLeft
	
	sw $zero, dashAvailable
	
	sw $zero, facing
	
	j handle_horizontal_movement_exit

handle_key_L:
	lw $t0, dashAvailable
	beqz $t0, handle_horizontal_movement_exit
	
	li $t0, 1
	sw $t0, dashDirection
	
	li $t0, DASH_DISTANCE
	sw $t0, dashLeft
	
	sw $zero, dashAvailable
	
	li $t0, 1
	sw $t0, facing			# facing = 1; Faces doodler right

	j handle_horizontal_movement_exit
	
handle_key_P:
	j main			# Reset

handle_horizontal_movement_exit:
	jr $ra
	
# Check collision with fire
handle_fire_collision:
	lw $t0, doodlerY
	addi $t0, $t0, DOODLER_HEIGHT
	li $t1, HEIGHT
	subi $t1, $t1, FIRE_HEIGHT	# $t0 = HEIGHT - FIRE_HEIGHT
	
	ble $t0, $t1, handle_fire_collision_exit
	
	j game_over

handle_fire_collision_exit:
	jr $ra

# Check collision with platform
check_platform_collisions:
	lw $t0, doodlerX		# $t0 = doodlerX
	lw $t1, doodlerY		# $t1 = doodlerY
	la $t2, platformLocations	# $t2 = address of platformLocations
	
	addi $t1, $t1, DOODLER_HEIGHT	# $t1 = $t1 + DOODLER_HEIGHT; Look at row beneath doodler
	sll $t3, $t1, 2			# $t3 = $t1 * 4
	add $t3, $t3, $t2		# $t3 = address of platformLocations[$t1 * 4]
	lb $t4, 0($t3)			# $t3 = platformLocations[$t1 * 4]
	
	blt $t4, $zero, fi_platform_exists_on_row	# if platformLocations[$t1 * 4] < 0

if_platform_exists_on_row:
	addi $t5, $t4, PLATFORM_WIDTH	# $t5 = platformLocations[$t1 * 4] + PLATFORM_WIDTH
	subi $t6, $t4, DOODLER_WIDTH	# $t6 = platformLocations[$t1 * 4] - DOODLER_WIDTH
	slt $t5, $t0, $t5		# $t5 = doodlerX < $t5
	sgt $t6, $t0, $t6		# $t6 = doodler X > $t6
	
	and $t4, $t5, $t6		# $t4 = $t5 & $t6
	
	beqz $t4, fi_platform_exists_on_row	# if $t3 == 0
	
	lb $t4, 1($t3)
	
	bne $t4, BALLOON_PLATFORM_INDICATOR, fi_balloon_platform
	
if_balloon_platform:
	li $t4, BALLOON_AIR_TIME
	sw $t4, balloonAirTimeLeft

fi_balloon_platform:
	li $t4, 1
	sw $t4, onPlatform		# onPlatform = 1
	j check_platform_collisions_exit
	
fi_platform_exists_on_row:
	move $t3, $zero		
	sw $t3, onPlatform	# onPlatform = 0
	
check_platform_collisions_exit:
	jr $ra

# Handle vertical movement
handle_vertical_movement:
	addi $sp, $sp, -8		# allocate space in stack
	sw $ra, 4($sp)			# save $ra to stack
	
	lw $t0, airTimeLeft		# $t0 = airTimeLeft
	lw $t1, doodlerY		# $t1 = doodlerY
	
	addi $t2, $t1, DOODLER_HEIGHT	# $t2 = doodlerY + DOODLER_HEIGHT
	
	bgt $t2, HEIGHT, main		# if doodlerY > HEIGHT
	
	lw $t2, balloonAirTimeLeft
	add $t3, $t0, $t2
	
	blez $t3, handle_falling	# if airTimeLeft <= 0
	
handle_rising:
	addi $t1, $t1, UP_MOVEMENT	# $t1 = doodlerY + UP_MOVEMENT
	sw $t1, doodlerY		# doodlerY = doodlerY + UP_MOVEMENT
	
	beqz $t2, handle_balloon_not_equiped
	
handle_balloon_equiped:
	addi $t2, $t2, -1
	sw $t2, balloonAirTimeLeft
	
	j handle_vertical_movement_exit

handle_balloon_not_equiped:
	addi $t0, $t0, -1		# $t0 = $t0 - 1
	sw $t0, airTimeLeft		# airTimeLeft = airTimeLeft - 1
	
	j handle_vertical_movement_exit
	
handle_falling:
	sw $t1, 0($sp)
	jal check_platform_collisions
	lw $t1, 0($sp)
	lw $t2, onPlatform			# $t1 = onPlatform
	beqz $t2, handle_falling_no_platform	# if onPlatform = 0

handle_falling_on_platform:
	lw $t0, balloonAirTimeLeft
	
	bgtz $t0, if_falling_on_balloon_platform

	li $t0, JUMP_HEIGHT		# $t0 =  JUMP_HEIGHT
	sw $t0, airTimeLeft		# airTimeLeft = JUMP_HEIGHT
	
	li $t0, 1
	sw $t0, dashAvailable
	
	j continue_falling_on_platform
	
if_falling_on_balloon_platform:
	sw $zero, airTimeLeft		# airTimeLeft = 0

continue_falling_on_platform:	
	addi $t1, $t1, UP_MOVEMENT	# $t1 = $t1 + UP_MOVEMENT
	sw $t1, doodlerY		# doodlerY = doodlerY + UP_MOVEMENT
	j handle_vertical_movement_exit

handle_falling_no_platform:
	addi $t1, $t1, DOWN_MOVEMENT	# $t1 = $t1 + DOWN_MOVEMENT
	sw $t1, doodlerY		# doodlerY = doodlerY + DOWN_MOVEMENT
		
handle_vertical_movement_exit:
	lw $ra, 4($sp)		# load $ra from stack
	addi $sp, $sp, 8	# reclaim space in stack
	jr $ra

# Handle keyboard inputs
handle_key_inputs:
	addi $sp, $sp, -4		# allocate space in stack
	sw $ra, 0($sp)			# save $ra to stack
	
	# Check for keyboard input
	la $t0, KEYPRESS_ADDRESS
	lw $t1, 0($t0)
	bne $t1, 1, handle_key_inputs_exit	# if $t0 != 1
	
	lw $a0, 4($t0)	# Load keyboard input into $t0
	
	jal handle_horizontal_movement
	
handle_key_inputs_exit:
	lw $ra, 0($sp)		# load $ra from stack
	addi $sp, $sp, 4	# reclaim space in stack
	jr $ra

main:	
	# Remember to add different difficulties with different sky colours
	# Maybe smaller platforms
	jal reset_game
	
main_loop:
	li $v0, 1
	lw $a0, platformChance
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	jal handle_key_inputs
	
	jal handle_vertical_movement
	
	jal handle_dash
	
	jal handle_fire_collision
	
	jal handle_stage
	
	jal handle_moving_platforms
	
	jal handle_scrolling
	
	jal draw_sky
	
	jal draw_platforms
	
	jal draw_sky_object
	
	jal draw_fire
	
	jal draw_score
	
	jal draw_doodler
	
	jal draw_balloon
	
	jal draw_to_screen
	
	jal check_game_win
	
	j main_loop
	
check_game_win:
	lw $t0, score
	bge $t0, MAX_SCORE, game_win
	
check_game_win_exit:
	jr $ra

game_win:
	jal draw_game_win
	
	jal draw_to_screen
	
	jal handle_key_inputs
	
	j game_win

game_over:
	jal draw_game_over
	
	jal draw_to_screen
	
	jal handle_key_inputs
	
	j game_over

end_game:
	li $v0, 10
	syscall
