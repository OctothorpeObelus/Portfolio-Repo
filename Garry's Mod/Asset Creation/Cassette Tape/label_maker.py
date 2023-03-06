from PIL import Image, ImageFont, ImageDraw
import numpy as np
import os

# Prompt user inputs
in_label_number = input('Input tape number: (0-100)\n> ')
label_author = input('Input author/group name:\n> ')
label_song_title = input('Input song title:\n> ')
in_color_label = input('Input the primary color of the tape\'s label strip as RGB, separated by spaces:\n> ')
in_color_bg = input('Input the background color of the tape as RGB, separated by spaces:\n> ')
in_color_numbers = input('Input the color of the number label as RGB, separated by spaces: (leave blank for white)\n> ')
in_color_text = input('Input the color of the text as RGB, separated by spaces: (leave blank for black)\n> ')

# Convert inputs into usable values
label_number = '#'
for i in range(3 - len(in_label_number)):
    label_number += '0'
label_number += in_label_number

color_label_arr = in_color_label.split(" ")
color_label = (color_label_arr[0], color_label_arr[1], color_label_arr[2])

color_bg_arr = in_color_bg.split(" ")
color_bg = (color_bg_arr[0], color_bg_arr[1], color_bg_arr[2])

if (in_color_numbers == ""):
    color_numbers = (255, 255, 255)
else:
    color_numbers_arr = in_color_numbers.split(" ")
    color_numbers = (int(color_numbers_arr[0]), int(color_numbers_arr[1]), int(color_numbers_arr[2]))

if (in_color_text == ""):
    color_text = (0, 0, 0)
else:
    color_text_arr = in_color_text.split(" ")
    color_text = (int(color_text_arr[0]), int(color_text_arr[1]), int(color_text_arr[2]))

# Make the label
im = Image.open('./raw files/blank_label.png')
im = im.convert('RGBA')
diffuse = Image.open('./raw files/tape_diffuse.png')
diffuse = diffuse.convert('RGBA')

# Replace colors with those provided. red is replaced with label colors and green is replaced with the bg color
data = np.array(im)   # "data" is a height x width x 4 numpy array
red, green, blue, alpha = data.T # Temporarily unpack the bands for readability

red_areas = (red > 0) & (red > green) & (red > blue)
green_areas = (green > red) & (green > blue) & (green > 0)
data[..., :-1][red_areas.T] = color_label # (R, G, B)
data[..., :-1][green_areas.T] = color_bg

# Create a new image object after replacing the colors
im2 = Image.fromarray(data)

# Add text labels
draw = ImageDraw.Draw(im2)
font_label = ImageFont.truetype('./fonts/Xolonium-Regular.otf', 28) 
font_number = ImageFont.truetype('./fonts/VCR_OSD_MONO.ttf', 30) 

draw.text((376.5, 625), text = label_author, font = font_label, anchor = 'mm', fill = (0, 0, 0))
draw.text((376.5, 857.5), text = label_song_title, font = font_label, anchor = 'mm', fill = color_text)
draw.fontmode = '1'
draw.text((105, 625), text = label_number, font = font_number, anchor = 'mm', fill = color_numbers)

# Make a safe filename and save the file to the output folder
keepcharacters = ('_', '-')
filename = ((label_number + '-' + label_author + '-' + label_song_title).replace(" ", "_")).lower()
filename = "".join(c for c in filename if c.isalnum() or c in keepcharacters).rstrip()

# Load the diffuse map for the tape and overlay this onto it
diffuse.paste(im2, (0, 0), im2)
diffuse.save('./output/' + filename + '.png')
print('Saved label as \'' + filename + '.png\'')

# Make the image a .vtf then remove the .png
print('Making .vtf...')
os.system('.\\VTFCmd\\VTFCmd.exe -file ".\\output\\' + filename + '.png" -format "dxt1"')
print('Saved .vtf')

os.remove('./output/' + filename + '.png')

# Make a .vmt file for the image
f = open('./output/' + filename + '.vmt', 'w')
f.write(""""VertexLitGeneric"
{
	"$basetexture" "models/GreyTheRaptor/cassette_tapes/""" + filename + """"
	"$bumpmap" "models/GreyTheRaptor/cassette_tapes/cassette_tape_normal"
	"$normalmapalphaenvmapmask" 1
	"$surfaceprop" "Computer"
	"$alphatest" 1

	"$phong" 1
	"$phongexponenttexture" "models/GreyTheRaptor/cassette_tapes/cassette_tape_exponent"
	"$phongboost" 10
	"$phongfresnelranges" "[0 0.5 1]"
}""")
f.close()
print('Saved .vmt')