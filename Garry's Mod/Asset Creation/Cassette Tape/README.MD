# Audio Cassette Tape
This was a weekend long project for a friend of mine who was developing a storytelling map for Garry's Mod. I created a cassette tape from scratch using measurements and references, then created its textures in Substance Painter under a student license. The end result was very satisfactory, though creating new labels for the cassette were quite tedious and time consuming to make. I answered this self-made problem by creating a python script that takes in some information about the label you'd like to make, then does basic image processing to create the desired label. After it is created it is converted into VTF (Valve Texture Format) and its corresponding VMT (Valve Material Format) for use in the game. All that is left that is manual work is adding these new material names to the `$skingroup` inside the model's `.qc` file.

## Note
As I am unsure of the copyright/license on some of this software, the following software will not be included in this repository, and it must be obtained before the authoring tool will work:
- [VTFCmd](https://web.archive.org/web/20191229074421/http://nemesis.thewavelength.net/index.php?p=40)
- [VCR OSD Monospaced Font](https://fontmeme.com/fonts/vcr-osd-mono-font/)

## Credits
- VTFCmd made by Ryan Gregg of "Nem's Tools"
- Xolonium Regular font made by [Severin Meyer](sev.dev/fonts/xolonium/)
- VCR OSD Monospace font made by [mrmanet](https://fontmeme.com/fonts/vcr-osd-mono-font/) on FontMeme.com

# Images
## Initial Test Run
![A screenshot of the early authoring tool, showing an audio cassette tape label texture with the label "#013, Deep Purple, Space Truckin'"](https://media.discordapp.net/attachments/966067005117587457/1051640034421395559/image.png?width=1380&height=671 "First successful run of the program, outputting a png file")

## Tape models
### LOD0
![An audio cassette tape with the label "#013, Deep Purple, Space Truckin'"](https://media.discordapp.net/attachments/966067005117587457/1051794875722514463/image.png "Full detail model of the cassette tape")
<br>
This version of the model has the fully detailed mesh and more complex inner geometry to show off to the player.

### LOD1
![An audio cassette tape with the label "#013, Deep Purple, Space Truckin'"](https://media.discordapp.net/attachments/966067005117587457/1051795057503645767/image.png "The first step down in model detail")
<br>
This is the first reduction of detail in the model, displayed at around 15 feet away from it. It removes much of the geometry and is just a rectangular prism with rounded edges. The texure does the heav lifting of disguising its reduced state.

### LOD2
![An audio cassette tape texture projected onto a rectangular prism, with the label "#013, Deep Purple, Space Truckin'"](https://media.discordapp.net/attachments/966067005117587457/1051795057855955004/image.png "The lowest detail model, shown at great distance")
<br>
This is the most efficient model to render at only 8 vertices. It is simply the texture projected onto a rectangular prism.

## In-game Screenshots
![An audio cassette tape with a lamp shown on it](https://media.discordapp.net/attachments/966067005117587457/1052019634401976400/image.png?width=760&height=671 "Finished model in game with a lamp shone on it to reveal the finer phong mask details")

![](https://cdn.discordapp.com/attachments/966067005117587457/1052020008651341845/image.png "A plate with the full cassette tape texture displayed on it, using the ambient sun lighting to show off finer details")
