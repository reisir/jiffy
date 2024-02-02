# Jiffy

![jiffy](https://github.com/reisir/jiffy/assets/93496808/218b4c54-6b2c-4b70-9d45-e1239cd9109e)

Rainmeter skin to display any image, animated or not. Drag n Drop an image into any instance of Jiffy to create a new one.

# Prerequisites

- ffmpeg `winget install Gyan.FFmpeg`

# Features

- Handles .gif images
- Handles animated .webp images

# TODO:

- [ ] Learn how to build ffmpeg to bundle in a version with only the image encoders enabled
- [ ] Handle static images
- [ ] Handle video?
- [ ] Add option for frames (around the image)
- [ ] Fix the stitched image being too large 
  - Figure out what the maximum image size in Rainmeter is
  - Scale the output in FFMPEG to fit within Rainmeter limits (better performance, less code)
  - Split the output to multiple stitched images `floor(max / framewidth)` (no limitations (frame can't be bigger than max rainmeter image skull))
