# Isofar Companion

## Introduction
Isofar Companion is an application designed to assist players during combat of *The Isofarian Guard* board game. This application is not affiliated with Sky Kingdom games. 
This application will allow players to track enemies statistics during combat (Health, Attack, Defense, AP values, Green Cubes, Blue Cubes etc..). 
It will also handle the enemy AI cards. 

By using this application players can forego using the Enemy Dashboards or Enemy Cards. This application is designed to make setup and bookkeeping of combat quicker.


## How to Install
The Application can be run from a website: [https://gavinctaylor.github.io/Isofar-Companion/index.html](https://gavinctaylor.github.io/Isofar-Companion/index.html) or downloaded. <br>To download:
- Mac OS: [https://github.com/gavinctaylor/Isofar-Companion/blob/main/project/Builds/MacOS/IsofarCompanion.dmg]
- Windows OS [https://github.com/gavinctaylor/Isofar-Companion/blob/main/project/Builds/Windows/IsofarCompanion.exe]
- Linux OS [https://github.com/gavinctaylor/Isofar-Companion/tree/main/project/Builds/Linux]
<br>Or check the 'Builds' folder of the project



## How To Populate Enemies
Players can populate enemies via 2 methods:
1. Automatically Populating Enemies
2. Manually Populating Enemies

Players can use either or both methods to populate enemies. Anytime an enemy populates in a specific position, it replaces any current enemy in that may be in that position.  


### Automatically Populating Enemies

1. Select Settings
2. Select the values for Chapter, Node, and Skulls from the drop-down menus
3. Select Populate Enemies

Note: Only Enemy Configurations from Chapters 1 and 2 are currently available

The appropriate Enemies will appear in their positions. If any enemies are already in those positions they will be replaced. If the combat is designated as an Ambush, this will appear at the top of the application (in Red).


### Manually Populating Enemies

1. Select Settings
2. Select the values for Enemy (name) Star Value, and Position
3. Select Add Enemy
4. (optional) This can be repeated to add additional enemies

The Enemy will appear in the position specified. If an enemy are already in that position it will be replaced. If you select an enemy configuration that does not exists (i.e. a 1 Star Corrupted Priest), a message will notify you that this enemy is not available.

Once enemies are populated their Name, Rewards, Initial Stat Values, and their 8 AI cards will be shuffled ready for drawing. 


## During Combat

### Adjusting Values

The following values can be adjusted:
- Health
- Defense
- Attack
- AP (Action Points)

This can be done by selecting the + or - buttons on either side of the value.

Blue Cubes and Green Cubes can be adjusted by using the appropriate Spinboxes

Chips can be added to enemies using their appropriate spinboxes. Chips are typically organized near the Stat they modify/affect.

### Controls ###
- Mouse Scroll Wheel = Zoom
- Hold Right Mouse Button = Pan

### Enemy Actions

Players can:
- Draw enemy AI Cards
- Decrease AP Value
  -   NOTE: The AP Value will continue to decrease until the Enemy has no more AP. IF an enemy has Green Cubes this WILL allow the Enemy AP to continue to the negative value of the number of Green Cubes.
  -   i.e. If an enemy has 3 AP and 2 Green Cubes, the player can decrease the AP value 5 times, from 3 to -2.
- Reset the AP value (once they have completed their actions) - Reset Button next to the Action Points 
- Reset the chips and Blue Cube Values - Reset Button under the Draw Enemy AI Card button
- Undo the most recent drawn card (This will allow players to view the next enemy AI Card)
- Shuffle the enemy AI Deck - Can be done at any time. The player will be notified when the number of remaining cards is zero.

For players who wish to track Chips on Enemies manually (by using the Enemy Stat card and the chips they pull from their bags), the Spinboxes for tracking chips can be removed. Select Settings and turn Chip Tracking Visibility to Off.   

## About
This app was built using the Godot Engine. All of the code is open source and available here on this GitHub. Feel free to fork or steal to make this version better, or a better version entirely.


## ChangeLog
- Dec 20 2024 - Bug fixes (Manual add creating wrong star value, +Health not working in position I), Added Camera Zoomo 
- Nov 23 2024 - Added Chapter 3 and Chapter 4


### Future Updates



Future Updates *may* include:
- Support to change default Positions so that III and IV are on the top row
- Support to move enemies once positioned
- Support for Locked / Spoiler Enemies


