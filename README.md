How do I make this gearswap lua work for me?

**Friendly reminder - READ THE COMMENTS IN THE LUA**

* Step 1 - Download the gearswap
* Step 2 - Ensure you have the latest GUI Version which can be found [here](https://github.com/Jyouya/GUI-lib)
* Step 3 - Extract GUI-lib and put all the files in the libs folder in gearswap. (The contents of the GUI folder stay in that folder and the folder goes into libs) windower4\addons\gearswap\libs
* Step 4 - Extra the SMN lua into your gearswap data folder. The Graphics folder needs to go in there as a folder that contains the SMN folder. the Smn.lua and gear.lua goes straight into the data folder
* Step 5 - Your character name isn't Skittylove, unless you stole mine!! Replace Skittylove with the name of your character in game (Spell it correctly!)
* Step 6 - The gearswap should load just fine at this point. If it doesn't you did something wrong. Try to repeat these steps again.
* Step 7 - Customize your gearsets. We probably don't share the same gear so swap into SMN-yourname-Gear.lua to see the sets you need to build for.
		If you have gear from another lua just copy and paste it into here. Otherwise you can just equip the gear on your charcter and type //gs export
		This will create a file in \gearswap\export that will contain the gear you had on (Excellent for getting augments) just simply copy and paste the gear into the gearsets.
		If this part doesn't make sense to you, ask a friend or look up some basic gearswap features. **Read the comments!**
* Step 8 - Fill in your Summoning skill values for your idle sets (Optional) near the idle section of the gear.lua I have added some instructions on how to do this.
* Step 9 - Customize the lua! This lua does a lot of cool stuff but you may not want some of the cool things or you may want them differently. In the setup() function I put a lot of comments on
		on things you can modify to make the gearswap more homey. Also if you go to the function define_macrosets() there is also instructions on how to customize the automated keybinds (If you choose to use them)
		This can be as simply as changing two values or as complicated as sifting through 10 different tables but you can get custom keybinds if you wish.
* Step 10 - Load the gearswap and use it!

Few Notes --

- I Highly recommend only changing values where I notate. Unless you know a good bit about lua, changing one incorrect thing may start throwing errors.
- If you mess it up though you can just redownload the lua and just extract the SMN.lua file, Gear.lua typically won't need to be replaced.
- The UI elements rely on packets functioning properly. When you start lagging some packets may start dropping. The Repair button is there incase something seems off (Macros not loading, hud doesn't swap).
- If you log in as SMN in a zone you plan on playing SMN in (Like you DC in dynamis) you will need to hit the Repair button when everything loads. This is because the game doesn't read your merits until everything loads.
The lua will automatically fix itself when you zone so you only need to worry about this if you log in and immeidately start doing SMN things. Even then the gearswap will just merit Bloodpacts will be grayed out (still usable) and will not
calculate gear properly.
- If you have any major problems or suggestions on how to make this lua better feel free to contact me at Lavi#8710 on discord -- Also did you **READ THE COMMENTS**?

Finally this lua wouldn't be possible without the hardwork and effort that Jyouya put into fine tuning the GUI library as well as greatly helping me sort out how to work some functions
Also thanks to Pergatory for providing their base lua as a solid starting point and Verda for inspiring me with their lua as well as showing me (through their gearswap) how do some informational functions
