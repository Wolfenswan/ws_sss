Wolfenswan's Simple Spawn System for ArmA3
====
Wolfenswan [FA]: wolfenswanarps@gmail.com | folkarps.com

**INTRODUCTION**

My goal is to create a simple spawn system, aimed at two types of mission makers:

* Beginner mission makers who are not yet comfortable with SQF and prefer to mostly use the in-game editor.
* Intermediate to advanced mission makers who want to churn out small to medium sized missions on a regular basis and need a simple spawn system as foundation for their missions, allowing them to focus on building a mission around the set-pieces.

**FEATURES**

* Easy to use spawn system, with no need for SQF scripting or knowing class names.
* Currently supports spawning of the following groups: Hold, Patrol, Garrison, Ambush, Ambush-road
* All groups are either placed randomly in the selected area or focus on pre-placed "points of interest"

**SETUP & DOCUMENTANTION**

*Setting up the mission folder*

 Download the latest release of ws_sss. Unzip it to your missions folder (My Documents\<Arma 3 Profiles>\<profile>\Missions) and rename the folder to ws_sss.VR

  **I suggest opening the mission in the in-game editor and familiarize yourself with the various components**

*Implementing ws_sss into your mission*

1) Copy the ws_sss & ws_fnc folders into your mission.

2a) If description.ext is not present, copy description.ext from the ws_sss.VR folder into your mission.

2b) If description.ext is present, open it in a text editor. Find the entry ```class CfgFunctions``` and add ```#include "ws_fnc\config.hpp"``` after the ```{```. If ```class CfgFunctions``` is not present, simply add the entire ```class CfgFunctions``` block from the description.ext found inside the ws_sss.VR folder at the bottom of your description.ext.

3) In the in-game editor, copy the basic setup for ws_sss from the example mission into your own mission.

4) Execute ```[] execVM "ws_sss\ws_sss_init.sqf"``` at the bottom of your init.sqf to spawn AI at mission start.

