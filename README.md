# Minecraft Dungeons - Simple Mod Folder Utility

A simple setup powered by PowerShell scripts for a quick, safe and easy way to manage your Minecraft Dungeons mod folder!

Usage/Installation
==================

1. Put this Folder (and ALLL it's contents) in a PERMENANT Place where you have Permisions to freely manage files
2. Change the Path in the "DungeonsDir.txt" Document to the Location of your Minecraft Dungeons Content Folder
3. Run "Patch.bat"
4. The game will now have shortened intro movies and now use the ~mods folder in this directory to load mods
5. DONE


Updating the Game / Repairing
=============================

Since the Minecraft Launcher Can't remove Symbolic Links... you can't simply just repair and run "Patch.bat", you have to do something a bit diffrent...

If Updating the Game:
---------------------
1. Run "Remove Patch.bat" to remove the symbolic link to "~mods"
2. Open the Minecraft Launcher
3. Run Repair
4. Wait for Repair to Finish
5. Close the Minecraft Launcher
6. Run "Patch.bat"
7. DONE

If Moving/Uninstalling the Patch:
---------------------
1. Run "Remove Patch.bat" to remove the symbolic link to "~mods"
2. Move the directory wherever it is you want to move it to
3. (OPTIONAL) Run "Patch.bat"
4. DONE


